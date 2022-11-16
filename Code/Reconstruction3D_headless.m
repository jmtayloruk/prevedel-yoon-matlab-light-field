%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Volume reconstruction from light field image
%%
%% Title                : Simultaneous whole-animal 3D-imaging of neuronal activity using light field microscopy
%% Authors              : Robert Prevedel, Young-Gyu Yoon, Maximilian Hoffmann, Nikita Pak, Gordon Wetzstein, Saul Kato, Tina Schrödel, Ramesh Raskar, Manuel Zimmer, Edward S. Boyden and Alipasha Vaziri
%% Authors' Affiliation : Massachusetts Institute of Technology & University of Vienna
%%
%%
%%  JT: This file is an edited copy of Reconstruction3D_GUI.m that can run without a GUI.
%%  This is useful when running on a compute server without a GUI.
%%  To run it, edit the path in the load() command (below, marked "EDIT ME")
%%  to point to a previously-generated settings file from a GUI-based run
%%  (recentsetting_recon.mat contains the last-used GUI settings),
%%  and/or override some of the settings subsequently in this script (again, see "EDIT ME")
%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Reconstruction3D_headless
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
warning('off');
addpath('./Util/');
addpath('./Solver/');
eqtol = 1e-10;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% JT: EDIT ME - provide the path to the previously-generated settings file to use for this GUI-free reconstruction script
load('../RUN/recentsetting_recon.mat');

% Standard code to extract variables from the settings file
indpIter =  settingRECON.indpIter;                          %% Decide whether or not to run frame-by-frame independent reconstruction
GPUcompute =     settingRECON.GPUON;                        %% Decide whether or not to compute on GPU
PSFfile =   settingRECON.PSFfile;                           %% PSF matrix file for reconstruction
inputFileName = settingRECON.inputFileName;                 %% Input data file to be reconstructed
inputFilePath = settingRECON.inputFilePath;                 %% Input data file path
whichSolver = settingRECON.whichSolver;                     %% Iterations method. Current version supports only Richardson-Lucy Iteration
maxIter = str2num(settingRECON.maxIter);                    %% Number of iteration per each frame. Large number of iteration results in higher resolution/contrast at the price of computation time and pronounced artifacts
FirstFrame = str2num(settingRECON.FirstFrame);              %% If the data is a time series in .mat format, user can decide the range for reconstruction as [FirstFrame:DecimationRatio:LastFrame]
LastFrame = str2num(settingRECON.LastFrame);                %% If the data is a time series in .mat format, user can decide the range for reconstruction as [FirstFrame:DecimationRatio:LastFrame]
DecimationRatio = str2num(settingRECON.DecimationRatio);    %% If the data is a time series in .mat format, user can decide the range for reconstruction as [FirstFrame:DecimationRatio:LastFrame]
saturate = (settingRECON.saturate);                         %% Output will be automatically normalized to the full scale. User can decide to "amplify" the results for better visualization
saturationGain = str2num(settingRECON.saturationGain);      %% Output will be automatically normalized to the full scale. User can decide to "amplify" the results for better visualization
contrast = str2num(settingRECON.contrast);                  %% Contrast adjustment value used if one wants to use the result from last frame as the initial guess for the next frame. contrast<1 is often required to avoid artifact. Low value will result in low contrast in the result.
edgeSuppress = settingRECON.edgeSuppress;                   %% Since border area in the reconstruction result is often subject to artifacts, user can simply assign zeros to the region by turning this option on.
useDiskVariable = settingRECON.useDiskVariable;             %% Result can be directly saved the result on disk in a frame-by-frame manner. Recommended for large data. SSD is strongly recommended.

% JT: EDIT ME - here we override any settings that should be modified compared to the settings file loaded above
PSFfile = 'PSFmatrix_M22.222NA0.5MLPitch125fml3125from-5to5zspacing5Nnum19lambda520n1.33.mat'
inputFilePath = '~/Development/prevedel-matlab-light-field/Data/02_Rectified/'
inputFileName = 'Olaf_Nils_LFImagex32.tif'
maxIter = 4
LastFrame = 32

% JT: EDIT ME - projectionMethod flag controls what code is used for the light field reconstruction
%       0: matlab cpu [standard behaviour]
%       1: matlab gpu [which in my experience is not very efficient, but may be faster than running on CPU]
%       2: PLF cpu    [uses my C/python projection code, which is an order of magnitude faster,
%                      especially when processing batches of images from a timelapse]
projectionMethod = 0

% JT: EDIT ME - matlabHMatrix flag controls how the H matrix is loaded by this matlab code
%       0: dont load (python code will load the H matrix itself)
%       1: load from disk (standard behaviour)
%       2: reload from matlab base namespace on subsequent run (special optimisation saves some time when running repeatedly)
matlabHMatrix = 1

% JT: EDIT ME - when reconstructing with my C/python projection code, this variable controls how
%       many timepoints are reconstructed in parallel. See publication for details,
%       but 16 or 32 is a good batch size if sufficient RAM is available
batchProcessingSize = 32;

savePath = ['../Data/03_Reconstructed/' inputFilePath( findstr(inputFilePath, '/Data/02_Rectified/') + 19 : end)];
if exist(savePath)==7,
   ; 
else
   mkdir(savePath); 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% PREPARE PARALLEL COMPUTING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This part is not necessary for MATLAB 2014a or later version
%if parpool('size') == 0 % checking to see if my pool is already open
%    parpool open
%end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% Load Data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (matlabHMatrix == 1)
    load(['../PSFmatrix/' PSFfile]);
    if class(H)=='double',
        H = single(H);
        Ht = single(Ht);
    end
    disp(['Successfully loaded PSF matrix : ' PSFfile]);
    disp(['Size of PSF matrix is : ' num2str(size(H)) ]);
    assignin('base', 'H', H)
    assignin('base', 'Ht', Ht)
    assignin('base', 'CAindex', CAindex)
elseif (matlabHMatrix == 2)
    H = evalin('base', 'H');
    Ht = evalin('base', 'Ht');
    CAindex = evalin('base', 'CAindex');
end
MV3Dgain = 1.0;

if strcmp( inputFileName(end-3:end), '.tif')
    % JT: enhanced this code to read multi-page TIFFs as a time series
    % JT: this used to have im2double instead of double.
    %     The former changes range to 0-1. I prefer to leave as the unchanged original,
    %     which ensures I can compare this output with my own Python code.
    LFmovie = double(imread([inputFilePath inputFileName],'tiff',FirstFrame));
    subsequentFrames = FirstFrame+DecimationRatio:DecimationRatio:LastFrame;
    n = 2;
    for f = subsequentFrames,
        temp = double(imread([inputFilePath inputFileName],'tiff',f));
        LFmovie(:,:,n) = temp;
        n = n + 1;
    end
elseif strcmp( inputFileName(end-3:end), '.mat')
    load([inputFilePath inputFileName]);  
else
    disp('input should be a single TIFF file or a mat file (both need to be rectified');
end

disp(['Successfully loaded input data']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% Prepare for CPU or GPU computation %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (projectionMethod == 0),
    forwardFUN =  @(Xguess) forwardProjectACC( H, Xguess, CAindex );
    backwardFUN = @(projection) backwardProjectACC(Ht, projection, CAindex );
    batchProcessingSize = 1;
    numZ = size(H,5);
    Nnum = size(H,3);
elseif (projectionMethod == 1),
    backwardFUN = @(projection) backwardProjectGPU(Ht, projection );
    forwardFUN = @(Xguess) forwardProjectGPU( H, Xguess );
    
    global zeroImageEx;
    global exsize;
    xsize = [volumeResolution(1), volumeResolution(2)];
    msize = [size(H,1), size(H,2)];
    mmid = floor(msize/2);
    exsize = xsize + mmid;  
    exsize = [ min( 2^ceil(log2(exsize(1))), 128*ceil(exsize(1)/128) ), min( 2^ceil(log2(exsize(2))), 128*ceil(exsize(2)/128) ) ];    
    zeroImageEx = gpuArray(zeros(exsize, 'single'));
    batchProcessingSize = 1;
    numZ = size(H,5);
    Nnum = size(H,3);
else
    disp(['Using fast C/Python projection code'])
    PSFpath = ['../PSFmatrix/' PSFfile];
    pyMatrixObject = initPLF(PSFpath, '');
    forwardFUN =  @(Xguess) forwardProjectPLF(pyMatrixObject, Xguess, 0);
    backwardFUN = @(projection) backwardProjectPLF(pyMatrixObject, projection, 0);
    numZ = int64(py.matlab_wrapper.NumZForMatrix(pyMatrixObject));
    Nnum = int64(py.matlab_wrapper.NnumForMatrix(pyMatrixObject));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% Check data size  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lightFieldResolution = [size(LFmovie,1), size(LFmovie,2)];
global volumeResolution ;
volumeResolution = [size(LFmovie,1)  size(LFmovie,2)  numZ];
disp(['Image size is ' num2str(volumeResolution(1)) 'X' num2str(volumeResolution(2))]); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% RUN Reconstruction %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ReconFrames = [FirstFrame:DecimationRatio: min(LastFrame, size(LFmovie,3))];
numFrames = length(ReconFrames);
if useDiskVariable,
    movie3Drecon = zeros([volumeResolution(1), volumeResolution(2), volumeResolution(3), 2], 'uint8');
    save([savePath 'Recon3D_'  inputFileName(1:end-4)], 'movie3Drecon', '-v7.3');      
    m = matfile([savePath 'Recon3D_'  inputFileName(1:end-4)], 'Writable', true);
    disp(['Use disk variable']);
else
    Xvolumeseries = zeros([volumeResolution(1), volumeResolution(2), volumeResolution(3), numFrames]);
end

k = 1;

while (1)
    thisBatchSize = min(size(ReconFrames(k:end),2), batchProcessingSize);
    frames = ReconFrames(k:k+thisBatchSize-1);
    if thisBatchSize > 1,
        disp(['Volume reconstruction of Frames # ' num2str(k) '-' num2str(k+thisBatchSize-1) ' / ' num2str(numFrames) ' is ongoing...']);
    else
        disp(['Volume reconstruction of Frame # ' num2str(k) ' / ' num2str(numFrames) ' is ongoing...']);
    end
    LFIMG = single(LFmovie(:,:,frames));
    
    %%% Iteration 0
    t0 = tic; Htf = backwardFUN(LFIMG); ttime = toc(t0);
    disp(['  iter ' num2str(0) ' | ' num2str(maxIter) ', took ' num2str(ttime) ' secs']);

    %%% Make initial guess to seed the deconvolution
    if k==1,
        Xguess = Htf;
    elseif indpIter,
        % Use the initial backprojection as the seed for the deconvolution
        Xguess = Htf;
    else
       ; 
    end
    if k>1,
        if ~indpIter,
            Xguess = contrastAdjust(Xguess, contrast);
            maxIter = 1;
        end
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Xguess = deconvRL(forwardFUN, backwardFUN, Htf, maxIter, Xguess );

    ttime = toc(t0);
    disp(['Complete calculation took ' num2str(ttime) ' secs']);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %%% Adjust the full scale of the reconstruction result
    if k==1,
        MV3Dgain = gather(0.66/max(Xguess(:))); %% full scale is inferred from the reconstruction result of the first frame
    end
    
    if GPUcompute,
       XguessCPU = gather(Xguess);
    else
       XguessCPU = Xguess;
    end    
    
    
    %%% Save the results on disk (only if specified to use disk variable)
    if useDiskVariable,
        Xvolume = uint8(round(255*MV3Dgain*XguessCPU));  
        if edgeSuppress,                 
            Xvolume( (1:1*Nnum), :,:) = 0;
            Xvolume( (end-1*Nnum+1:end), :,:) = 0;
            Xvolume( :,(1:1*Nnum), :) = 0;
            Xvolume( :,(end-1*Nnum+1:end), :) = 0;
        end
        tic;
        m.movie3Drecon(:,:,:,k:k+thisBatchSize-1) = permute(Xvolume, [1,2,4,3]);
        ttime = toc;
        disp(['Writing time: ' num2str(ttime) ' secs']);
    else
        Xvolumeseries(:,:,:,k:k+thisBatchSize-1) = permute(XguessCPU, [1,2,4,3]);
    end

    k = k + thisBatchSize;
    if k > size(ReconFrames,2),
        break
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Post-processing the result...');

if edgeSuppress,            
    Xvolumeseries( (1:1*Nnum), :,:) = 0;
    Xvolumeseries( (end-1*Nnum+1:end), :,:) = 0;
    Xvolumeseries( :,(1:1*Nnum), :) = 0;
    Xvolumeseries( :,(end-1*Nnum+1:end), :) = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Save the results %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Saving to disk...');
for f = 1:size(Xvolumeseries,4),
    frame = Xvolumeseries(:,:,:,f);

    XguessSAVE = uint16(round(1*65535*frame/max(frame(:))));
    %XguessSAVE = uint16(round(frame*1e3));
    destFile = [savePath 'Recon3D_' inputFileName(1:end-4) '_' num2str(f) '.tif'];
    imwrite( squeeze(XguessSAVE(:,:,1)), destFile, 'Compression', 'none');
    for k = 2:size(XguessSAVE,3),
        imwrite(squeeze(XguessSAVE(:,:,k)),  destFile, 'Compression', 'none', 'WriteMode', 'append');
    end
    
    if saturate,
        XguessSAVE2 = uint16(round(saturationGain*65535*frame/max(frame(:))));    
        destFile = [savePath 'Recon3D_saturate_' inputFileName(1:end-4) '_' num2str(f) '.tif'];
        imwrite( squeeze(XguessSAVE2(:,:,2)), destFile, 'Compression', 'none');
        for k = 2:size(XguessSAVE2,3)
            imwrite(squeeze(XguessSAVE2(:,:,k)),  destFile, 'Compression', 'none', 'WriteMode', 'append');
        end        
    end
end

if (ndims(Xvolumeseries) == 3) || (~useDiskVariable),
    save([savePath 'Recon3D_'  inputFileName(1:end-4)], 'Xvolumeseries', '-v7.3');      
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['Volume reconstruction complete.']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
