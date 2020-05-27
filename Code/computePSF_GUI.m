%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Volume reconstruction from light field image
%%
%% Title                : Simultaneous whole-animal 3D-imaging of neuronal activity using light field microscopy
%% Authors              : Robert Prevedel, Young-Gyu Yoon, Maximilian Hoffmann, Nikita Pak, Gordon Wetzstein, Saul Kato, Tina Schrödel, Ramesh Raskar, Manuel Zimmer, Edward S. Boyden and Alipasha Vaziri
%% Authors' Affiliation : Massachusetts Institute of Technology & University of Vienna
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function varargout = computePSF_GUI(varargin)
% COMPUTEPSF_GUI MATLAB code for computePSF_GUI.fig
%      COMPUTEPSF_GUI, by itself, creates a new COMPUTEPSF_GUI or raises the existing
%      singleton*.
%
%      H = COMPUTEPSF_GUI returns the handle to a new COMPUTEPSF_GUI or the handle to
%      the existing singleton*.
%
%      COMPUTEPSF_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMPUTEPSF_GUI.M with the given input arguments.
%
%      COMPUTEPSF_GUI('Property','Value',...) creates a new COMPUTEPSF_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before computePSF_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to computePSF_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help computePSF_GUI

% Last Modified by GUIDE v2.5 20-Feb-2014 18:59:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @computePSF_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @computePSF_GUI_OutputFcn, ...
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function saveState(handles)

fileName = '../RUN/recentsetting_PSF.mat';

settingPSF.M = get(handles.editM, 'string');
settingPSF.MLPitch = get(handles.editMLPitch, 'string');
settingPSF.NA = get(handles.editNA, 'string');
settingPSF.Nnum = get(handles.editNnum, 'string');
settingPSF.OSR = get(handles.editOSR, 'string');
settingPSF.fml = get(handles.editfml, 'string');
settingPSF.lambda = get(handles.editlambda, 'string');
settingPSF.n = get(handles.editn, 'string');
settingPSF.zmax = get(handles.editzmax, 'string');
settingPSF.zmin = get(handles.editzmin, 'string');
settingPSF.zspacing = get(handles.editzspacing, 'string');  

save(fileName, 'settingPSF');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function loadState(handles)

fileName = '../RUN/recentsetting_PSF.mat';
if exist(fileName)
    load(fileName);
    global settingPSF;
    set(handles.editM, 'string', settingPSF.M);
    set(handles.editMLPitch, 'string', settingPSF.MLPitch);
    set(handles.editNA, 'string', settingPSF.NA);
    set(handles.editNnum, 'string', settingPSF.Nnum);
    set(handles.editOSR, 'string', settingPSF.OSR);    
    set(handles.editfml, 'string', settingPSF.fml);
    set(handles.editlambda, 'string', settingPSF.lambda);
    set(handles.editn, 'string', settingPSF.n);
    set(handles.editzmax, 'string', settingPSF.zmax);
    set(handles.editzmin, 'string', settingPSF.zmin);
    set(handles.editzspacing, 'string', settingPSF.zspacing);  
    settingPSF.check = 1;
else
    set(handles.editM, 'string', '40');
    set(handles.editMLPitch, 'string', '150');
    set(handles.editNA, 'string', '0.95');
    set(handles.editNnum, 'string', '15');
    set(handles.editOSR, 'string', '3');    
    set(handles.editfml, 'string', '3000');
    set(handles.editlambda, 'string', '520');
    set(handles.editn, 'string', '1.0');
    set(handles.editzmax, 'string', '0');
    set(handles.editzmin, 'string', '-26');
    set(handles.editzspacing, 'string', '2');  
    saveState(handles);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function readState(handles)

global settingPSF;
settingPSF.M = get(handles.editM, 'string');
settingPSF.MLPitch = get(handles.editMLPitch, 'string');
settingPSF.NA = get(handles.editNA, 'string');
settingPSF.Nnum = get(handles.editNnum, 'string');
settingPSF.OSR = get(handles.editOSR, 'string');
settingPSF.fml = get(handles.editfml, 'string');
settingPSF.lambda = get(handles.editlambda, 'string');
settingPSF.n = get(handles.editn, 'string');
settingPSF.zmax = get(handles.editzmax, 'string');
settingPSF.zmin = get(handles.editzmin, 'string');
settingPSF.zspacing = get(handles.editzspacing, 'string');  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function checkState(handles)

global settingPSF;
settingPSF.M = get(handles.editM, 'string');
settingPSF.MLPitch = get(handles.editMLPitch, 'string');
settingPSF.NA = get(handles.editNA, 'string');
settingPSF.Nnum = get(handles.editNnum, 'string');
settingPSF.OSR = get(handles.editOSR, 'string');
settingPSF.fml = get(handles.editfml, 'string');
settingPSF.lambda = get(handles.editlambda, 'string');
settingPSF.n = get(handles.editn, 'string');
settingPSF.zmax = get(handles.editzmax, 'string');
settingPSF.zmin = get(handles.editzmin, 'string');
settingPSF.zspacing = get(handles.editzspacing, 'string');  
settingPSF.check = 1;

if ~( str2num(settingPSF.M)>0),
    disp('M should be larger than 0');
    settingPSF.check = 0;
end
if ~(str2num(settingPSF.NA)>0),
    disp('NA should be larger than 0');
    settingPSF.check = 0;
end
if mod(str2num(settingPSF.Nnum),2)==0 || mod(str2num(settingPSF.Nnum),1)>0 || str2num(settingPSF.Nnum)<1  ,
   disp(['Nnum should be an odd integer number']); 
   settingPSF.check = 0;
end
if mod(str2num(settingPSF.OSR),2)==0 || mod(str2num(settingPSF.OSR),1)>0 || str2num(settingPSF.OSR)<1  ,
   disp(['OSR should be an odd integer number']); 
   settingPSF.check = 0;
end
if ~(str2num(settingPSF.fml)>0),
    disp('fml should be larger than 0');
    settingPSF.check = 0;
end
if ~(str2num(settingPSF.lambda)>0),
    disp('lambda should be larger than 0');
    settingPSF.check = 0;
end
if ~(str2num(settingPSF.n)>=1),
    disp('n should be larger than 1');
    settingPSF.check = 0;
end
if isempty([str2num(settingPSF.zmin): str2num(settingPSF.zspacing): str2num(settingPSF.zmax)]),
    disp('Axial range is not well defined');
    settingPSF.check = 0;
end

if (settingPSF.check>0),
    saveState(handles);
    disp('========= Start computing PSF =========');
    computePSF;
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


set(handles.editM, 'string', '40');
set(handles.editMLPitch, 'string', '150');
set(handles.editNA, 'string', '0.95');
set(handles.editNnum, 'string', '15');
set(handles.editOSR, 'string', '3');    
set(handles.editfml, 'string', '3000');
set(handles.editlambda, 'string', '520');
set(handles.editn, 'string', '1.0');
set(handles.editzmax, 'string', '10');
set(handles.editzmin, 'string', '-10');
set(handles.editzspacing, 'string', '2');  
   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% --- Executes just before computePSF_GUI is made visible.
function computePSF_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to computePSF_GUI (see VARARGIN)

% Choose default command line output for computePSF_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


runPath = '../RUN/';
if exist(runPath)==7,
   ; 
else
   mkdir(runPath); 
end

loadState(handles);
% UIWAIT makes computePSF_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);





% --- Outputs from this function are returned to the command line.
function varargout = computePSF_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

readState(handles);
checkState(handles);



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editfml_Callback(hObject, eventdata, handles)
% hObject    handle to editfml (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editfml as text
%        str2double(get(hObject,'String')) returns contents of editfml as a double


% --- Executes during object creation, after setting all properties.
function editfml_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editfml (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editMLPitch_Callback(hObject, eventdata, handles)
% hObject    handle to editMLPitch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMLPitch as text
%        str2double(get(hObject,'String')) returns contents of editMLPitch as a double


% --- Executes during object creation, after setting all properties.
function editMLPitch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMLPitch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editM_Callback(hObject, eventdata, handles)
% hObject    handle to editM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editM as text
%        str2double(get(hObject,'String')) returns contents of editM as a double


% --- Executes during object creation, after setting all properties.
function editM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editNA_Callback(hObject, eventdata, handles)
% hObject    handle to editNA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editNA as text
%        str2double(get(hObject,'String')) returns contents of editNA as a double


% --- Executes during object creation, after setting all properties.
function editNA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editn_Callback(hObject, eventdata, handles)
% hObject    handle to editn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editn as text
%        str2double(get(hObject,'String')) returns contents of editn as a double


% --- Executes during object creation, after setting all properties.
function editn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editlambda_Callback(hObject, eventdata, handles)
% hObject    handle to editlambda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editlambda as text
%        str2double(get(hObject,'String')) returns contents of editlambda as a double


% --- Executes during object creation, after setting all properties.
function editlambda_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editlambda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editzmin_Callback(hObject, eventdata, handles)
% hObject    handle to editzmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editzmin as text
%        str2double(get(hObject,'String')) returns contents of editzmin as a double


% --- Executes during object creation, after setting all properties.
function editzmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editzmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editzmax_Callback(hObject, eventdata, handles)
% hObject    handle to editzmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editzmax as text
%        str2double(get(hObject,'String')) returns contents of editzmax as a double


% --- Executes during object creation, after setting all properties.
function editzmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editzmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editOSR_Callback(hObject, eventdata, handles)
% hObject    handle to editOSR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editOSR as text
%        str2double(get(hObject,'String')) returns contents of editOSR as a double


% --- Executes during object creation, after setting all properties.
function editOSR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editOSR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editzspacing_Callback(hObject, eventdata, handles)
% hObject    handle to editzspacing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editzspacing as text
%        str2double(get(hObject,'String')) returns contents of editzspacing as a double


% --- Executes during object creation, after setting all properties.
function editzspacing_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editzspacing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editNnum_Callback(hObject, eventdata, handles)
% hObject    handle to editNnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editNnum as text
%        str2double(get(hObject,'String')) returns contents of editNnum as a double


% --- Executes during object creation, after setting all properties.
function editNnum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editNnum (see GCBO)
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
function computePSF
warning('off');
addpath('./Util/');
savePath = '../PSFmatrix/';
if exist(savePath)==7,
   ; 
else
   mkdir(savePath); 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('../RUN/recentsetting_PSF.mat');
fileName = ['PSFmatrix_'  'M' settingPSF.M  'NA' settingPSF.NA 'MLPitch' settingPSF.MLPitch 'fml' settingPSF.fml 'from' settingPSF.zmin 'to' settingPSF.zmax  'zspacing' settingPSF.zspacing 'Nnum' settingPSF.Nnum  'lambda' settingPSF.lambda 'n' settingPSF.n '.mat' ];
M =         str2num(settingPSF.M);
NA =        str2num(settingPSF.NA);
MLPitch =   str2num(settingPSF.MLPitch)*1e-6;
Nnum =      str2num(settingPSF.Nnum);
OSR =       str2num(settingPSF.OSR);
n =         str2num(settingPSF.n);
fml =       str2num(settingPSF.fml)*1e-6;
lambda =    str2num(settingPSF.lambda)*1e-9;
zmax =      str2num(settingPSF.zmax)*1e-6;
zmin =      str2num(settingPSF.zmin)*1e-6;
zspacing =  str2num(settingPSF.zspacing)*1e-6;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eqtol = 1e-10;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%% PREPARE PARALLAL COMPUTING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if matlabpool('size') == 0 % checking to see if my pool is already open
    matlabpool open
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%% SIM PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%
k = 2*pi*n/lambda; %% k
k0 = 2*pi*1/lambda; %% k
d = fml;   %% optical distance between the microlens and the sensor
ftl = 200e-3;        %% focal length of tube lens
fobj = ftl/M;  %% focal length of objective lens
fnum_obj = M/(2*NA); %% f-number of objective lens (imaging-side)
fnum_ml = fml/MLPitch; %% f-number of micrl lens
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%% DEFINE OBJECT SPACE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if mod(Nnum,2)==0,
   error(['Nnum should be an odd number']); 
end
pixelPitch = MLPitch/Nnum; %% pitch of virtual pixels

x1objspace = [0]; 
x2objspace = [0];
x3objspace = [zmin:zspacing:zmax];
objspace = ones(length(x1objspace),length(x2objspace),length(x3objspace));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p3max = max(abs(x3objspace));
x1testspace = (pixelPitch/OSR)* [0:1: Nnum*OSR*20];
x2testspace = [0];   
[psfLine] = calcPSFFT(p3max, fobj, NA, x1testspace, pixelPitch/OSR, lambda, d, M, n);
outArea = find(psfLine<0.04);
if isempty(outArea),
   error('Estimated PSF size exceeds the limit');   
end
IMGSIZE_REF = ceil(outArea(1)/(OSR*Nnum));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%% OTHER SIMULATION PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%
disp(['Size of PSF ~= ' num2str(IMGSIZE_REF) ' [microlens pitch]' ]);
IMG_HALFWIDTH = max( Nnum*(IMGSIZE_REF + 1), 2*Nnum);
disp(['Size of IMAGE = ' num2str(IMG_HALFWIDTH*2*OSR+1) 'X' num2str(IMG_HALFWIDTH*2*OSR+1) '' ]);
x1space = (pixelPitch/OSR)*[-IMG_HALFWIDTH*OSR:1:IMG_HALFWIDTH*OSR]; 
x2space = (pixelPitch/OSR)*[-IMG_HALFWIDTH*OSR:1:IMG_HALFWIDTH*OSR]; 
x1length = length(x1space);
x2length = length(x2space);

x1MLspace = (pixelPitch/OSR)* [-(Nnum*OSR-1)/2 : 1 : (Nnum*OSR-1)/2];
x2MLspace = (pixelPitch/OSR)* [-(Nnum*OSR-1)/2 : 1 : (Nnum*OSR-1)/2];
x1MLdist = length(x1MLspace);
x2MLdist = length(x2MLspace);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%% FIND NON-ZERO POINTS %%%%%%%%%%%%%%%%%%%%%%%%%%
validpts = find(objspace>eqtol);
numpts = length(validpts);
[p1indALL p2indALL p3indALL] = ind2sub( size(objspace), validpts);
p1ALL = x1objspace(p1indALL)';
p2ALL = x2objspace(p2indALL)';
p3ALL = x3objspace(p3indALL)';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%% DEFINE ML ARRAY %%%%%%%%%%%%%%%%%%%%%%%%% 
MLARRAY = calcML(fml, k0, x1MLspace, x2MLspace, x1space, x2space); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%%%%%%%%%%%%%%%%%%%%%% Alocate Memory for storing PSFs %%%%%%%%%%%   
LFpsfWAVE_STACK = zeros(x1length, x2length, numpts);
psfWAVE_STACK = zeros(x1length, x2length, numpts);
disp(['Start Calculating PSF...']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%% PROJECTION FROM SINGLE POINT %%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
centerPT = ceil(length(x1space)/2);
halfWidth =  Nnum*(IMGSIZE_REF + 0 )*OSR;
centerArea = (  max((centerPT - halfWidth),1)   :   min((centerPT + halfWidth),length(x1space))     );

disp(['Computing PSFs (1/3)']);
for eachpt=1:numpts,        
    p1 = p1ALL(eachpt);
    p2 = p2ALL(eachpt);
    p3 = p3ALL(eachpt);
    
    IMGSIZE_REF_IL = ceil(IMGSIZE_REF*( abs(p3)/p3max));
    halfWidth_IL =  max(Nnum*(IMGSIZE_REF_IL + 0 )*OSR, 2*Nnum*OSR);
    centerArea_IL = (  max((centerPT - halfWidth_IL),1)   :   min((centerPT + halfWidth_IL),length(x1space))     );
    disp(['size of center area = ' num2str(length(centerArea_IL)) 'X' num2str(length(centerArea_IL)) ]);    
    
    %% excute PSF computing funcion
    [psfWAVE LFpsfWAVE] = calcPSF(p1, p2, p3, fobj, NA, x1space, x2space, pixelPitch/OSR, lambda, MLARRAY, d, M, n,  centerArea_IL);
    psfWAVE_STACK(:,:,eachpt)  = psfWAVE;
    LFpsfWAVE_STACK(:,:,eachpt)= LFpsfWAVE;    

end 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%% Compute Light Field PSFs (light field) %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
x1objspace = (pixelPitch/M)*[-floor(Nnum/2):1:floor(Nnum/2)];
x2objspace = (pixelPitch/M)*[-floor(Nnum/2):1:floor(Nnum/2)];
XREF = ceil(length(x1objspace)/2);
YREF = ceil(length(x1objspace)/2);
CP = ( (centerPT-1)/OSR+1 - halfWidth/OSR :1: (centerPT-1)/OSR+1 + halfWidth/OSR  );
H = zeros( length(CP), length(CP), length(x1objspace), length(x2objspace), length(x3objspace) );

disp(['Computing LF PSFs (2/3)']);
for i=1:length(x1objspace)*length(x2objspace)*length(x3objspace) ,
    [a, b, c] = ind2sub([length(x1objspace) length(x2objspace) length(x3objspace)], i);  
     psfREF = psfWAVE_STACK(:,:,c);  
     
     psfSHIFT= im_shift2(psfREF, OSR*(a-XREF), OSR*(b-YREF) );
     [f1,dx1,x1]=fresnel2D(psfSHIFT.*MLARRAY, pixelPitch/OSR, d,lambda);
     f1= im_shift2(f1, -OSR*(a-XREF), -OSR*(b-YREF) );
     
     xmin =  max( centerPT  - halfWidth, 1);
     xmax =  min( centerPT  + halfWidth, size(f1,1) );
     ymin =  max( centerPT  - halfWidth, 1);
     ymax =  min( centerPT  + halfWidth, size(f1,2) );
 
     f1_AP = zeros(size(f1));
     f1_AP( (xmin:xmax), (ymin:ymax) ) = f1( (xmin:xmax), (ymin:ymax) );
     [f1_AP_resize, x1shift, x2shift] = pixelBinning(abs(f1_AP.^2), OSR);           
     f1_CP = f1_AP_resize( CP - x1shift, CP-x2shift );

     H(:,:,a,b,c) = f1_CP;
     

end
H = H/max(H(:));

x1space = (pixelPitch/1)*[-IMG_HALFWIDTH*1:1:IMG_HALFWIDTH*1];
x2space = (pixelPitch/1)*[-IMG_HALFWIDTH*1:1:IMG_HALFWIDTH*1]; 
x1space = x1space(CP);
x2space = x2space(CP);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%% Clear variables that are no longer necessary %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear LFpsfWAVE_STACK;
clear LFpsfWAVE_VIEW;
clear psfWAVE_STACK;
clear psfWAVE_VIEW;
clear LFpsfWAVE;
clear PSF_AP;
clear PSF_AP_resize;
clear PSF_CP;
clear f1;
clear f1_AP;
clear f1_AP_resize;
clear f1_CP;
clear psfREF;
clear psfSHIFT;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tol = 0.005;
for i=1:size(H,5),
   H4Dslice = H(:,:,:,:,i);
   H4Dslice(find(H4Dslice< (tol*max(H4Dslice(:))) )) = 0;
   H(:,:,:,:,i) = H4Dslice;   
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%% Calculate Ht (transpose for backprojection) %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
disp(['Computing Transpose (3/3)']);
Ht = calcHt(H);
H = single(H);
Ht = single(Ht);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%% Estimate PSF size again  %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
centerCP = ceil(length(CP)/2);
CAindex = zeros(length(x3objspace),2);
for i=1:length(x3objspace),
    IMGSIZE_REF_IL = ceil(IMGSIZE_REF*( abs(x3objspace(i))/p3max));
    halfWidth_IL =  max(Nnum*(IMGSIZE_REF_IL + 0 ), 2*Nnum);
    CAindex(i,1) = max( centerCP - halfWidth_IL , 1);
    CAindex(i,2) = min( centerCP + halfWidth_IL , size(H,1));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
disp(['Saving PSF matrix file...']);
save([savePath fileName] , 'H','Ht', 'CAindex', 'settingPSF', 'OSR', 'fobj', 'd', 'NA', 'objspace', 'M', 'MLARRAY', 'zspacing','x1objspace', 'x2objspace', 'x3objspace', 'pixelPitch', 'x1space','x2space', 'CP','Nnum' ,'-v7.3');
disp(['PSF computation complete.']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%