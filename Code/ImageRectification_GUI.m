%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Volume reconstruction from light field image
%%
%% Title                : Simultaneous whole-animal 3D-imaging of neuronal activity using light field microscopy
%% Authors              : Robert Prevedel, Young-Gyu Yoon, Maximilian Hoffmann, Nikita Pak, Gordon Wetzstein, Saul Kato, Tina Schrödel, Ramesh Raskar, Manuel Zimmer, Edward S. Boyden and Alipasha Vaziri
%% Authors' Affiliation : Massachusetts Institute of Technology & University of Vienna
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function varargout = ImageRectification_GUI(varargin)
% IMAGERECTIFICATION_GUI MATLAB code for ImageRectification_GUI.fig
%      IMAGERECTIFICATION_GUI, by itself, creates a new IMAGERECTIFICATION_GUI or raises the existing
%      singleton*.
%
%      H = IMAGERECTIFICATION_GUI returns the handle to a new IMAGERECTIFICATION_GUI or the handle to
%      the existing singleton*.
%
%      IMAGERECTIFICATION_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGERECTIFICATION_GUI.M with the given input arguments.
%
%      IMAGERECTIFICATION_GUI('Property','Value',...) creates a new IMAGERECTIFICATION_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ImageRectification_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ImageRectification_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ImageRectification_GUI

% Last Modified by GUIDE v2.5 02-Feb-2014 14:49:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImageRectification_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ImageRectification_GUI_OutputFcn, ...
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

global settingRECT;
fileName = '../RUN/recentsetting_rect.mat';

runPath = '../RUN/';
if exist(runPath)==7,
   ; 
else
   mkdir(runPath); 
end

settingRECT.xCenter = get(handles.editxCenter, 'string');
settingRECT.yCenter = get(handles.edityCenter, 'string');
settingRECT.dx = get(handles.editdx, 'string');
settingRECT.Nnum = get(handles.editNnum, 'string');
settingRECT.XcutLeft = get(handles.editXcutLeft, 'string');
settingRECT.XcutRight = get(handles.editXcutRight, 'string');
settingRECT.YcutUp = get(handles.editYcutUp, 'string');
settingRECT.YcutDown = get(handles.editYcutDown, 'string');
settingRECT.RectImage = get(handles.checkboxRectImage ,'Value');
settingRECT.RectVideo = get(handles.checkboxRectVideo,'Value');
settingRECT.VideoTIF = get(handles.checkboxVideoTIF,'Value');
settingRECT.Crop = get(handles.checkboxCrop,'Value' );
settingRECT.gaininput = get(handles.sliderGain,'Value' );

settingRECT.RawIMG = [];
settingRECT.RectIMG = [];
save(fileName, 'settingRECT');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function loadState(handles)

global settingRECT;
fileName = '../RUN/recentsetting_rect.mat';
settingRECT.RawIMG = zeros(10,10);
settingRECT.RectIMG = zeros(10,10);
settingRECT.gain = 1;


if exist(fileName)
    load(fileName);    
    set(handles.editxCenter, 'string', settingRECT.xCenter);
    set(handles.edityCenter, 'string', settingRECT.yCenter );
    set(handles.editdx, 'string', settingRECT.dx );
    set(handles.editNnum, 'string', settingRECT.Nnum);
    set(handles.editXcutLeft, 'string', settingRECT.XcutLeft );
    set(handles.editXcutRight, 'string', settingRECT.XcutRight );
    set(handles.editYcutUp, 'string', settingRECT.YcutUp );
    set(handles.editYcutDown, 'string', settingRECT.YcutDown );
    set(handles.checkboxRectImage ,'Value', settingRECT.RectImage);
    set(handles.checkboxRectVideo,'Value', settingRECT.RectVideo);
    set(handles.checkboxVideoTIF,'Value', settingRECT.VideoTIF);
    set(handles.checkboxCrop,'Value', settingRECT.Crop);
    set(handles.sliderGain,'Value', settingRECT.gaininput );
else
    set(handles.editxCenter, 'string', '0');
    set(handles.edityCenter, 'string', '0');
    set(handles.editdx, 'string', '15');
    set(handles.editNnum, 'string', '15');
    set(handles.editXcutLeft, 'string','0');
    set(handles.editXcutRight, 'string','0');
    set(handles.editYcutUp, 'string', '0');
    set(handles.editYcutDown, 'string', '0');    
    set(handles.checkboxRectImage ,'Value', 1);
    set(handles.checkboxRectVideo,'Value', 0);
    set(handles.checkboxVideoTIF,'Value', 0);
    set(handles.checkboxCrop,'Value', 1);
    set(handles.sliderGain,'Value', 5 );    
    saveState(handles);
end

settingRECT.videoFilePath = '';
settingRECT.imageFilePath = '';
settingRECT.imageFileName = '';
settingRECT.rectFilePath = '';
settingRECT.rectFileName = '';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function readState(handles)
global settingRECT;
settingRECT.xCenter = get(handles.editxCenter, 'string');
settingRECT.yCenter = get(handles.edityCenter, 'string');
settingRECT.dx = get(handles.editdx, 'string');
settingRECT.Nnum = get(handles.editNnum, 'string');
settingRECT.XcutLeft = get(handles.editXcutLeft, 'string');
settingRECT.XcutRight = get(handles.editXcutRight, 'string');
settingRECT.YcutUp = get(handles.editYcutUp, 'string');
settingRECT.YcutDown = get(handles.editYcutDown, 'string');
settingRECT.RectImage = get(handles.checkboxRectImage ,'Value');
settingRECT.RectVideo = get(handles.checkboxRectVideo,'Value');
settingRECT.VideoTIF = get(handles.checkboxVideoTIF,'Value');
settingRECT.Crop = get(handles.checkboxCrop,'Value' );
settingRECT.gaininput = get(handles.sliderGain,'Value' );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function checkState(handles)

global settingRECT;
readState(handles);
settingRECT.check = 1;

if ~( str2num(settingRECT.xCenter)>0),
    disp('xCenter should be larger than 0');
    settingRECT.check = 0;
end
if ~( str2num(settingRECT.yCenter)>0),
    disp('yCenter should be larger than 0');
    settingRECT.check = 0;
end
if ~( str2num(settingRECT.dx)>0),
    disp('dx should be larger than 0');
    settingRECT.check = 0;
end
if mod(str2num(settingRECT.Nnum),2)==0 || mod(str2num(settingRECT.Nnum),1)>0 || str2num(settingRECT.Nnum)<1  ,
   disp(['Nnum should be an odd integer number']); 
   settingRECT.check = 0;
end
if mod(str2num(settingRECT.XcutLeft),1)>0 || str2num(settingRECT.XcutLeft)<0 ,
   disp(['XcutLeft should be a non-negative integer number']); 
   settingRECT.check = 0;
end
if mod(str2num(settingRECT.XcutRight),1)>0 || str2num(settingRECT.XcutRight)<0 ,
   disp(['XcutRight should be a non-negative integer number']); 
   settingRECT.check = 0;
end
if mod(str2num(settingRECT.YcutUp),1)>0 || str2num(settingRECT.YcutUp)<0 ,
   disp(['YcutUp should be a non-negative integer number']); 
   settingRECT.check = 0;
end
if mod(str2num(settingRECT.YcutDown),1)>0 || str2num(settingRECT.YcutDown)<0 ,
   disp(['XcutDown should be a non-negative integer number']); 
   settingRECT.check = 0;
end
if ~ (exist([settingRECT.imageFilePath settingRECT.imageFileName ])==2) && settingRECT.RectImage ,
    disp('Image file is not selected');
    settingRECT.check = 0;
end
if ~ (exist([settingRECT.videoFilePath  ])==7) && settingRECT.RectVideo ,
    disp('Video path is not selected');
    settingRECT.check = 0;
end
if  ~(settingRECT.RectImage || settingRECT.RectVideo),
    disp('Specify wmedia type to rectify');
    settingRECT.check = 0;        
end

if settingRECT.check,
    saveState(handles);
    disp('========= Start Image/Video Rectification =========');
    
    ImageRectification;
else
    disp('========= Retry after changing the variables according to the message =======');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% --- Executes just before ImageRectification_GUI is made visible.
function ImageRectification_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ImageRectification_GUI (see VARARGIN)

% Choose default command line output for ImageRectification_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global settingRECT;
loadState(handles);
imshow(settingRECT.RawIMG,'Parent', handles.axes1);
imshow(settingRECT.RectIMG,'Parent', handles.axes2);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using ImageRectification_GUI.
% if strcmp(get(hObject,'Visible'),'off')
%     plot(rand(5));
% end

% UIWAIT makes ImageRectification_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ImageRectification_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbuttonUpdate.
function pushbuttonUpdate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonUpdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla;

popup_sel_index = get(handles.popupmenu1, 'Value');
switch popup_sel_index
    case 1
        plot(rand(5));
    case 2
        plot(sin(1:0.01:25.99));
    case 3
        bar(1:.5:10);
    case 4
        plot(membrane);
    case 5
        surf(peaks);
end


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
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

set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});


% --- Executes on button press in pushbuttonBrowser.
function pushbuttonBrowser_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonBrowser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global settingRECT;

rawPath = '../Data/01_Raw/';
if exist(rawPath)==7,
   ; 
else
   mkdir(rawPath); 
end
[settingRECT.imageFileName, settingRECT.imageFilePath, gfindex] = uigetfile({'*.*',  'All files'}, 'Select data file', '../Data/01_Raw/');
if gfindex==0,
    settingRECT.imageFilePath = '';
    settingRECT.imageFileName = '';
else
    pushbuttonReflect_Callback(hObject, eventdata, handles);
end



% --- Executes on button press in pushbuttonBrowseRect.
function pushbuttonBrowseRect_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonBrowseRect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global settingRECT;
[settingRECT.rectFileName, settingRECT.rectFilePath, gfindex] = uigetfile({'*.txt',  'All txt files'}, 'Select data file', '../Data/01_Raw/');
if gfindex==0,
    settingRECT.rectFilePath = '';
else
%     warning('off'); addpath('../Code/Util');
    [settingRECT.xCenter, settingRECT.yCenter, settingRECT.dx] = readRectInfo([settingRECT.rectFilePath  settingRECT.rectFileName]);
    set(handles.editxCenter, 'string', settingRECT.xCenter);
    set(handles.edityCenter, 'string', settingRECT.yCenter);
    set(handles.editdx, 'string', settingRECT.dx);
    pushbuttonReflect_Callback(hObject, eventdata, handles);
end

% --- Executes on button press in pushbuttonBrowseVideo.
function pushbuttonBrowseVideo_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonBrowseVideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global settingRECT;
[settingRECT.videoFilePath] = uigetdir('../Data/01_Raw/');
if settingRECT.videoFilePath==0,
   settingRECT.videoFilePath=''; 
end


% --- Executes on button press in checkboxRectImage.
function checkboxRectImage_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxRectImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxRectImage
global settingRECT;
if (((get(hObject,'Value') == get(hObject,'Max'))))
    settingRECT.RectImage = 1;
else
    settingRECT.RectImage = 0;
end


% --- Executes on button press in checkboxRectVideo.
function checkboxRectVideo_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxRectVideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxRectVideo
global settingRECT;
if (((get(hObject,'Value') == get(hObject,'Max'))))
    settingRECT.RectVideo = 1;
else
    settingRECT.RectVideo = 0;
end


function editxCenter_Callback(hObject, eventdata, handles)
% hObject    handle to editxCenter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editxCenter as text
%        str2double(get(hObject,'String')) returns contents of editxCenter as a double


% --- Executes during object creation, after setting all properties.
function editxCenter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editxCenter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edityCenter_Callback(hObject, eventdata, handles)
% hObject    handle to edityCenter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edityCenter as text
%        str2double(get(hObject,'String')) returns contents of edityCenter as a double


% --- Executes during object creation, after setting all properties.
function edityCenter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edityCenter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editdx_Callback(hObject, eventdata, handles)
% hObject    handle to editdx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editdx as text
%        str2double(get(hObject,'String')) returns contents of editdx as a double


% --- Executes during object creation, after setting all properties.
function editdx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editdx (see GCBO)
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



function editXcutLeft_Callback(hObject, eventdata, handles)
% hObject    handle to editXcutLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editXcutLeft as text
%        str2double(get(hObject,'String')) returns contents of editXcutLeft as a double


% --- Executes during object creation, after setting all properties.
function editXcutLeft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editXcutLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editXcutRight_Callback(hObject, eventdata, handles)
% hObject    handle to editXcutRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editXcutRight as text
%        str2double(get(hObject,'String')) returns contents of editXcutRight as a double


% --- Executes during object creation, after setting all properties.
function editXcutRight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editXcutRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editYcutUp_Callback(hObject, eventdata, handles)
% hObject    handle to editYcutUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editYcutUp as text
%        str2double(get(hObject,'String')) returns contents of editYcutUp as a double


% --- Executes during object creation, after setting all properties.
function editYcutUp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editYcutUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editYcutDown_Callback(hObject, eventdata, handles)
% hObject    handle to editYcutDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editYcutDown as text
%        str2double(get(hObject,'String')) returns contents of editYcutDown as a double


% --- Executes during object creation, after setting all properties.
function editYcutDown_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editYcutDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonRunRect.
function pushbuttonRunRect_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonRunRect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
checkState(handles);

% --- Executes on button press in checkboxCrop.
function checkboxCrop_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxCrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxCrop
global settingRECT;
if (((get(hObject,'Value') == get(hObject,'Max'))))
    settingRECT.Crop = 1;
else
    settingRECT.Crop = 0;
end
pushbuttonReflect_Callback(hObject, eventdata, handles);

% --- Executes on button press in pushbuttonReflect.
function pushbuttonReflect_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonReflect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global settingRECT;
readState(handles);
% warning('off'); addpath('../Code/Util/');

    if exist([settingRECT.imageFilePath settingRECT.imageFileName])==2, 
        settingRECT.RawIMG = im2double(imread([settingRECT.imageFilePath settingRECT.imageFileName],'tiff'));
        settingRECT.RectIMG = ImageRect(settingRECT.RawIMG, str2num(settingRECT.xCenter), str2num(settingRECT.yCenter), str2num(settingRECT.dx), str2num(settingRECT.Nnum), settingRECT.Crop, str2num(settingRECT.XcutLeft), str2num(settingRECT.XcutRight), str2num(settingRECT.YcutUp), str2num(settingRECT.YcutDown));
        imshow(settingRECT.gain*(settingRECT.RawIMG/max(settingRECT.RawIMG(:))),'Parent', handles.axes1);
        imshow(settingRECT.gain*(settingRECT.RectIMG/max(settingRECT.RawIMG(:))),'Parent', handles.axes2);
    end





% --- Executes on slider movement.
function sliderGain_Callback(hObject, eventdata, handles)
% hObject    handle to sliderGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global settingRECT;
settingRECT.gaininput = get(hObject,'Value');
settingRECT.gain = 2^(settingRECT.gaininput-5);
% settingRECT.RawIMG
% max(settingRECT.RawIMG(:))
imshow(settingRECT.gain*(settingRECT.RawIMG/max(settingRECT.RawIMG(:))),'Parent', handles.axes1);
imshow(settingRECT.gain*(settingRECT.RectIMG/max(settingRECT.RawIMG(:))),'Parent', handles.axes2);

% --- Executes during object creation, after setting all properties.
function sliderGain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbuttonPreset.
function pushbuttonPreset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPreset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.editxCenter, 'string', '0');
set(handles.edityCenter, 'string', '0');
set(handles.editdx, 'string', '15');
set(handles.editNnum, 'string', '15');
set(handles.editXcutLeft, 'string','0');
set(handles.editXcutRight, 'string','0');
set(handles.editYcutUp, 'string', '0');
set(handles.editYcutDown, 'string', '0');    
set(handles.checkboxRectImage ,'Value', 1);
set(handles.checkboxRectVideo,'Value', 0);
set(handles.checkboxCrop,'Value', 1);
    set(handles.sliderGain,'Value', 5 );    


% --- Executes on button press in checkboxVideoTIF.
function checkboxVideoTIF_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxVideoTIF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxVideoTIF
global settingRECT;
if (((get(hObject,'Value') == get(hObject,'Max'))))
    settingRECT.VideoTIF = 1;
else
    settingRECT.VideoTIF = 0;
end






















%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ImageRectification
warning('off');
addpath('./Util/');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%% Rectification parameters %%%%%%%%%%%%%%%%%%%%%%%
load('../RUN/recentsetting_rect.mat');
xCenter             = str2num(settingRECT.xCenter);
yCenter             = str2num(settingRECT.yCenter);
dx                  = str2num(settingRECT.dx);
Nnum                = str2num(settingRECT.Nnum);
XcutLeft            = str2num(settingRECT.XcutLeft);
XcutRight           = str2num(settingRECT.XcutRight);
YcutUp              = str2num(settingRECT.YcutUp);
YcutDown            = str2num(settingRECT.YcutDown);

rectifySingleShot   = settingRECT.RectImage;
rectifyMovie        = settingRECT.RectVideo;
VideoTIF            = settingRECT.VideoTIF;
Crop                = settingRECT.Crop;
inputFilePath       = settingRECT.imageFilePath;
inputFileName       = settingRECT.imageFileName;
moviePath           = [settingRECT.videoFilePath '/'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if rectifySingleShot,
    savePathIMG = ['../Data/02_Rectified/' inputFilePath( findstr(inputFilePath, '/Data/01_Raw/') + 13 : end)];
    if exist(savePathIMG)==7,
       ; 
    else
       mkdir(savePathIMG); 
    end
end
if rectifyMovie, 
    savePathVIDEO = ['../Data/02_Rectified/' moviePath( findstr(moviePath, '/Data/01_Raw/') + 13 : end)];
    if exist(savePathVIDEO)==7,
       ; 
    else
       mkdir(savePathVIDEO); 
    end   
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if rectifySingleShot,
    IMG_RAW = im2double(imread([inputFilePath inputFileName],'tiff'));
    IMG_Rect = ImageRect(IMG_RAW, xCenter, yCenter, dx, Nnum, Crop, XcutLeft, XcutRight, YcutUp, YcutDown);
    imwrite(IMG_Rect,  [savePathIMG inputFileName(1:end-4) '_N' num2str(Nnum) '.tif'], 'Compression', 'none');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if rectifyMovie,
    disp('Rectifying movie...');
    List = dir(moviePath);
    
    % JT: editing out filenames that are not tif files
    % (or at least, editing out the hidden mac file that is likely to be
    % there)
    for k=size(List,1):-1:1,
        disp(List(k).name)
%        if strcmp(List(k).name, '.DS_Store'),
        if ~endsWith(List(k).name, '.tif'),
            List(k) = []
        end
    end

    for k=1:size(List,1),
      fileName = List(k).name;
      numInit = findstr(fileName , 'X') + 1;
      numEnd = findstr(fileName , '.tif') - 1;
      if isempty(numInit) || isempty(numEnd),
          disp(['Bad file' fileName])
      else
          disp(['Will process' fileName k])
      end
      ListNum(k) = str2num(fileName(numInit(end):numEnd));       
    end
     
    disp(moviePath)
    disp(List(1).name)
    disp(List(3).name)
    LFmovie = uint16(zeros(size(IMG_Rect,1), size(IMG_Rect,2), size(List,1)));           
    movieLength = size(List,1);
    for k=1:movieLength,
        disp(['Rectifying Frame # ' num2str(k) ' / ' num2str(movieLength)]);
        fileNumber = find(ListNum==k);
        MV_RAW = im2double(imread([moviePath List(fileNumber).name],'tiff'));
        MV_Rect = ImageRect(MV_RAW, xCenter, yCenter, dx, Nnum, Crop, XcutLeft, XcutRight, YcutUp, YcutDown);
        if VideoTIF,
            imwrite(MV_Rect, [savePathVIDEO List(fileNumber).name] ); 
        end               
        if k==1,
            MVgain = (0.2/max(MV_Rect(:)));
        end
        MV_Rect_uint = uint16(round(65535*MVgain*MV_Rect));
        LFmovie(:,:,k) = MV_Rect_uint;
        imwrite(MV_Rect_uint,  [savePathIMG List(fileNumber).name(1:end-4) '_N' num2str(Nnum) '.tif'], 'Compression', 'none');
    end    
    

    save([savePathVIDEO 'LFmovie' '_N' num2str(Nnum)], 'LFmovie', '-v7.3');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['Image rectification complete.']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [xCenter, yCenter, dx] = readRectInfo(rectfilepath)

fid = fopen(rectfilepath);
tline = fgetl(fid);
k = strfind(tline, ',');

xCenter = str2num(tline(2: k(1)-1));
yCenter = str2num(tline(k(1)+1: k(2)-1));
dx = str2num(tline(k(2)+1: k(3)-1));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function IMG_Rect = ImageRect(IMG_BW, xCenter, yCenter, dx, M, Crop, XcutLeft, XcutRight, YcutUp, YcutDown)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dy = dx; 
Mdiff = floor(M/2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%  Resample the image %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Xresample = [fliplr((xCenter+1):-dx/M:1)  ((xCenter+1)+dx/M:dx/M:size(IMG_BW,2))];
Yresample = [fliplr((yCenter+1):-dx/M:1)  ((yCenter+1)+dx/M:dx/M:size(IMG_BW,1))];
[X, Y] = meshgrid( (1:1:size(IMG_BW,2)),   (1:1:size(IMG_BW,1)) ); 
[Xq,Yq] = meshgrid( Xresample , Yresample );

XqCenterInit = find(Xq(1,:)==(xCenter+1)) - Mdiff;
XqInit = XqCenterInit -  M*floor(XqCenterInit/M)+M;
XqEnd = M*floor((size(Xq,2)-XqInit+1)/M);
YqCenterInit = find(Yq(:,1)==(yCenter+1)) - Mdiff;
YqInit = YqCenterInit -  M*floor(YqCenterInit/M)+M;
YqEnd = M*floor((size(Yq,1)-YqInit+1)/M);

XresampleQ = Xresample(XqInit:end);
YresampleQ = Yresample(YqInit:end);
[Xqq,Yqq] = meshgrid( XresampleQ , YresampleQ );

IMG_RESAMPLE = interp2( X, Y,  IMG_BW, Xqq, Yqq );
IMG_RESAMPLE_crop1 = IMG_RESAMPLE( (1:1:M*floor((size(IMG_RESAMPLE,1)-YqInit)/M)), (1:1:M*floor((size(IMG_RESAMPLE,2)-XqInit)/M)) );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%% Crop the right portion %%%%%%%%%%%%%%%%%%%%%%%%%%%%
if Crop,
    XsizeML = size(IMG_RESAMPLE_crop1,2)/M;
    YsizeML = size(IMG_RESAMPLE_crop1,1)/M;
    if (XcutLeft + XcutRight)>=XsizeML,
        error('X-cut range is larger than the x-size of image');
    end
    if (YcutUp + YcutDown)>=YsizeML,
        error('Y-cut range is larger than the y-size of image');
    end

    Xrange = [1+XcutLeft:XsizeML-XcutRight];
    Yrange = [1+YcutUp:YsizeML-YcutDown];
    
    IMG_RESAMPLE_crop2 = IMG_RESAMPLE_crop1(   ((Yrange(1)-1)*M+1 :Yrange(end)*M),  ((Xrange(1)-1)*M+1 :Xrange(end)*M) );
else
    IMG_RESAMPLE_crop2 = IMG_RESAMPLE_crop1;
end

IMG_Rect = IMG_RESAMPLE_crop2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
