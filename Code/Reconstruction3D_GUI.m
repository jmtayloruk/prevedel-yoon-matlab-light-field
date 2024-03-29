%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Volume reconstruction from light field image
%%
%% Title                : Simultaneous whole-animal 3D-imaging of neuronal activity using light field microscopy
%% Authors              : Robert Prevedel, Young-Gyu Yoon, Maximilian Hoffmann, Nikita Pak, Gordon Wetzstein, Saul Kato, Tina Schr�del, Ramesh Raskar, Manuel Zimmer, Edward S. Boyden and Alipasha Vaziri
%% Authors' Affiliation : Massachusetts Institute of Technology & University of Vienna
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function varargout = Reconstruction3D_GUI(varargin)
% RECONSTRUCTION3D_GUI MATLAB code for Reconstruction3D_GUI.fig
%      RECONSTRUCTION3D_GUI, by itself, creates a new RECONSTRUCTION3D_GUI or raises the existing
%      singleton*.
%
%      H = RECONSTRUCTION3D_GUI returns the handle to a new RECONSTRUCTION3D_GUI or the handle to
%      the existing singleton*.
%
%      RECONSTRUCTION3D_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RECONSTRUCTION3D_GUI.M with the given input arguments.
%
%      RECONSTRUCTION3D_GUI('Property','Value',...) creates a new RECONSTRUCTION3D_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Reconstruction3D_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Reconstruction3D_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Reconstruction3D_GUI

% Last Modified by GUIDE v2.5 20-Mar-2014 17:21:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Reconstruction3D_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Reconstruction3D_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function saveState(handles)

global settingRECON;
fileName = '../RUN/recentsetting_recon.mat';

settingRECON.maxIter = get(handles.editmaxIter, 'string');
settingRECON.FirstFrame = get(handles.editFirstFrame, 'string');
settingRECON.LastFrame = get(handles.editLastFrame, 'string');
settingRECON.DecimationRatio = get(handles.editDecimationRatio, 'string');
settingRECON.GPUON = get(handles.checkboxGPUON, 'Value');
settingRECON.indpIter = get(handles.checkboxindpIter, 'Value');
settingRECON.edgeSuppress = get(handles.checkboxEdgeSuppress, 'Value');
settingRECON.useDiskVariable = get(handles.checkboxDiskVariable, 'Value');
settingRECON.saturate = get(handles.checkboxSaturate, 'Value');
settingRECON.whichSolver  = get(handles.popupmenuWhichSolver,'Value');
settingRECON.saturationGain  = get(handles.editSaturationGain,'string');
settingRECON.contrast  = get(handles.editContrast,'string');
settingRECON.PSFfilenum = 1;

save(fileName, 'settingRECON');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function loadState(handles)
global settingRECON;


fileName = '../RUN/recentsetting_recn.mat';

if exist(fileName)
    load(fileName);    
    set(handles.editmaxIter, 'string', settingRECON.maxIter);
    set(handles.editFirstFrame, 'string', settingRECON.FirstFrame);
    set(handles.editLastFrame, 'string', settingRECON.LastFrame);
    set(handles.editDecimationRatio, 'string', settingRECON.DecimationRatio);   
    set(handles.listboxPSF,'Value', 1);
    set(handles.checkboxGPUON,'Value',settingRECON.GPUON);
    set(handles.checkboxindpIter,'Value',settingRECON.indpIter);
    set(handles.checkboxEdgeSuppress,'Value',settingRECON.edgeSuppress);   
    set(handles.checkboxSaturate, 'Value', settingRECON.saturate);
    set(handles.popupmenuWhichSolver,'Value', settingRECON.whichSolver)
    set(handles.editSaturationGain,'string', settingRECON.saturationGain);
    set(handles.checkboxDiskVariable,'Value', settingRECON.useDiskVariable);
    set(handles.editContrast,'string', settingRECON.contrast);

else
    set(handles.editmaxIter, 'string', '8');
    set(handles.editFirstFrame, 'string', '1');
    set(handles.editLastFrame, 'string', '1');
    set(handles.editDecimationRatio, 'string', '1');   
    set(handles.listboxPSF,'Value', 1);
    set(handles.checkboxGPUON,'Value', 0);
    set(handles.checkboxindpIter,'Value', 1);
    set(handles.checkboxEdgeSuppress, 'Value', 0);
    set(handles.checkboxSaturate, 'Value', 0);
    set(handles.popupmenuWhichSolver,'Value',1);
    set(handles.editSaturationGain,'string', '1');
    set(handles.checkboxDiskVariable,'Value', 0);
    set(handles.editContrast,'string', 0.95);
    
    settingRECON.PSFfilenum = 1;
end
saveState(handles);

fileList = dir('../PSFmatrix/');    

if exist('../PSFmatrix/')==7,
   ; 
else
   mkdir('../PSFmatrix/'); 
end
fileList = dir('../PSFmatrix/');   
PSFfileList = {'Empty'};
i = 1;
for k=1:size(fileList,1)-2,
    tempFileName = fileList(k+2).name;    % JT: changed this from i+2 to k+2 (seems to be simply a bug)
    %disp(tempFileName)
    if strcmp( tempFileName(end-3:end), '.mat' )
        PSFfileList{i} = tempFileName; 
        i = i+1;
    end    
end
settingRECON.PSFfileList = PSFfileList;
set(handles.listboxPSF,'String', settingRECON.PSFfileList); 

settingRECON.inputFilePath = '';
settingRECON.inputFileName = '';
settingRECON.PSFfile = '';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function readState(handles)
global settingRECON;
settingRECON.maxIter = get(handles.editmaxIter, 'string');
settingRECON.FirstFrame = get(handles.editFirstFrame, 'string');
settingRECON.LastFrame = get(handles.editLastFrame, 'string');
settingRECON.DecimationRatio = get(handles.editDecimationRatio, 'string');
settingRECON.PSFfilenum = get(handles.listboxPSF,'Value');
settingRECON.saturationGain  = get(handles.editSaturationGain,'string');
settingRECON.contrast  = get(handles.editContrast,'string');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function checkState(handles)

global settingRECON;
settingRECON.maxIter = get(handles.editmaxIter, 'string');
settingRECON.FirstFrame = get(handles.editFirstFrame, 'string');
settingRECON.LastFrame = get(handles.editLastFrame, 'string');
settingRECON.DecimationRatio = get(handles.editDecimationRatio, 'string');
settingRECON.check = 1;


if mod(str2num(settingRECON.maxIter),1)>0 || str2num(settingRECON.maxIter)<0 ,
   disp(['maxIter should be a positive integer number']); 
   settingRECON.check = 0;
end

if mod(str2num(settingRECON.FirstFrame),1)>0 || str2num(settingRECON.FirstFrame)<1 ,
   disp(['First Frame should be a positive integer number']); 
   settingRECON.check = 0;
end

if mod(str2num(settingRECON.LastFrame),1)>0 || str2num(settingRECON.LastFrame)<1 ,
   disp(['Last Frame should be a positive integer number']); 
   settingRECON.check = 0;
end

if mod(str2num(settingRECON.DecimationRatio),1)>0 || str2num(settingRECON.DecimationRatio)<1 ,
   disp(['Decimation Ratio should be a positive integer number']); 
   settingRECON.check = 0;
end

if isempty([str2num(settingRECON.FirstFrame): str2num(settingRECON.DecimationRatio): str2num(settingRECON.LastFrame)]),
    disp('Frame range is not well defined');
    settingRECON.check = 0;
end

if str2num(settingRECON.saturationGain) < 0, 
   disp(['Saturation gain should be a positive number']); 
   settingRECON.check = 0;
end

if str2num(settingRECON.contrast) <= 0 |  str2num(settingRECON.contrast) > 1,
   disp(['Contrast value should satisfy,  0 < Contrast <= 1']); 
   settingRECON.check = 0;
end

if ~ (exist([settingRECON.inputFilePath settingRECON.inputFileName])==2),
    disp('Input file is not selected');
    settingRECON.check = 0;
end

if ~ (exist(['../PSFmatrix/' settingRECON.PSFfile ])==2),
    disp('PSF file is not selected');
    settingRECON.check = 0;
else
    disp('Using PSF file:')
    disp(settingRECON.PSFfile)
end


if (settingRECON.check>0),
    saveState(handles);
    disp('========= Start volume reconstruction =========');
    Reconstruction3D;
else
   disp('========= Retry after changing the variables according to the message =======');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in Preset.
function Preset_Callback(hObject, eventdata, handles)
% hObject    handle to Preset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.editmaxIter, 'string', '8');
set(handles.editFirstFrame, 'string', '1');
set(handles.editLastFrame, 'string', '1');
set(handles.editDecimationRatio, 'string', '1');   
set(handles.checkboxGPUON,'Value', 0);
set(handles.checkboxindpIter,'Value', 1);
set(handles.checkboxEdgeSuppress,'Value', 0);
% set(handles.listboxPSF,'string', '');
if exist('../PSFmatrix/')==7,
   ; 
else
   mkdir('../PSFmatrix/'); 
end
fileList = dir('../PSFmatrix/');    
PSFfileList = {'Empty'};
i = 1;
for k=1:size(fileList,1)-2,
    tempFileName = fileList(i+2).name;
    if strcmp( tempFileName(end-3:end), '.mat' )
        PSFfileList{i} = tempFileName; 
        i = i+1;
    end    
end
settingRECON.PSFfileList = PSFfileList;
set(handles.listboxPSF,'String', settingRECON.PSFfileList); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% --- Executes just before Reconstruction3D_GUI is made visible.
function Reconstruction3D_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Reconstruction3D_GUI (see VARARGIN)

% Choose default command line output for Reconstruction3D_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

runPath = '../RUN/';
if exist(runPath)==7,
   ; 
else
   mkdir(runPath); 
end
loadState(handles)  ;
% UIWAIT makes Reconstruction3D_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Reconstruction3D_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listboxPSF.
function listboxPSF_Callback(hObject, eventdata, handles)
% hObject    handle to listboxPSF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxPSF contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxPSF
global settingRECON;
settingRECON.PSFfilenum = get(handles.listboxPSF,'Value');
% if ~exist('settingRECON.PSFfilenum','var'),
%     settingRECON.PSFfilenum = 1;
% end
% settingRECON.PSFfilenum
% settingRECON.PSFfileList
settingRECON.PSFfile = settingRECON.PSFfileList{settingRECON.PSFfilenum};
% [M, NA, zmin, zmax, zspacing, Nnum, lambda, OSR, PSFmessage] =  ReadPSFfileName(settingRECON.PSFfile);
%  set(handles.editSHOWPSFFILE,'string', PSFmessage);

% --- Executes during object creation, after setting all properties.
function listboxPSF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxPSF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonBrowser.
function pushbuttonBrowser_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonBrowser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global settingRECON;
[settingRECON.inputFileName, settingRECON.inputFilePath, gfindex] = uigetfile({'*.*',  'All files'}, 'Select data file', '../Data/02_Rectified/');
if gfindex==0,
    settingRECON.inputFilePath = '';
    settingRECON.inputFileName = '';
end


    
% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1


% --- Executes on button press in pushbuttonRUN.
function pushbuttonRUN_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonRUN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
readState(handles);
checkState(handles);






function editmaxIter_Callback(hObject, eventdata, handles)
% hObject    handle to editmaxIter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editmaxIter as text
%        str2double(get(hObject,'String')) returns contents of editmaxIter as a double


% --- Executes during object creation, after setting all properties.
function editmaxIter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editmaxIter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxGPUON.
function checkboxGPUON_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxGPUON (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxGPUON
global settingRECON;
if (((get(hObject,'Value') == get(hObject,'Max'))))
    settingRECON.GPUON = 1;
else
    settingRECON.GPUON = 0;
end







% --- Executes on button press in checkboxEdgeSuppress.
function checkboxEdgeSuppress_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxEdgeSuppress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxEdgeSuppress
global settingRECON;
if (((get(hObject,'Value') == get(hObject,'Max'))))
    settingRECON.edgeSuppress = 1;
else
    settingRECON.edgeSuppress = 0;
end


% --- Executes on button press in checkboxindpIter.
function checkboxindpIter_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxindpIter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxindpIter
global settingRECON;
if (((get(hObject,'Value') == get(hObject,'Max'))))
    settingRECON.indpIter = 1;
else
    settingRECON.indpIter = 0;
end


% --- Executes on selection change in popupmenuWhichSolver.
function popupmenuWhichSolver_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuWhichSolver (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuWhichSolver contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuWhichSolver
settingRECON.whichSolver  = get(hObject,'Value');

% --- Executes during object creation, after setting all properties.
function popupmenuWhichSolver_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuWhichSolver (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editFirstFrame_Callback(hObject, eventdata, handles)
% hObject    handle to editFirstFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editFirstFrame as text
%        str2double(get(hObject,'String')) returns contents of editFirstFrame as a double


% --- Executes during object creation, after setting all properties.
function editFirstFrame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editFirstFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editLastFrame_Callback(hObject, eventdata, handles)
% hObject    handle to editLastFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editLastFrame as text
%        str2double(get(hObject,'String')) returns contents of editLastFrame as a double


% --- Executes during object creation, after setting all properties.
function editLastFrame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editLastFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editDecimationRatio_Callback(hObject, eventdata, handles)
% hObject    handle to editDecimationRatio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDecimationRatio as text
%        str2double(get(hObject,'String')) returns contents of editDecimationRatio as a double


% --- Executes during object creation, after setting all properties.
function editDecimationRatio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDecimationRatio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonRefreshList.
function pushbuttonRefreshList_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonRefreshList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global settingRECON;

if exist('../PSFmatrix/')==7,
   ; 
else
   mkdir('../PSFmatrix/'); 
end
fileList = dir('../PSFmatrix/');    
PSFfileList = {'Empty'};
i = 1;
for k=1:size(fileList,1)-2,
    tempFileName = fileList(i+2).name;
    if strcmp( tempFileName(end-3:end), '.mat' )
        PSFfileList{i} = tempFileName; 
        i = i+1;
    end    
end
settingRECON.PSFfileList = PSFfileList;

set(handles.listboxPSF,'String', settingRECON.PSFfileList); 


% --- Executes on button press in checkboxSaturate.
function checkboxSaturate_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxSaturate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxSaturate
global settingRECON;
if (((get(hObject,'Value') == get(hObject,'Max'))))
    settingRECON.saturate = 1;
else
    settingRECON.saturate = 0;
end



function editSatGain_Callback(hObject, eventdata, handles)
% hObject    handle to editSatGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSatGain as text
%        str2double(get(hObject,'String')) returns contents of editSatGain as a double


% --- Executes during object creation, after setting all properties.
function editSatGain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSatGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editSaturationGain_Callback(hObject, eventdata, handles)
% hObject    handle to editSaturationGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSaturationGain as text
%        str2double(get(hObject,'String')) returns contents of editSaturationGain as a double


% --- Executes during object creation, after setting all properties.
function editSaturationGain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSaturationGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxDiskVariable.
function checkboxDiskVariable_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxDiskVariable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global settingRECON;
if (((get(hObject,'Value') == get(hObject,'Max'))))
    settingRECON.useDiskVariable = 1;
else
    settingRECON.useDiskVariable = 0;
end
% Hint: get(hObject,'Value') returns toggle state of checkboxDiskVariable



function editContrast_Callback(hObject, eventdata, handles)
% hObject    handle to editContrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editContrast as text
%        str2double(get(hObject,'String')) returns contents of editContrast as a double


% --- Executes during object creation, after setting all properties.
function editContrast_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editContrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editSHOWPSFFILE_Callback(hObject, eventdata, handles)
% hObject    handle to editSHOWPSFFILE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSHOWPSFFILE as text
%        str2double(get(hObject,'String')) returns contents of editSHOWPSFFILE as a double


% --- Executes during object creation, after setting all properties.
function editSHOWPSFFILE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSHOWPSFFILE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Reconstruction3D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
warning('off');
addpath('./Util/');

% JT: EDIT ME - provide the correct path to my fast-light-field Python source code
%     (which must also be set up according to the instructions within that module)
%     Depending on how your python and matlab is installed, you may find you need to
%     use the first parameter to initFLF to specify the path to your python binary
initFLF('', '/Users/jonny/Development/fast-light-field');
%initFLF('/local/environments/default/default-venv/bin/python', '/home/jt160j/light-field-flow');


addpath('./Solver/');
eqtol = 1e-10;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('../RUN/recentsetting_recon.mat');

indpIter =  settingRECON.indpIter;                          %% Decide whether or not to run frame-by-frame independent reconstruction
GPUcompute =     settingRECON.GPUON;                        %% Decide whether or not to compute on GPU
PSFfile =   settingRECON.PSFfile;                           %% PSF matrix file for reconstruction
inputFileName = settingRECON.inputFileName;                 %% Input data file to be reconstructed
inputFilePath = settingRECON.inputFilePath;                 %% Input data file path
whichSolver = settingRECON.whichSolver;                     %% Iterations method. Richardson-Lucy Iteration is used, but you can choose
                                                            %%  between the original Preveden/Yoon Matlab code and
                                                            %%  JT's C/python projection code, which is an order of magnitude faster
maxIter = str2num(settingRECON.maxIter);                    %% Number of iteration per each frame. Large number of iteration results in higher resolution/contrast at the price of computation time and pronounced artifacts
FirstFrame = str2num(settingRECON.FirstFrame);              %% If the data is a time series in .mat format, user can decide the range for reconstruction as [FirstFrame:DecimationRatio:LastFrame]
LastFrame = str2num(settingRECON.LastFrame);                %% If the data is a time series in .mat format, user can decide the range for reconstruction as [FirstFrame:DecimationRatio:LastFrame]
DecimationRatio = str2num(settingRECON.DecimationRatio);    %% If the data is a time series in .mat format, user can decide the range for reconstruction as [FirstFrame:DecimationRatio:LastFrame]
saturate = (settingRECON.saturate);                         %% Output will be automatically normalized to the full scale. User can decide to "amplify" the results for better visualization
saturationGain = str2num(settingRECON.saturationGain);      %% Output will be automatically normalized to the full scale. User can decide to "amplify" the results for better visualization
contrast = str2num(settingRECON.contrast);                  %% Contrast adjustment value used if one wants to use the result from last frame as the initial guess for the next frame. contrast<1 is often required to avoid artifact. Low value will result in low contrast in the result.
edgeSuppress = settingRECON.edgeSuppress;                   %% Since border area in the reconstruction result is often subject to artifacts, user can simply assign zeros to the region by turning this option on.
useDiskVariable = settingRECON.useDiskVariable;             %% Result can be directly saved the result on disk in a frame-by-frame manner. Recommended for large data. SSD is strongly recommended.

% JT: EDIT ME - matlabHMatrix flag controls how the H matrix is loaded by this matlab code
%       0: dont load (python code will load the H matrix itself)
%       1: load from disk (standard behaviour)
%       2: reload from matlab base namespace on subsequent run (special optimisation saves some time when running repeatedly)
matlabHMatrix = 1;


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
%%%%%%%% Prepare for the chosen reconstruction algorithm %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global volumeResolution;
if whichSolver == 1,
    % Create a matrix object
    pyMatrixObject = py.psfmatrix.LoadMatrix(['../PSFmatrix/' PSFfile]);
    % Set up other variables we require
    Nnum = int64(py.int(pyMatrixObject.Nnum));
    numZ = int64(py.int(pyMatrixObject.numZ));
    volumeResolution = [size(LFmovie,1)  size(LFmovie,2)  numZ];
    % Set up projection functions
    forwardFUN =  @(Xguess) forwardProjectPLF(pyMatrixObject, Xguess, GPUcompute);
    backwardFUN = @(projection) backwardProjectPLF(pyMatrixObject, projection, GPUcompute);
    % JT: EDIT ME - when reconstructing with my C/python projection code, this variable controls how
    %       many timepoints are reconstructed in parallel. See publication for details,
    %       but 16 or 32 is a good batch size if sufficient RAM is available
    batchProcessingSize = 32;
else,
    Nnum = size(H,3);
    numZ = size(H,5);
    volumeResolution = [size(LFmovie,1)  size(LFmovie,2)  numZ];
    if GPUcompute,
        global zeroImageEx;
        global exsize;
        xsize = [volumeResolution(1), volumeResolution(2)];
        msize = [size(H,1), size(H,2)];
        mmid = floor(msize/2);
        exsize = xsize + mmid;
        exsize = [ min( 2^ceil(log2(exsize(1))), 128*ceil(exsize(1)/128) ), min( 2^ceil(log2(exsize(2))), 128*ceil(exsize(2)/128) ) ];
        zeroImageEx = gpuArray(zeros(exsize, 'single'));
        disp(['FFT size is ' num2str(exsize(1)) 'X' num2str(exsize(2))]);
        % Set up projection functions
        backwardFUN = @(projection) backwardProjectGPU(Ht, projection );
        forwardFUN = @(Xguess) forwardProjectGPU( H, Xguess );
    else
        % Set up projection functions
        forwardFUN =  @(Xguess) forwardProjectACC( H, Xguess, CAindex );
        backwardFUN = @(projection) backwardProjectACC(Ht, projection, CAindex );
    end
    batchProcessingSize = 1;
end
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
