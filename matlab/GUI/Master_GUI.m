function varargout = Master_GUI(varargin)
% MASTER_GUI MATLAB code for Master_GUI.fig
%      MASTER_GUI, by itself, creates a new MASTER_GUI or raises the existing
%      singleton*.
%
%      H = MASTER_GUI returns the handle to a new MASTER_GUI or the handle to
%      the existing singleton*.
%
%      MASTER_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MASTER_GUI.M with the given input arguments.
%
%      MASTER_GUI('Property','Value',...) creates a new MASTER_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Master_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Master_GUI_OpeningxiFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Master_GUI

% Last Modified by GUIDE v2.5 12-Feb-2019 18:57:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Master_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Master_GUI_OutputFcn, ...
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


% --- Executes just before Master_GUI is made visible.
function Master_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Master_GUI (see VARARGIN)

% Jerrar: Modify this script to loadParams and give pathToGUI if needed
pathToGUI = '/home/amav/amav/Terpcopter3.0/matlab/GUI';
%pathToGUI = '/home/wolek/Desktop/Research/Projects/UMD/AMAV/Terpcopter3.0/matlab/GUI';
cd(pathToGUI)

% Choose default command line output for Master_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Master_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Master_GUI_OutputFcn(hObject, eventdata, handles) 
if(~robotics.ros.internal.Global.isNodeActive)
    rosinit;
end
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
 set(handles.text2,'String','launching');
 system('./scripts/px4_script.sh &');
 first_run = 1;
 error_flag = 0;
 while( error_flag==1 || first_run == 1 )
    pause(0.1);
    try
        sub = rossubscriber('/mavros/imu/data');
        first_run = 0;
        error_flag = 0;
    catch error
        disp(error.identifier)
        error_flag = 1;
    end
 end
 msg = receive(sub,30);
 set(handles.text2,'String','active');

 
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
 set(handles.text3,'String','launching');
 system('./scripts/lidar_script.sh &')
 first_run = 1;
 error_flag = 0;
 while( error_flag==1 || first_run == 1 )
     pause(0.1);
    try
        sub = rossubscriber('/terarangerone');
        first_run = 0;
        error_flag = 0;
    catch error
        disp(error.identifier)
        error_flag = 1;
    end
 end
 msg = receive(sub,20);
 set(handles.text3,'String','active');
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
  set(handles.text4,'String','launching');
 system('./scripts/estimation_script.sh &')
 first_run = 1;
 error_flag = 0;
 while( error_flag==1 || first_run == 1 )
     pause(0.1);
    try
        sub = rossubscriber('/stateEstimate');
        first_run = 0;
        error_flag = 0;
    catch error
        disp(error.identifier)
        error_flag = 1;
    end
 end
 msg = receive(sub,20);
 set(handles.text4,'String','active');
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
   set(handles.text5,'String','launching');
 system('./scripts/virtual_transmitter_script.sh &')
 first_run = 1;
 error_flag = 0;
 while( error_flag==1 || first_run == 1 )
    try
        sub = rossubscriber('/vtxStatus');
        first_run = 0;
        error_flag = 0;
    catch error
        disp(error.identifier)
        error_flag = 1;
    end
 end
 msg = receive(sub,20);
 set(handles.text5,'String','active');
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
set(handles.text6,'String','launching');
system('./scripts/autonomy_script.sh &')
first_run = 1;
error_flag = 0;
while( error_flag==1 || first_run == 1 )
    pause(0.1);
    try
        sub = rossubscriber('/ahsCmd');
        first_run = 0;
        error_flag = 0;
    catch error
        disp(error.identifier)
        error_flag = 1;
    end
end
msg = receive(sub,20);
set(handles.text6,'String','active');
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
set(handles.text7,'String','launching');
system('./scripts/control_script.sh &')
first_run = 1;
error_flag = 0;
while( error_flag==1 || first_run == 1 )
    pause(0.1);
    try
        sub = rossubscriber('/stickCmd');
        first_run = 0;
        error_flag = 0;
    catch error
        disp(error.identifier)
        error_flag = 1;
    end
end
msg = receive(sub,20);
set(handles.text7,'String','active');
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
set(handles.text2,'String','launching');
system('./scripts/px4_script.sh &');
first_run = 1;
error_flag = 0;
while( error_flag==1 || first_run == 1 )
    pause(0.1);
    try
        sub = rossubscriber('/mavros/imu/data');
        first_run = 0;
        error_flag = 0;
    catch error
        disp(error.identifier)
        error_flag = 1;
    end
end
msg = receive(sub,20);
set(handles.text2,'String','active');

set(handles.text3,'String','launching');
system('./scripts/lidar_script.sh &')
first_run = 1;
error_flag = 0;
while( error_flag==1 || first_run == 1 )
    pause(0.1);
    try
        sub = rossubscriber('/terarangerone');
        first_run = 0;
        error_flag = 0;
    catch error
        disp(error.identifier)
        error_flag = 1;
    end
end
msg = receive(sub,20);
set(handles.text3,'String','active');

set(handles.text4,'String','launching');
system('./scripts/estimation_script.sh &')
first_run = 1;
error_flag = 0;
while( error_flag==1 || first_run == 1 )
    pause(0.1);
    try
        sub = rossubscriber('/stateEstimate');
        first_run = 0;
        error_flag = 0;
    catch error
        disp(error.identifier)
        error_flag = 1;
    end
end
msg = receive(sub,20);
set(handles.text4,'String','active');



set(handles.text5,'String','launching');
system('./scripts/virtual_transmitter_script.sh &')
first_run = 1;
error_flag = 0;
while( error_flag==1 || first_run == 1 )
    try
        sub = rossubscriber('/vtxStatus');
        first_run = 0;
        error_flag = 0;
    catch error
        disp(error.identifier)
        error_flag = 1;
    end
end
msg = receive(sub,20);
set(handles.text5,'String','active');


set(handles.text6,'String','launching');
system('./scripts/autonomy_script.sh &')
first_run = 1;
error_flag = 0;
while( error_flag==1 || first_run == 1 )
    pause(0.1);
    try
        sub = rossubscriber('/ahsCmd');
        first_run = 0;
        error_flag = 0;
    catch error
        disp(error.identifier)
        error_flag = 1;
    end
end
msg = receive(sub,20);
set(handles.text6,'String','active');


set(handles.text7,'String','launching');
system('./scripts/control_script.sh &')
first_run = 1;
error_flag = 0;
while( error_flag==1 || first_run == 1 )
    pause(0.1);
    try
        sub = rossubscriber('/stickCmd');
        first_run = 0;
        error_flag = 0;
    catch error
        disp(error.identifier)
        error_flag = 1;
    end
end
msg = receive(sub,20);
set(handles.text7,'String','active');


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
rosshutdown;
close();
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
