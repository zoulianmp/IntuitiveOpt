function varargout = matRad_IntuitiveOptTMDDetials(varargin)
% MATRAD_INTUITIVEOPTTMDDETIALS MATLAB code for matRad_IntuitiveOptTMDDetials.fig
%      MATRAD_INTUITIVEOPTTMDDETIALS, by itself, creates a new MATRAD_INTUITIVEOPTTMDDETIALS or raises the existing
%      singleton*.
%
%      H = MATRAD_INTUITIVEOPTTMDDETIALS returns the handle to a new MATRAD_INTUITIVEOPTTMDDETIALS or the handle to
%      the existing singleton*.
%
%      MATRAD_INTUITIVEOPTTMDDETIALS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MATRAD_INTUITIVEOPTTMDDETIALS.M with the given input arguments.
%
%      MATRAD_INTUITIVEOPTTMDDETIALS('Property','Value',...) creates a new MATRAD_INTUITIVEOPTTMDDETIALS or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before matRad_IntuitiveOptTMDDetials_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to matRad_IntuitiveOptTMDDetials_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help matRad_IntuitiveOptTMDDetials

% Last Modified by GUIDE v2.5 22-Dec-2016 19:40:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @matRad_IntuitiveOptTMDDetials_OpeningFcn, ...
                   'gui_OutputFcn',  @matRad_IntuitiveOptTMDDetials_OutputFcn, ...
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


% --- Executes just before matRad_IntuitiveOptTMDDetials is made visible.
function matRad_IntuitiveOptTMDDetials_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to matRad_IntuitiveOptTMDDetials (see VARARGIN)

% Choose default command line output for matRad_IntuitiveOptTMDDetials
handles.output = hObject;
  
initialGUITMDPart(handles);


% Update handles structure
guidata(hObject, handles);










% --- Outputs from this function are returned to the command line.
function varargout = matRad_IntuitiveOptTMDDetials_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





function doseposition_edit_Callback(hObject, eventdata, handles)
% hObject    handle to doseposition_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of doseposition_edit as text
%        str2double(get(hObject,'String')) returns contents of doseposition_edit as a double


% --- Executes during object creation, after setting all properties.
function doseposition_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to doseposition_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tmdrange_edit_Callback(hObject, eventdata, handles)
% hObject    handle to tmdrange_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tmdrange_edit as text
%        str2double(get(hObject,'String')) returns contents of tmdrange_edit as a double


% --- Executes during object creation, after setting all properties.
function tmdrange_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tmdrange_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in structure_popupmenu.
function structure_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to structure_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns structure_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from structure_popupmenu

value = handles.structure_popupmenu.Value;

structNameList = get(handles.structure_popupmenu,'string');

structName = structNameList{value};

global intOptParameters;

%intOptParameters = evalin('base','intOptParameters');

indexList =  getStructureTMDIndexList( structName , intOptParameters );

indexList = {'New',indexList{:}};
set(handles.index_popupmenu,'string',indexList);
handles.index_popupmenu.Value = 1;

guidata(hObject, handles);






% --- Executes during object creation, after setting all properties.
function structure_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to structure_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end







% --- Executes on selection change in direction_popupmenu.
function direction_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to direction_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns direction_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from direction_popupmenu


% --- Executes during object creation, after setting all properties.
function direction_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to direction_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function index_edit_Callback(hObject, eventdata, handles)
% hObject    handle to index_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of index_edit as text
%        str2double(get(hObject,'String')) returns contents of index_edit as a double


% --- Executes during object creation, after setting all properties.
function index_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to index_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tmdvalue_edit_Callback(hObject, eventdata, handles)
% hObject    handle to tmdvalue_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tmdvalue_edit as text
%        str2double(get(hObject,'String')) returns contents of tmdvalue_edit as a double


% --- Executes during object creation, after setting all properties.
function tmdvalue_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tmdvalue_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in add_TMDpushbutton.
function add_TMDpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to add_TMDpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



[structName,tmdindex,tmd]=  getPrescribedTMDInfoFromGUI(handles);


SetTMD(structName,tmdindex,tmd);
    
if tmdindex == -1 
    
    ReindexPrescribedTMDS;
    
    initialGUITMDPart(handles);

    
end








% --- Executes on button press in delete_TMDpushbutton.
function delete_TMDpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to delete_TMDpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[structName,tmdindex,tmd]=  getPrescribedTMDInfoFromGUI(handles);

if tmdindex == -1 
    return 
end

RemoveTMD(structName,tmdindex,tmd);

ReindexPrescribedTMDS;
    
initialGUITMDPart(handles);

    







% --- Executes on selection change in index_popupmenu.
function index_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to index_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns index_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from index_popupmenu


%The GUI structure




structName = handles.structure_popupmenu.String{handles.structure_popupmenu.Value};


%The GUI TMDIndex
indexlist = handles.index_popupmenu.String;
currentv = handles.index_popupmenu.Value; 

index = indexlist{currentv};

if  strcmp(index,'New')
   
     tmd.doseValue = 'enter dose';
     tmd.direction = 'None'; % The U: UP, L: Low
     tmd.TMDValue = 'enter value';
     tmd.TMDRange = 'enter range';  
     tmd.TMDindex = -1; %used for ensuring the creation of a tmd
else
    
    tmd = GetTMD(structName, str2num(index));
    
end

UpdateTMDGUI(handles,tmd);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function index_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to index_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in structure_c_popupmenu.
function structure_c_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to structure_c_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns structure_c_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from structure_c_popupmenu


% --- Executes during object creation, after setting all properties.
function structure_c_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to structure_c_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function doseposition_c_edit_Callback(hObject, eventdata, handles)
% hObject    handle to doseposition_c_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of doseposition_c_edit as text
%        str2double(get(hObject,'String')) returns contents of doseposition_c_edit as a double


% --- Executes during object creation, after setting all properties.
function doseposition_c_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to doseposition_c_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in direction_c_popupmenu.
function direction_c_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to direction_c_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns direction_c_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from direction_c_popupmenu


% --- Executes during object creation, after setting all properties.
function direction_c_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to direction_c_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in calculate_c_pushbutton.
function calculate_c_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to calculate_c_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function tmdvalue_c_edit_Callback(hObject, eventdata, handles)
% hObject    handle to tmdvalue_c_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tmdvalue_c_edit as text
%        str2double(get(hObject,'String')) returns contents of tmdvalue_c_edit as a double


% --- Executes during object creation, after setting all properties.
function tmdvalue_c_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tmdvalue_c_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in resumeOpt_pushbutton.
function resumeOpt_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to resumeOpt_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)







%*******************************************
%% Beging function blocks by zoulian 




function initialGUITMDPart(handles)
%intOptParameters: 
%resultGUI : the resultGUI
%

global intOptParameters
global intOptResultGUI

%%****************
%% Setup the tmd controls
structureList = getInvolvedStructureNameList( intOptParameters);

set(handles.structure_popupmenu,'string',structureList);

set(handles.structure_c_popupmenu,'string',structureList);

%indexList = getStructureTMDIndexList( structName , intOptParameters )

value = handles.structure_popupmenu.Value;

structName = structureList{value};

indexList =  getStructureTMDIndexList( structName , intOptParameters );

indexList = {'New',indexList{:}};
set(handles.index_popupmenu,'string',indexList);

%% Setup the TMDTable
tmdArrayPrescibed =  GetTMDArray(structName);

tmdArrayReal = calculateRealTMDArray(structName,tmdArrayPrescibed);


UpdateTMDTable(handles,structName,tmdArrayPrescibed,tmdArrayReal);





function  UpdateTMDGUI(handles,tmd)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
%handles.

if tmd.TMDindex == -1
    handles.doseposition_edit.String = tmd.doseValue;
    handles.tmdvalue_edit.String = tmd.TMDValue;
    handles.tmdrange_edit.String = tmd.TMDRange;
    
else
    
    handles.doseposition_edit.String = num2str(tmd.doseValue);
    handles.tmdvalue_edit.String = num2str(tmd.TMDValue );
    handles.tmdrange_edit.String = num2str(tmd.TMDRange);
    
end

direction = strtrim(tmd.direction);

if strcmp(direction, 'U')
    handles.direction_popupmenu.Value = 2;
elseif strcmp(direction, 'L')
    handles.direction_popupmenu.Value = 3;
end


function  UpdateTMDTable(handles,structName,tmdArrayPrescibed,tmdArrayReal)
%%Update the TMD Table for selected structure,
%
columnname = {'VOI name','TMD type'};
columnformat = {'char','char'};
columneditable = [false false];


columnname =  addTMDTableColumnNames(columnname,tmdArrayPrescibed);
columnformat = addTMDTableColumnFormat(columnformat,tmdArrayPrescibed);
columneditable = addTMDTableColumnEditable(columneditable,tmdArrayPrescibed);


%TMD Prescribed columndata
pcolumndata  = {structName,'Prescribed'};
pcolumndata = addTMDTableColumnData(pcolumndata,tmdArrayPrescibed);


%TMD real calculated columndata
rcolumndata  = {structName,'Real'};
rcolumndata = addTMDTableColumnData(rcolumndata,tmdArrayReal);



data = vertcat(pcolumndata,rcolumndata);

set(handles.tmd_uitable,'ColumnName',columnname);
set(handles.tmd_uitable,'ColumnFormat',columnformat);
set(handles.tmd_uitable,'ColumnEditable',columneditable);
set(handles.tmd_uitable,'Data',data);




function [structName,tmdindex,tmd]=  getPrescribedTMDInfoFromGUI(handles)


structName = handles.structure_popupmenu.String{handles.structure_popupmenu.Value};


indexstr = handles.index_popupmenu.String{handles.index_popupmenu.Value};


if strcmp(indexstr, 'New')
    tmd.TMDindex = -1
else
    tmd.TMDindex = str2num(indexstr); 
end

tmdindex = tmd.TMDindex;


tmd.doseValue = str2num( handles.doseposition_edit.String);
tmd.TMDValue =  str2num( handles.tmdvalue_edit.String);
tmd.TMDRange =  str2num( handles.tmdrange_edit.String);

tmd.direction=  handles.direction_popupmenu.String{handles.direction_popupmenu.Value};








%% End function blocks by zoulian 
%*******************************************
