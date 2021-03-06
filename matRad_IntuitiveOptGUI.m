function varargout = matRad_IntuitiveOptGUI(varargin)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% matRad IntuitiveOpt GUI
%
% call
%      matRad_IntuitiveOptGUI, by itself, creates a new matRad_IntuitiveOptGUI or raises the existing
%      singleton*.
%
%      H = matRad_IntuitiveOptGUI returns the handle to a new matRad_IntuitiveOptGUI or the handle to
%      the existing singleton*.
%
%      matRad_IntuitiveOptGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in matRad_IntuitiveOptGUI.M with the given input arguments.
%
%      matRad_IntuitiveOptGUI('Property','Value',...) creates a new matRad_IntuitiveOptGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before matRad_IntuitiveOptGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to matRad_IntuitiveOptGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright 2015 the matRad development team. 
% 
% This file is part of the matRad project. It is subject to the license 
% terms in the LICENSE file found in the top-level directory of this 
% distribution and at https://github.com/e0404/matRad/LICENSES.txt. No part 
% of the matRad project, including this file, may be copied, modified, 
% propagated, or distributed except according to the terms contained in the 
% LICENSE file.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% abort for octave
if exist('OCTAVE_VERSION','builtin');
    fprintf('matRad GUI not available for Octave.\n');
    return;
end
    
% Begin initialization code - DO NOT EDIT
% set platform specific look and feel
if ispc
    lf = 'com.sun.java.swing.plaf.windows.WindowsLookAndFeel';
elseif isunix
    lf = 'com.jgoodies.looks.plastic.Plastic3DLookAndFeel';
elseif ismac
    lf = 'com.apple.laf.AquaLookAndFeel';
end
javax.swing.UIManager.setLookAndFeel(lf);

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @matRad_IntuitiveOptGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @matRad_IntuitiveOptGUI_OutputFcn, ...
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

% --- Executes just before matRad_IntuitiveOptGUI is made visible.
function matRad_IntuitiveOptGUI_OpeningFcn(hObject, ~, handles, varargin) 
%#ok<*DEFNU> 
%#ok<*AGROW>
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to matRad_IntuitiveOptGUI (see VARARGIN)

% enable opengl software rendering to visualize linewidths properly
if ispc
    opengl software
elseif ismac
    % opengl is not supported
end


if ~isdeployed
    currFolder = fileparts(mfilename('fullpath'));
else
    currFolder = [];
end

addpath(fullfile(currFolder,'plotting'));
addpath(fullfile(currFolder,['plotting' filesep 'colormaps']));

% Choose default command line output for matRad_IntuitiveOptGUI
handles.output = hObject;
%show matrad logo
axes(handles.axesLogo)
[im, ~, alpha] = imread([currFolder filesep 'dicomImport' filesep 'matrad_logo.png']);
f = image(im);
axis equal off
set(f, 'AlphaData', alpha);
% show dkfz logo
axes(handles.axesDKFZ)
[im, ~, alpha] = imread([currFolder filesep 'dicomImport' filesep 'DKFZ_Logo.png']);
f = image(im);
axis equal off;
set(f, 'AlphaData', alpha);

% set callback for scroll wheel function
set(gcf,'WindowScrollWheelFcn',@matRadScrollWheelFcn);

% change color of toobar
hToolbar = findall(hObject,'tag','uitoolbar1');
jToolbar = get(get(hToolbar,'JavaContainer'),'ComponentPeer');
jToolbar.setBorderPainted(false);
color = java.awt.Color.gray;
% Remove the toolbar border, to blend into figure contents
jToolbar.setBackground(color);
% Remove the separator line between toolbar and contents
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jFrame = get(handle(hObject),'JavaFrame');
jFrame.showTopSeparator(false);
jtbc = jToolbar.getComponents;
for idx=1:length(jtbc)
    jtbc(idx).setOpaque(false);
    jtbc(idx).setBackground(color);
    for childIdx = 1 : length(jtbc(idx).getComponents)
        jtbc(idx).getComponent(childIdx-1).setBackground(color);
    end
end

set(handles.legendTable,'String',{'no data loaded'});
%initialize maximum dose for visualization to Zero
handles.maxDoseVal     = 0;
handles.IsoDose.Levels = 0;

%seach for availabes machines
handles.Modalities = {'photons','protons','carbon'};
for i = 1:length(handles.Modalities)
    pattern = [handles.Modalities{1,i} '_*'];
    if isdeployed
        Files = dir([ctfroot filesep 'matRad' filesep pattern]);
    else
        Files = dir([fileparts(mfilename('fullpath')) filesep pattern]);        
    end
    for j = 1:length(Files)
        if ~isempty(Files)
            MachineName = Files(j).name(numel(handles.Modalities{1,i})+2:end-4);
            if isfield(handles,'Machines')
                if sum(strcmp(handles.Machines,MachineName)) == 0
                  handles.Machines{size(handles.Machines,2)+1} = MachineName;
                end
            else
                handles.Machines = cell(1);
                handles.Machines{1} = MachineName;
            end
        end
    end
end
set(handles.popUpMachine,'String',handles.Machines);


vChar = get(handles.editGantryAngle,'String');
if strcmp(vChar(1,1),'0') && length(vChar)==6
    set(handles.editGantryAngle,'String','0');
end
vChar = get(handles.editCouchAngle,'String');
if strcmp(vChar(1,1),'0') && length(vChar)==3
    set(handles.editCouchAngle,'String','0')
end
%% 
% handles.State=0   no data available
% handles.State=1   ct cst and pln available; ready for dose calculation
% handles.State=2   ct cst and pln available and dij matric(s) are calculated;
%                   ready for optimization
% handles.State=3   plan is optimized


% if plan is changed go back to state 1
% if table VOI Type or Priorities changed go to state 1
% if objective parameters changed go back to state 2
handles.CutOffLevel            = 0.005;
handles.IsoDose.NewIsoDoseFlag = false;
handles.TableChanged           = false;
handles.State                  = 0;
handles.doseOpacity            = 0.6;

%% parse variables from base workspace
AllVarNames = evalin('base','who');

try
    if  ismember('ct',AllVarNames) &&  ismember('cst',AllVarNames)
        ct  = evalin('base','ct');
        cst = evalin('base','cst');
        setCstTable(handles,cst);
        
        %if has intOptParameters
        gvs =who('global');
        
        if ismember('intOptParameters',gvs)  
            updateUITabelData(handles);
        end

        handles.State = 1;
        % check if contours are precomputed
        if size(cst,2) < 7
            cst = matRad_computeVoiContours(ct,cst);
            assignin('base','cst',cst);
        end
        
    elseif ismember('ct',AllVarNames) &&  ~ismember('cst',AllVarNames)
         handles = showError(handles,'GUI OpeningFunc: could not find cst file');
    elseif ~ismember('ct',AllVarNames) &&  ismember('cst',AllVarNames)
         handles = showError(handles,'GUI OpeningFunc: could not find ct file');
    end
catch  
   handles = showError(handles,'GUI OpeningFunc: Could not load ct and cst file');
end

%set plan if available - if not create one
try 
     if ismember('pln',AllVarNames) && handles.State > 0 
          setPln(handles); 
     elseif handles.State > 0 
          getPlnFromGUI(handles);
     end
catch
       handles.State = 0;
       handles = showError(handles,'GUI OpeningFunc: Could not set or get pln');
end

% check for dij structure
if ismember('dij',AllVarNames)
    handles.State = 2;
end

% check for optimized results
if ismember('resultGUI',AllVarNames)
    handles.State = 3;
end

% set some default values
if handles.State == 2 || handles.State == 3
    set(handles.popupDisplayOption,'String','physicalDose');
    handles.SelectedDisplayOption ='physicalDose';
    handles.SelectedDisplayOptionIdx=1;
else
    handles.resultGUI = [];
    set(handles.popupDisplayOption,'String','no option available');
    handles.SelectedDisplayOption='';
    handles.SelectedDisplayOptionIdx=1;
end

% precompute iso dose lines
if handles.State == 3
    handles = updateIsoDoseLineCache(handles);
end

%per default the first beam is selected for the profile plot
handles.SelectedBeam = 1;
handles.plane = get(handles.popupPlane,'Value');
handles.DijCalcWarning = false;

% set slice slider
if handles.State > 0
    set(handles.sliderSlice,'Min',1,'Max',ct.cubeDim(handles.plane),...
            'Value',ceil(ct.cubeDim(handles.plane)/2),...
            'SliderStep',[1/(ct.cubeDim(handles.plane)-1) 1/(ct.cubeDim(handles.plane)-1)]);      
    
    % define context menu for structures
    for i = 1:size(cst,1)
        if cst{i,5}.Visible
            handles.VOIPlotFlag(i) = true;
        else
            handles.VOIPlotFlag(i) = false;
        end
    end
end

%Initialize colormaps and windows
handles.doseColorMap = 'jet';
handles.ctColorMap = 'bone';
handles.cMapSize = 64;
handles.cBarChanged = true;
handles.doseWindow = [];
handles.ctWindow = [];

%Set up the colormap selection box
availableColormaps = matRad_getColormap();
set(handles.popupmenu_chooseColormap,'String',availableColormaps);

currentCtMapIndex = find(strcmp(availableColormaps,handles.ctColorMap));
currentDoseMapIndex = find(strcmp(availableColormaps,handles.doseColorMap));

if handles.State >= 1    
   set(handles.popupmenu_chooseColormap,'Value',currentCtMapIndex);
end

if handles.State >= 3
    set(handles.popupmenu_chooseColormap,'Value',currentDoseMapIndex);
end

% Update handles structure
handles.profileOffset = 0;
UpdateState(handles)

axes(handles.axesFig)

handles.rememberCurrAxes = false;
UpdatePlot(handles)
handles.rememberCurrAxes = true;

guidata(hObject, handles);


function Callback_StructVisibilty(source,~)

handles = guidata(findobj('Name','matRad_IntuitiveOptGUI'));

contextUiChildren = get(get(handles.figure1,'UIContextMenu'),'Children');

Idx = find(strcmp(get(contextUiChildren,'Label'),get(source,'Label')));
if strcmp(get(source,'Checked'),'on')
    set(contextUiChildren(Idx),'Checked','off');
else
    set(contextUiChildren(Idx),'Checked','on');
end
%guidata(findobj('Name','matRad_IntuitiveOptGUI'), handles);
UpdatePlot(handles);

Update
% --- Outputs from this function are returned to the command line.
function varargout = matRad_IntuitiveOptGUI_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% set focus on error dialog
if isfield(handles,'ErrorDlg')
    figure(handles.ErrorDlg)
end

% --- Executes on button press in btnLoadMat.
function btnLoadMat_Callback(hObject, ~, handles)
% hObject    handle to btnLoadMat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try 
    [FileName, FilePath] = uigetfile('*.mat');
    
    if FileName == 0 % user pressed cancel --> do nothing.
        return;
    end
    
    % delete existing workspace - parse variables from base workspace
    AllVarNames = evalin('base','who');
    RefVarNames = {'ct','cst','pln','stf','dij','resultGUI'};
    
    for i = 1:length(RefVarNames)  
        if sum(ismember(AllVarNames,RefVarNames{i}))>0
            evalin('base',['clear ', RefVarNames{i}]);
        end
    end

    % clear state and read new data
    handles.State = 0;
    fprintf('Begin loading the  mat file  ........ \n');
    load([FilePath FileName]);
    fprintf('End loading mat file! \n');
   
    set(handles.legendTable,'String',{'no data loaded'});
    
catch
    handles = showWarning(handles,'LoadMatFileFnc: Could not load *.mat file');
    guidata(hObject,handles);
    UpdateState(handles);
    UpdatePlot(handles);
    return
end

try
    setCstTable(handles,cst);
    handles.TableChanged = false;
    set(handles.popupTypeOfPlot,'Value',1);
    % precompute contours 
    fprintf('Beging pre compute VOI Contours! \n');
    cst = matRad_computeVoiContours(ct,cst);
    fprintf('End pre compute VOI Contours! \n');
    
    assignin('base','ct',ct);
    assignin('base','cst',cst);
catch
    handles = showError(handles,'LoadMatFileFnc: Could not load selected data');
end

try
    if exist('pln','var')
        % assess plan from loaded *.mat file
        assignin('base','pln',pln);
        setPln(handles);
    else
        % assess plan variable from GUI
        getPlnFromGUI(handles);
        setPln(handles);
    end
    handles.State = 1;
catch
    handles.State = 0;
end


% check if a optimized plan was loaded
if exist('stf','var')
    assignin('base','stf',stf);
end
if exist('dij','var')
    assignin('base','dij',dij);
end
if exist('stf','var') && exist('dij','var')
    handles.State = 2;
end

if exist('resultGUI','var')
    assignin('base','resultGUI',resultGUI);
    handles.State = 3;
    handles.SelectedDisplayOption ='physicalDose';
end

% set slice slider
handles.plane = get(handles.popupPlane,'value');
if handles.State >0
     set(handles.sliderSlice,'Min',1,'Max',ct.cubeDim(handles.plane),...
            'Value',round(ct.cubeDim(handles.plane)/2),...
            'SliderStep',[1/(ct.cubeDim(handles.plane)-1) 1/(ct.cubeDim(handles.plane)-1)]);
end

if handles.State > 0
     % define context menu for structures
    for i = 1:size(cst,1)
        if cst{i,5}.Visible
            handles.VOIPlotFlag(i) = true;
        else
            handles.VOIPlotFlag(i) = false;
        end
    end
end

%Reset colorbar
handles.ctWindow = [];
handles.doseWindow = [];
handles.cBarChanged = true;

UpdateState(handles);
handles.rememberCurrAxes = false;
UpdatePlot(handles);
handles.rememberCurrAxes = true;
guidata(hObject,handles);



% --- Executes on button press in btnLoadDicom.
function btnLoadDicom_Callback(hObject, ~, handles)
% hObject    handle to btnLoadDicom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    % delete existing workspace - parse variables from base workspace
    AllVarNames = evalin('base','who');
    RefVarNames = {'ct','cst','pln','stf','dij','resultGUI'};
    for i = 1:length(RefVarNames)  
        if sum(ismember(AllVarNames,RefVarNames{i}))>0
            evalin('base',['clear ', RefVarNames{i}]);
        end
    end
    handles.State = 0;
    if ~isdeployed
        matRadRootDir = fileparts(mfilename('fullpath'));
        addpath(fullfile(matRadRootDir,'dicomImport'))
    end
    matRad_importDicomGUI;
 
catch
   handles = showError(handles,'DicomImport: Could not import data'); 
end
UpdateState(handles);
guidata(hObject,handles);


% --- Executes on button press in btn_export.
function btn_export_Callback(hObject, eventdata, handles)
% hObject    handle to btn_export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    if ~isdeployed
        matRadRootDir = fileparts(mfilename('fullpath'));
        addpath(fullfile(matRadRootDir,'IO'))
    end
    matRad_exportGUI;
catch
    handles = showError(handles,'Could not export data'); 
end
UpdateState(handles);
guidata(hObject,handles);

function editBixelWidth_Callback(hObject, ~, handles)
% hObject    handle to editBixelWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBixelWidth as text
%        str2double(get(hObject,'String')) returns contents of editBixelWidth as a double
getPlnFromGUI(handles);
if handles.State > 0
    handles.State = 1;
    UpdateState(handles);
    guidata(hObject,handles);
end

function editGantryAngle_Callback(hObject, ~, handles)
% hObject    handle to editGantryAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editGantryAngle as text
%        str2double(get(hObject,'String')) returns contents of editGantryAngle as a double
getPlnFromGUI(handles);
if handles.State > 0
    handles.State = 1;
    UpdateState(handles);
    guidata(hObject,handles);
end

function editCouchAngle_Callback(hObject, ~, handles)
% hObject    handle to editCouchAngle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editCouchAngle as text
%        str2double(get(hObject,'String')) returns contents of editCouchAngle as a double
getPlnFromGUI(handles);
if handles.State > 0
    handles.State = 1;
    UpdateState(handles);
    guidata(hObject,handles);
end

% --- Executes on selection change in popupRadMode.
function popupRadMode_Callback(hObject, eventdata, handles)
% hObject    handle to popupRadMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
checkRadiationComposition(handles);
contents = cellstr(get(hObject,'String')); 
RadIdentifier = contents{get(hObject,'Value')};

switch RadIdentifier
    case 'photons'
        set(handles.vmcFlag,'Value',0);
        set(handles.vmcFlag,'Enable','on')
        set(handles.radbtnBioOpt,'Value',0);
        set(handles.radbtnBioOpt,'Enable','off');
        set(handles.btnTypBioOpt,'Enable','off');
        set(handles.btnSetTissue,'Enable','off');
        
        set(handles.btnRunSequencing,'Enable','on');
        set(handles.btnRunDAO,'Enable','on');
        set(handles.txtSequencing,'Enable','on');
        set(handles.editSequencingLevel,'Enable','on');
        
    case 'protons'
        set(handles.vmcFlag,'Value',0);
        set(handles.vmcFlag,'Enable','off')
        set(handles.radbtnBioOpt,'Value',0);
        set(handles.radbtnBioOpt,'Enable','off');
        set(handles.btnTypBioOpt,'Enable','off');
        set(handles.btnSetTissue,'Enable','off');
        
        set(handles.btnRunSequencing,'Enable','off');
        set(handles.btnRunDAO,'Enable','off');
        set(handles.txtSequencing,'Enable','off');
        set(handles.editSequencingLevel,'Enable','off');
        
    case 'carbon'
        set(handles.vmcFlag,'Value',0);
        set(handles.vmcFlag,'Enable','off')        
        set(handles.radbtnBioOpt,'Value',1);
        set(handles.radbtnBioOpt,'Enable','on');
        set(handles.btnTypBioOpt,'Enable','on');
        set(handles.btnSetTissue,'Enable','on');
        
        set(handles.btnRunSequencing,'Enable','off');
        set(handles.btnRunDAO,'Enable','off');
        set(handles.txtSequencing,'Enable','off');
        set(handles.editSequencingLevel,'Enable','off');
end

if handles.State > 0
    pln = evalin('base','pln');
    if handles.State > 0 && ~strcmp(contents(get(hObject,'Value')),pln.radiationMode)
        
        % switched from carbon to photons or protons -> in case of bio. opt
        % some cubes have to be deleted from the resultGUI struct
        if strcmp(pln.radiationMode,'carbon') && ~strcmp(contents(get(hObject,'Value')),'carbon')
            try
               AllVarNames = evalin('base','who');
               if  ismember('resultGUI',AllVarNames)
                    resultGUI = evalin('base','resultGUI');
                    resultGUI = rmfield(resultGUI,'effect');
                    resultGUI = rmfield(resultGUI,'alpha');
                    resultGUI = rmfield(resultGUI,'beta');
                    resultGUI = rmfield(resultGUI,'RBE');
                    resultGUI = rmfield(resultGUI,'RBExDose');
                    assignin('base','resultGUI',resultGUI)
               end
            catch
                assignin('base','resultGUI',resultGUI)
            end
            UpdatePlot(handles);
        end
        
        getPlnFromGUI(handles);
        handles.State = 1;
        UpdateState(handles);
        guidata(hObject,handles);
        
    end
         
   
end

% --- Executes on button press in radbtnBioOpt.
function radbtnBioOpt_Callback(hObject, ~, handles)
% hObject    handle to radbtnBioOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radbtnBioOpt
getPlnFromGUI(handles);
if get(hObject,'Value')
    set(handles.btnTypBioOpt,'Enable','on');
    set(handles.btnSetTissue,'Enable','on');
else
    set(handles.btnTypBioOpt,'Enable','off');
    set(handles.btnSetTissue,'Enable','off');
end

if handles.State > 0
    handles.State = 1;
    UpdateState(handles);
    guidata(hObject,handles);
end

% --- Executes on button press in btnCalcDose.
function btnCalcDose_Callback(hObject, ~, handles)
% hObject    handle to btnCalcDose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% http://stackoverflow.com/questions/24703962/trigger-celleditcallback-before-button-callback
% http://www.mathworks.com/matlabcentral/newsreader/view_thread/332613
% wait some time until the CallEditCallback is finished 
% Callback triggers the cst saving mechanism from GUI
try
    % indicate that matRad is busy
    % change mouse pointer to hour glass 
    Figures = gcf;%findobj('type','figure');
    set(Figures, 'pointer', 'watch'); 
    drawnow;
    % disable all active objects
    InterfaceObj = findobj(Figures,'Enable','on');
    set(InterfaceObj,'Enable','off');
    
    pause(0.1);
    uiTable_CellEditCallback(hObject,[],handles);
    pause(0.3);

    %% get cst from table
    if ~getCstTable(handles);
        return
    end
    % read plan from gui and save it to workspace
    % gets also IsoCenter from GUI if checkbox is not checked
    getPlnFromGUI(handles);

    % get default iso center as center of gravity of all targets if not
    % already defined
    pln = evalin('base','pln');

    if length(pln.gantryAngles) ~= length(pln.couchAngles) 
        handles = showWarning(handles,warndlg('number of gantryAngles != number of couchAngles')); 
    end
    %%
    if ~checkRadiationComposition(handles);
        fileName = [pln.radiationMode '_' pln.machine];
        handles = showError(handles,errordlg(['Could not find the following machine file: ' fileName ]));
        guidata(hObject,handles);
        return;
    end

    %% check if isocenter is already set
    if ~isfield(pln,'isoCenter')
        handles = showWarning(handles,warning('no iso center set - using center of gravity based on structures defined as TARGET'));
        pln.isoCenter = matRad_getIsoCenter(evalin('base','cst'),evalin('base','ct'));
        assignin('base','pln',pln);
    elseif ~get(handles.checkIsoCenter,'Value') 
        pln.isoCenter = str2num(get(handles.editIsoCenter,'String'));
    end

catch ME
    handles = showError(handles,{'CalcDoseCallback: Error in preprocessing!',ME.message}); 
    % change state from busy to normal
    set(Figures, 'pointer', 'arrow');
    set(InterfaceObj,'Enable','on');
    guidata(hObject,handles);
    return;
end

% generate steering file
try 
    stf = matRad_generateStf(evalin('base','ct'),...
                                     evalin('base','cst'),...
                                     evalin('base','pln'));
                                 
   
    assignin('base','stf',stf);
catch ME
    handles = showError(handles,{'CalcDoseCallback: Error in steering file generation!',ME.message}); 
    % change state from busy to normal
    set(Figures, 'pointer', 'arrow');
    set(InterfaceObj,'Enable','on');
    guidata(hObject,handles);
    return;
end

% carry out dose calculation
try
    if strcmp(pln.radiationMode,'photons')
        if get(handles.vmcFlag,'Value') == 0
            dij = matRad_calcPhotonDose(evalin('base','ct'),stf,pln,evalin('base','cst'));
        elseif get(handles.vmcFlag,'Value') == 1
            if ~isdeployed
                dij = matRad_calcPhotonDoseVmc(evalin('base','ct'),stf,pln,evalin('base','cst'));
            else
                error('VMC++ not available in matRad standalone application');
            end
        end
    elseif strcmp(pln.radiationMode,'protons') || strcmp(pln.radiationMode,'carbon')
        dij = matRad_calcParticleDose(evalin('base','ct'),stf,pln,evalin('base','cst'));
    end

    % assign results to base worksapce
    assignin('base','dij',dij);
    handles.State = 2;
    handles.TableChanged = false;
    UpdateState(handles);
    UpdatePlot(handles);
    guidata(hObject,handles);
catch ME
    handles = showError(handles,{'CalcDoseCallback: Error in dose calculation!',ME.message}); 
    % change state from busy to normal
    set(Figures, 'pointer', 'arrow');
    set(InterfaceObj,'Enable','on');
    guidata(hObject,handles);
    return;
end

% change state from busy to normal
set(Figures, 'pointer', 'arrow');
set(InterfaceObj,'Enable','on');

guidata(hObject,handles);  



%% plots ct and distributions
function UpdatePlot(handles)

axes(handles.axesFig);

defaultFontSize = 8;
currAxes            = axis;
AxesHandlesCT_Dose  = gobjects(0);
AxesHandlesVOI      = gobjects(0);
AxesHandlesIsoDose  = gobjects(0);

if handles.State == 0
    return
elseif handles.State > 0
     ct  = evalin('base','ct');
     cst = evalin('base','cst');
     pln = evalin('base','pln');
end

%% state 3 indicates that a optimization has been performed
if handles.State > 2
      Result = evalin('base','resultGUI');
end

if exist('Result','var')
    if ~isempty(Result) && ~isempty(ct.cube)
       
        if isfield(Result,'RBE')
            Result.RBETruncated10Perc = Result.RBE;
            Result.RBETruncated10Perc(Result.physicalDose<0.1*...
                max(Result.physicalDose(:))) = 0;
        end

        DispInfo =fieldnames(Result);
        for i = 1:size(DispInfo,1)
            
            if isstruct(Result.(DispInfo{i,1})) || isvector(Result.(DispInfo{i,1}))
                 Result = rmfield(Result,DispInfo{i,1});
                 DispInfo{i,2}=false;
            else
                %second dimension indicates if it should be plotted later on
                DispInfo{i,2}=true;
                DisablePlot = {'RBETruncated10Perc'};
                if strcmp(DispInfo{i,1},DisablePlot)
                    DispInfo{i,2}=false;
                end
                
                % determine units
                if strfind(DispInfo{i,1},'physicalDose');
                    DispInfo{i,3} = '[Gy]';
                elseif strfind(DispInfo{i,1},'alpha')
                    DispInfo{i,3} = '[Gy^{-1}]';
                elseif strfind(DispInfo{i,1},'beta')
                    DispInfo{i,3} = '[Gy^{-2}]';
                elseif strfind(DispInfo{i,1},'RBExD')
                    DispInfo{i,3} = '[Gy(RBE)]';
                elseif strfind(DispInfo{i,1},'LET')
                    DispInfo{i,3} = '[keV/um]';
                else
                    DispInfo{i,3} = '[a.u.]';
                end
                
            end
        end

        set(handles.popupDisplayOption,'String',fieldnames(Result));
        if sum(strcmp(handles.SelectedDisplayOption,fieldnames(Result))) == 0
            handles.SelectedDisplayOption = 'physicalDose';
        end
        set(handles.popupDisplayOption,'Value',find(strcmp(handles.SelectedDisplayOption,fieldnames(Result))));

    end
end

%% set and get required variables
plane = get(handles.popupPlane,'Value');
slice = round(get(handles.sliderSlice,'Value'));
hold(handles.axesFig,'on');
if get(handles.popupTypeOfPlot,'Value')==1
    set(handles.axesFig,'YDir','Reverse');
end

%% Remove colorbar?
plotColorbarSelection = get(handles.popupmenu_chooseColorData,'Value');

if get(handles.popupTypeOfPlot,'Value')==2 || plotColorbarSelection == 1
    if isfield(handles,'cBarHandel')
        delete(handles.cBarHandel);
    end
    %The following seems to be necessary as MATLAB messes up some stuff 
    %with the handle storage
    ch = findall(gcf,'tag','Colorbar');
    if ~isempty(ch)
        delete(ch);
    end
end

%% plot ct - if a ct cube is available and type of plot is set to 1 and not 2; 1 indicate cube plotting and 2 profile plotting
if ~isempty(ct) && get(handles.popupTypeOfPlot,'Value')==1
    cla(handles.axesFig);
    
    ctMap = matRad_getColormap(handles.ctColorMap,handles.cMapSize);   
    [AxesHandlesCT_Dose(end+1),~,handles.ctWindow] = matRad_plotCtSlice(handles.axesFig,ct,1,plane,slice,ctMap,handles.ctWindow);
    
    % plot colorbar? If 1 the user asked for the CT
    if plotColorbarSelection == 2 && handles.cBarChanged
        %Plot the colorbar
        handles.cBarHandel = matRad_plotColorbar(handles.axesFig,ctMap,handles.ctWindow,'fontsize',defaultFontSize);
        %adjust lables
        set(get(handles.cBarHandel,'ylabel'),'String', 'Electron Density','fontsize',defaultFontSize);
        % do not interprete as tex syntax
        set(get(handles.cBarHandel,'ylabel'),'interpreter','none');
    end
end

%% plot dose cube
if handles.State >2 &&  get(handles.popupTypeOfPlot,'Value')== 1
        doseMap = matRad_getColormap(handles.doseColorMap,handles.cMapSize);
    
        % if the selected display option doesn't exist then simply display
        % the first cube of the Result struct
        if ~isfield(Result,handles.SelectedDisplayOption)
            CubeNames = fieldnames(Result);
            handles.SelectedDisplayOption = CubeNames{1,1};
        end
        dose = Result.(handles.SelectedDisplayOption);

        % dose colorwash
        if ~isempty(dose) && ~isvector(dose)
            
            if handles.maxDoseVal == 0
                handles.maxDoseVal = max(dose(:));
                set(handles.txtMaxDoseVal,'String',num2str(handles.maxDoseVal))
            end

            if get(handles.radiobtnDose,'Value')
                if strcmp(get(handles.popupDisplayOption,'String'),'RBETruncated10Perc')
                    doseThresh = 0.1;
                else
                    doseThresh = handles.CutOffLevel;
                end
                doseAlpha                         = handles.doseOpacity;
                [doseHandle,~,handles.doseWindow] = matRad_plotDoseSlice(handles.axesFig,dose,plane,slice,doseThresh,doseAlpha,doseMap,handles.doseWindow);
                AxesHandlesCT_Dose(end+1)         = doseHandle;
            end            
                 
            % plot colorbar?
            if plotColorbarSelection > 2 && handles.cBarChanged;
                %Plot the colorbar
                handles.cBarHandel = matRad_plotColorbar(handles.axesFig,doseMap,handles.doseWindow,'fontsize',defaultFontSize);
                %adjust lables
                Idx = find(strcmp(handles.SelectedDisplayOption,DispInfo(:,1)));
                set(get(handles.cBarHandel,'ylabel'),'String', [DispInfo{Idx,1} ' ' DispInfo{Idx,3} ],'fontsize',defaultFontSize);
                % do not interprete as tex syntax
                set(get(handles.cBarHandel,'ylabel'),'interpreter','none');
            end
        end
        
    %axes(handles.axesFig)
    %text(0,0,'','units','norm') % fix for line width ...


        %% plot iso dose lines
        if get(handles.radiobtnIsoDoseLines,'Value')           
            plotLabels = get(handles.radiobtnIsoDoseLinesLabels,'Value') == 1;
            AxesHandlesIsoDose = matRad_plotIsoDoseLines(handles.axesFig,dose,handles.IsoDose.Contours,handles.IsoDose.Levels,plotLabels,plane,slice,doseMap,handles.doseWindow);
        end
end


%% plot VOIs
if get(handles.radiobtnContour,'Value') && get(handles.popupTypeOfPlot,'Value')==1 && handles.State>0
    AxesHandlesVOI = [AxesHandlesVOI matRad_plotVoiContourSlice(handles.axesFig,cst,ct,1,handles.VOIPlotFlag,plane,slice,colorcube)];
end

%% Set axis labels and plot iso center
if  plane == 3% Axial plane
    if ~isempty(pln)
        set(handles.axesFig,'XTick',0:50/ct.resolution.x:1000);
        set(handles.axesFig,'YTick',0:50/ct.resolution.y:1000);
        set(handles.axesFig,'XTickLabel',0:50:1000*ct.resolution.x);
        set(handles.axesFig,'YTickLabel',0:50:1000*ct.resolution.y);   
        xlabel('x [mm]','FontSize',defaultFontSize)
        ylabel('y [mm]','FontSize',defaultFontSize)
        title(['axial plane z = ' num2str(ct.resolution.z*slice) ' [mm]'],'FontSize',defaultFontSize)
    else
        xlabel('x [voxels]','FontSize',defaultFontSize)
        ylabel('y [voxels]','FontSize',defaultFontSize)
        title('axial plane','FontSize',defaultFontSize)
    end
elseif plane == 2 % Sagittal plane
    if ~isempty(pln)
        set(handles.axesFig,'XTick',0:50/ct.resolution.z:1000)
        set(handles.axesFig,'YTick',0:50/ct.resolution.y:1000)
        set(handles.axesFig,'XTickLabel',0:50:1000*ct.resolution.z)
        set(handles.axesFig,'YTickLabel',0:50:1000*ct.resolution.y)
        xlabel('z [mm]','FontSize',defaultFontSize);
        ylabel('y [mm]','FontSize',defaultFontSize);
        title(['sagittal plane x = ' num2str(ct.resolution.y*slice) ' [mm]'],'FontSize',defaultFontSize)
    else
        xlabel('z [voxels]','FontSize',defaultFontSize)
        ylabel('y [voxels]','FontSize',defaultFontSize)
        title('sagittal plane','FontSize',defaultFontSize);
    end
elseif plane == 1 % Coronal plane
    if ~isempty(pln)
        set(handles.axesFig,'XTick',0:50/ct.resolution.z:1000)
        set(handles.axesFig,'YTick',0:50/ct.resolution.x:1000)
        set(handles.axesFig,'XTickLabel',0:50:1000*ct.resolution.z)
        set(handles.axesFig,'YTickLabel',0:50:1000*ct.resolution.x)
        xlabel('z [mm]','FontSize',defaultFontSize)
        ylabel('x [mm]','FontSize',defaultFontSize)
        title(['coronal plane y = ' num2str(ct.resolution.x*slice) ' [mm]'],'FontSize',defaultFontSize)
    else
        xlabel('z [voxels]','FontSize',defaultFontSize)
        ylabel('x [voxels]','FontSize',defaultFontSize)
        title('coronal plane','FontSize',defaultFontSize)
    end
end

if get(handles.radioBtnIsoCenter,'Value') == 1 && get(handles.popupTypeOfPlot,'Value') == 1 && ~isempty(pln)
    hIsoCenterCross = matRad_plotIsoCenterMarker(handles.axesFig,pln,ct,plane,slice);
end

% the following line ensures the plotting order (optional)
% set(gca,'Children',[AxesHandlesCT_Dose hIsoCenterCross AxesHandlesIsoDose  AxesHandlesVOI ]);    
  
%set axis ratio
ratios = [1/ct.resolution.x 1/ct.resolution.y 1/ct.resolution.z];
set(handles.axesFig,'DataAspectRatioMode','manual');
if plane == 1 
      res = [ratios(3) ratios(2)]./max([ratios(3) ratios(2)]);  
      set(handles.axesFig,'DataAspectRatio',[res 1])
elseif plane == 2 % sagittal plane
      res = [ratios(3) ratios(1)]./max([ratios(3) ratios(1)]);  
      set(handles.axesFig,'DataAspectRatio',[res 1]) 
elseif  plane == 3 % Axial plane
      res = [ratios(2) ratios(1)]./max([ratios(2) ratios(1)]);  
      set(handles.axesFig,'DataAspectRatio',[res 1])
end


%% profile plot
if get(handles.popupTypeOfPlot,'Value') == 2 && exist('Result','var')
    % set SAD
    fileName = [pln.radiationMode '_' pln.machine];
    try
        load(fileName);
        SAD = machine.meta.SAD;
    catch
        error(['Could not find the following machine file: ' fileName ]); 
    end
     
    % clear view and initialize some values
    cla(handles.axesFig,'reset')
    set(gca,'YDir','normal');
    ylabel('{\color{black}dose [Gy]}')
    cColor={'black','green','magenta','cyan','yellow','red','blue'};
    
    % Rotation around Z axis (table movement)
    inv_rotMx_XY_T = [ cosd(pln.gantryAngles(handles.SelectedBeam)) sind(pln.gantryAngles(handles.SelectedBeam)) 0;
                      -sind(pln.gantryAngles(handles.SelectedBeam)) cosd(pln.gantryAngles(handles.SelectedBeam)) 0;
                                                                  0 0 1];
    % Rotation around Y axis (Couch movement)
    inv_rotMx_XZ_T = [cosd(pln.couchAngles(handles.SelectedBeam)) 0 -sind(pln.couchAngles(handles.SelectedBeam));
                                                                0 1 0;
                      sind(pln.couchAngles(handles.SelectedBeam)) 0 cosd(pln.couchAngles(handles.SelectedBeam))];
    
    if strcmp(handles.ProfileType,'longitudinal')
        sourcePointBEV = [handles.profileOffset -SAD   0];
        targetPointBEV = [handles.profileOffset  SAD   0];
    elseif strcmp(handles.ProfileType,'lateral')
        sourcePointBEV = [-SAD handles.profileOffset   0];
        targetPointBEV = [ SAD handles.profileOffset   0];
    end
    
    rotSourcePointBEV = sourcePointBEV * inv_rotMx_XZ_T * inv_rotMx_XY_T;
    rotTargetPointBEV = targetPointBEV * inv_rotMx_XZ_T * inv_rotMx_XY_T;
    
    % perform raytracing on the central axis of the selected beam
    [~,l,rho,~,ix] = matRad_siddonRayTracer(pln.isoCenter,ct.resolution,rotSourcePointBEV,rotTargetPointBEV,{ct.cube{1}});
    d = [0 l .* rho{1}];
    % Calculate accumulated d sum.
    vX = cumsum(d(1:end-1));
    
    % this step is necessary if visualization is set to profile plot
    % and another optimization is carried out - set focus on GUI
    figHandles = get(0,'Children');
    idxHandle = [];
    if ~isempty(figHandles)
        v=version;
        if str2double(v(1:3))>= 8.5
            idxHandle = strcmp({figHandles(:).Name},'matRad_IntuitiveOptGUI');
        else
            idxHandle = strcmp(get(figHandles,'Name'),'matRad_IntuitiveOptGUI');
        end
    end
    figure(figHandles(idxHandle));
    
    % plot physical dose
    Content = get(handles.popupDisplayOption,'String');
    SelectedCube = Content{get(handles.popupDisplayOption,'Value')};
    if sum(strcmp(SelectedCube,{'physicalDose','effect','RBExDose','alpha','beta','RBE'})) > 0
         Suffix = '';
    else
        Idx    = find(SelectedCube == '_');
        Suffix = SelectedCube(Idx:end);
    end
    
    mPhysDose = Result.(['physicalDose' Suffix]); 
    PlotHandles{1} = plot(handles.axesFig,vX,mPhysDose(ix),'color',cColor{1,1},'LineWidth',3); hold on; 
    PlotHandles{1,2} ='physicalDose';
    ylabel(handles.axesFig,'dose in [Gy]');
    set(handles.axesFig,'FontSize',defaultFontSize);
    
    % plot counter
    Cnt=2;
    
    if isfield(Result,['RBE' Suffix])
        
        %disbale specific plots
        %DispInfo{6,2}=0;
        %DispInfo{5,2}=0;
        %DispInfo{2,2}=0;
        
        % generate two lines for ylabel
        StringYLabel1 = '\fontsize{8}{\color{red}RBE x dose [Gy(RBE)] \color{black}dose [Gy] ';
        StringYLabel2 = '';
        for i=1:1:size(DispInfo,1)
            if DispInfo{i,2} && sum(strcmp(DispInfo{i,1},{['effect' Suffix],['alpha' Suffix],['beta' Suffix]})) > 0
                %physicalDose is already plotted and RBExD vs RBE is plotted later with plotyy
                if ~strcmp(DispInfo{i,1},['RBExDose' Suffix]) &&...
                   ~strcmp(DispInfo{i,1},['RBE' Suffix]) && ...
                   ~strcmp(DispInfo{i,1},['physicalDose' Suffix])
               
                        mCube = Result.([DispInfo{i,1}]);
                        PlotHandles{Cnt,1} = plot(handles.axesFig,vX,mCube(ix),'color',cColor{1,Cnt},'LineWidth',3);hold on; 
                        PlotHandles{Cnt,2} = DispInfo{i,1};
                        StringYLabel2 = [StringYLabel2  ' \color{'  cColor{1,Cnt} '}' DispInfo{i,1} ' ['  DispInfo{i,3} ']'];
                        Cnt = Cnt+1;
                end    
            end
        end
        StringYLabel2 = [StringYLabel2 '}'];
        % always plot RBExD against RBE
        mRBExDose = Result.(['RBExDose' Suffix]);
        vBED = mRBExDose(ix);
        mRBE = Result.(['RBE' Suffix]);
        vRBE = mRBE(ix);
        
        % plot biological dose against RBE
        [ax, PlotHandles{Cnt,1}, PlotHandles{Cnt+1,1}]=plotyy(handles.axesFig,vX,vBED,vX,vRBE,'plot');hold on;
        PlotHandles{Cnt,2}='RBExDose';
        PlotHandles{Cnt+1,2}='RBE';
         
        % set plotyy properties
        set(get(ax(2),'Ylabel'),'String','RBE [a.u.]','FontSize',8);       
        ylabel({StringYLabel1;StringYLabel2})
        set(PlotHandles{Cnt,1},'Linewidth',4,'color','r');
        set(PlotHandles{Cnt+1,1},'Linewidth',3,'color','b');
        set(ax(1),'ycolor','r')
        set(ax(2),'ycolor','b')
        set(ax,'FontSize',8);
        Cnt=Cnt+2;
    end
       
    % asses target coordinates 
    tmpPrior = intmax;
    tmpSize = 0;
    for i=1:size(cst,1)
        if strcmp(cst{i,3},'TARGET') && tmpPrior >= cst{i,5}.Priority && tmpSize<numel(cst{i,4}{1})
           linIdxTarget = unique(cst{i,4}{1});
           tmpPrior=cst{i,5}.Priority;
           tmpSize=numel(cst{i,4}{1});
           VOI = cst{i,2};
        end
    end
    
    str = sprintf('profile plot - central axis of %d beam gantry angle %d? couch angle %d?',...
        handles.SelectedBeam ,pln.gantryAngles(handles.SelectedBeam),pln.couchAngles(handles.SelectedBeam));
    h_title = title(handles.axesFig,str,'FontSize',defaultFontSize);
    pos = get(h_title,'Position');
    set(h_title,'Position',[pos(1)-40 pos(2) pos(3)])
    
    % plot target boundaries
    mTargetCube = zeros(ct.cubeDim);
    mTargetCube(linIdxTarget) = 1;
    vProfile = mTargetCube(ix);
    WEPL_Target_Entry = vX(find(vProfile,1,'first'));
    WEPL_Target_Exit  = vX(find(vProfile,1,'last'));
    PlotHandles{Cnt,2} =[VOI ' boundary'];
    
    if ~isempty(WEPL_Target_Entry) && ~isempty(WEPL_Target_Exit)
        hold on
        PlotHandles{Cnt,1} = ...
        plot([WEPL_Target_Entry WEPL_Target_Entry],get(handles.axesFig,'YLim'),'--','Linewidth',3,'color','k');hold on
        plot([WEPL_Target_Exit WEPL_Target_Exit],get(handles.axesFig,'YLim'),'--','Linewidth',3,'color','k');hold on
      
    else
        PlotHandles{Cnt,1} =[];
    end
    
   Lines  = PlotHandles(~cellfun(@isempty,PlotHandles(:,1)),1);
   Labels = PlotHandles(~cellfun(@isempty,PlotHandles(:,1)),2);
   h=legend(handles.axesFig,[Lines{:}],Labels{:});
   set(h,'FontSize',defaultFontSize);
   xlabel('radiological depth [mm]','FontSize',8);  
   grid on, grid minor
   
end

zoom reset;
axis tight
if handles.rememberCurrAxes
    axis(currAxes);
end

hold(handles.axesFig,'off');

handles.cBarChanged = false;
guidata(handles.axesFig,handles);

if get(handles.popupTypeOfPlot,'Value')==1 
    UpdateColormapOptions(handles);
end

% --- Executes on selection change in popupPlane.
function popupPlane_Callback(hObject, ~, handles)
% hObject    handle to popupPlane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupPlane contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupPlane

% set slice slider
handles.plane = get(handles.popupPlane,'value');
try
    if handles.State > 0
        ct = evalin('base', 'ct');
        set(handles.sliderSlice,'Min',1,'Max',ct.cubeDim(handles.plane),...
                'SliderStep',[1/(ct.cubeDim(handles.plane)-1) 1/(ct.cubeDim(handles.plane)-1)]);
        if handles.State < 3
            set(handles.sliderSlice,'Value',round(ct.cubeDim(handles.plane)/2));
        else
            pln = evalin('base','pln');
            
            if handles.plane == 1
                set(handles.sliderSlice,'Value',ceil(pln.isoCenter(1,handles.plane)/ct.resolution.x));
            elseif handles.plane == 2
                set(handles.sliderSlice,'Value',ceil(pln.isoCenter(1,handles.plane)/ct.resolution.y));
            elseif handles.plane == 3
                set(handles.sliderSlice,'Value',ceil(pln.isoCenter(1,handles.plane)/ct.resolution.z));
            end
            
        end
    end
catch
end

handles.rememberCurrAxes = false;
UpdatePlot(handles);
handles.rememberCurrAxes = true;
guidata(hObject,handles);

% --- Executes on slider movement.
function sliderSlice_Callback(~, ~, handles)
% hObject    handle to sliderSlice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
UpdatePlot(handles)

% --- Executes on button press in radiobtnContour.
function radiobtnContour_Callback(~, ~, handles)
% hObject    handle to radiobtnContour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobtnContour
UpdatePlot(handles)

% --- Executes on button press in radiobtnDose.
function radiobtnDose_Callback(~, ~, handles)
% hObject    handle to radiobtnDose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobtnDose
UpdatePlot(handles)

% --- Executes on button press in radiobtnIsoDoseLines.
function radiobtnIsoDoseLines_Callback(~, ~, handles)
% hObject    handle to radiobtnIsoDoseLines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobtnIsoDoseLines
UpdatePlot(handles)

% --- Executes on button press in btnIntuitiveOptimize.
function btnIntuitiveOptimize_Callback(hObject, eventdata, handles)
% hObject    handle to btnIntuitiveOptimize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Add DVCM Folder to path for intuitive optimization

if ~isdeployed
    currFolder = fileparts(mfilename('fullpath'));
else
    currFolder = [];
end

addpath(fullfile(currFolder,'DVCM'));

try
    % indicate that matRad is busy
    % change mouse pointer to hour glass 
    Figures = gcf;%findobj('type','figure');
    set(Figures, 'pointer', 'watch'); 
    drawnow;
    % disable all active objects
    InterfaceObj = findobj(Figures,'Enable','on');
    set(InterfaceObj,'Enable','off');
    % wait until the table is updated
    btnTableSave_Callback([],[],handles);


    % if a critical change to the cst has been made which affects the dij matrix
    if handles.DijCalcWarning == true

        choice = questdlg('Overlap priorites of OAR constraints have been edited, a new OAR VOI was added or a critical row constraint was deleted. A new Dij calculation might be necessary.', ...
        'Title','Cancel','Calculate Dij then Optimize','Optimze directly','Optimze directly');

        switch choice
            case 'Cancel'
                set(InterfaceObj,'Enable','on');
                return
            case 'Calculate dij again and optimize'
                handles.DijCalcWarning = false;
                btnCalcDose_Callback(hObject, eventdata, handles)      
            case 'Optimze directly'
                handles.DijCalcWarning = false;       
        end
    end
    
    pln = evalin('base','pln');
    ct  = evalin('base','ct');
    
    % optimize
    [resultGUIcurrentRun,ipoptInfo] = matRad_fluenceOptimization(evalin('base','dij'),evalin('base','cst'),pln);
    
    %if resultGUI already exists then overwrite the "standard" fields
    AllVarNames = evalin('base','who');
    if  ismember('resultGUI',AllVarNames)
        resultGUI = evalin('base','resultGUI');
        sNames = fieldnames(resultGUIcurrentRun);
        for j = 1:length(sNames)
            resultGUI.(sNames{j}) = resultGUIcurrentRun.(sNames{j});
        end
    else
        resultGUI = resultGUIcurrentRun;
    end
    assignin('base','resultGUI',resultGUI);

    % set some values
    if handles.plane == 1
        set(handles.sliderSlice,'Value',ceil(pln.isoCenter(1,handles.plane)/ct.resolution.x));
    elseif handles.plane == 2
        set(handles.sliderSlice,'Value',ceil(pln.isoCenter(1,handles.plane)/ct.resolution.y));
    elseif handles.plane == 3
        set(handles.sliderSlice,'Value',ceil(pln.isoCenter(1,handles.plane)/ct.resolution.z));
    end

    handles.State = 3;
    handles.SelectedDisplayOptionIdx = 1;
    if strcmp(pln.radiationMode,'carbon')
        handles.SelectedDisplayOption = 'RBExDose';
    else
        handles.SelectedDisplayOption = 'physicalDose';
    end
    handles.SelectedBeam = 1;
    
    % check IPOPT status and return message for GUI user if no DAO or
    % particles
    if ~pln.runDAO || ~strcmp(pln.radiationMode,'photons')
        CheckIpoptStatus(ipoptInfo,'Fluence')
    end
    
catch ME
    handles = showError(handles,{'OptimizeCallback: Could not optimize!',ME.message}); 
    % change state from busy to normal
    set(Figures, 'pointer', 'arrow');
    set(InterfaceObj,'Enable','on');
    guidata(hObject,handles);
    return;
end

% perform sequencing and DAO
try
    
    %% sequencing
    if strcmp(pln.radiationMode,'photons') && (pln.runSequencing || pln.runDAO)
    %   resultGUI = matRad_xiaLeafSequencing(resultGUI,evalin('base','stf'),evalin('base','dij')...
    %       ,get(handles.editSequencingLevel,'Value'));
        resultGUI = matRad_engelLeafSequencing(resultGUI,evalin('base','stf'),evalin('base','dij')...
            ,str2double(get(handles.editSequencingLevel,'String')));
        assignin('base','resultGUI',resultGUI);
    end
        
catch ME
    handles = showError(handles,{'OptimizeCallback: Could not perform sequencing',ME.message}); 
    % change state from busy to normal
    set(Figures, 'pointer', 'arrow');
    set(InterfaceObj,'Enable','on');
    guidata(hObject,handles);
    return;
end

try
    %% DAO
    if strcmp(pln.radiationMode,'photons') && pln.runDAO
        handles = showWarning(handles,{'Observe: You are running direct aperture optimization','This is experimental code that has not been thoroughly debugged - especially in combination with constrained optimization.'});
       [resultGUI,ipoptInfo] = matRad_directApertureOptimization(evalin('base','dij'),evalin('base','cst'),...
           resultGUI.apertureInfo,resultGUI,pln);
       assignin('base','resultGUI',resultGUI);
       % check IPOPT status and return message for GUI user
       CheckIpoptStatus(ipoptInfo,'DAO');      
    end
    
    if strcmp(pln.radiationMode,'photons') && (pln.runSequencing || pln.runDAO)
        matRad_visApertureInfo(resultGUI.apertureInfo);
    end
   
catch ME
    handles = showError(handles,{'OptimizeCallback: Could not perform direct aperture optimization',ME.message}); 
    % change state from busy to normal
    set(Figures, 'pointer', 'arrow');
    set(InterfaceObj,'Enable','on');
    guidata(hObject,handles);
    return;
end

% change state from busy to normal
set(Figures, 'pointer', 'arrow');
set(InterfaceObj,'Enable','on');
handles.maxDoseVal = 0;      % if 0 new dose max is determined based on dose cube
handles.rememberCurrAxes = false;
handles.IsoDose.Levels = 0;  % ensure to use default iso dose line spacing
handles = updateIsoDoseLineCache(handles);

handles.cBarChanged = true;

UpdateState(handles);
UpdatePlot(handles);
handles.rememberCurrAxes = true;
    
guidata(hObject,handles);


% the function CheckValidityPln checks if the provided plan is valid so
% that it can be used further on for optimization
function FlagValid = CheckValidityPln(cst)

FlagValid = true;
%check if mean constraint is always used in combination
for i = 1:size(cst,1)
   if ~isempty(cst{i,6})
        if ~isempty(strfind([cst{i,6}.type],'mean')) && isempty(strfind([cst{i,6}.type],'square'))
             FlagValid = false;
             warndlg('mean constraint needs to be defined in addition to a second constraint (e.g. squared deviation)');
             break      
        end
   end
end


% --- Executes on selection change in popupTypeOfPlot
function popupTypeOfPlot_Callback(hObject, ~, handles)

 % intensity plot
if get(hObject,'Value') == 1  
    
    set(handles.sliderBeamSelection,'Enable','off')
    set(handles.sliderOffset,'Enable','off')
    set(handles.popupDisplayOption,'Enable','on')
    set(handles.btnProfileType,'Enable','off');
    set(handles.popupPlane,'Enable','on');
    set(handles.radiobtnContour,'Enable','on');
    set(handles.radiobtnDose,'Enable','on');
    set(handles.radiobtnIsoDoseLines,'Enable','on');
    set(handles.radiobtnIsoDoseLinesLabels,'Enable','on');
    set(handles.sliderSlice,'Enable','on');
    
% profile plot
elseif get(hObject,'Value') == 2
    
    if handles.State > 0
        if length(parseStringAsNum(get(handles.editGantryAngle,'String'),true)) > 1
            
            set(handles.sliderBeamSelection,'Enable','on');
            handles.SelectedBeam = 1;
            pln = evalin('base','pln');
            set(handles.sliderBeamSelection,'Min',handles.SelectedBeam,'Max',pln.numOfBeams,...
                'Value',handles.SelectedBeam,...
                'SliderStep',[1/(pln.numOfBeams-1) 1/(pln.numOfBeams-1)],...
                'Enable','on');

        else
            handles.SelectedBeam = 1;
        end
    
        handles.profileOffset = get(handles.sliderOffset,'Value');

        vMinMax = [-100 100];
        vRange = sum(abs(vMinMax));

        ct = evalin('base','ct');
        if strcmp(get(handles.btnProfileType,'String'),'lateral')
            SliderStep = vRange/ct.resolution.x;       
        else
            SliderStep = vRange/ct.resolution.y;  
        end
        
        set(handles.sliderOffset,'Min',vMinMax(1),'Max',vMinMax(2),...
                    'Value',handles.profileOffset,...
                    'SliderStep',[1/SliderStep 1/SliderStep],...
                    'Enable','on');
    end
    
    
    set(handles.popupDisplayOption,'Enable','on');
    set(handles.btnProfileType,'Enable','on');
    set(handles.popupPlane,'Enable','off');
    set(handles.radiobtnContour,'Enable','off');
    set(handles.radiobtnDose,'Enable','off');
    set(handles.radiobtnIsoDoseLines,'Enable','off');
    set(handles.sliderSlice,'Enable','off');
    set(handles.radiobtnIsoDoseLinesLabels,'Enable','off');
    
    
    set(handles.btnProfileType,'Enable','on')
    
    if strcmp(get(handles.btnProfileType,'String'),'lateral')
        handles.ProfileType = 'longitudinal';
    else
        handles.ProfileType = 'lateral';
    end
    
end

handles.cBarChanged = true;

handles.rememberCurrAxes = false;
cla(handles.axesFig,'reset');
UpdatePlot(handles);
handles.rememberCurrAxes = true;
guidata(hObject, handles);

% --- Executes on selection change in popupDisplayOption.
function popupDisplayOption_Callback(hObject, ~, handles)
content = get(hObject,'String');
handles.SelectedDisplayOption = content{get(hObject,'Value'),1};
handles.SelectedDisplayOptionIdx = get(hObject,'Value');
handles.maxDoseVal = 0;
handles.doseWindow = [];
handles = updateIsoDoseLineCache(handles);
handles.cBarChanged = true;
UpdatePlot(handles);
guidata(hObject, handles);

% --- Executes on slider movement.
function sliderBeamSelection_Callback(hObject, ~, handles)
% hObject    handle to sliderBeamSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


handles.SelectedBeam = round(get(hObject,'Value'));
set(hObject, 'Value', handles.SelectedBeam);
handles.rememberCurrAxes = false;
UpdatePlot(handles);
handles.rememberCurrAxes = true;
guidata(hObject,handles);

% --- Executes on button press in btnProfileType.
function btnProfileType_Callback(hObject, ~, handles)
% hObject    handle to btnProfileType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(hObject,'Enable') ,'on')
    if strcmp(handles.ProfileType,'lateral')
            handles.ProfileType = 'longitudinal';
             set(hObject,'String','lateral');
        else
            handles.ProfileType = 'lateral';
            set(hObject,'String','longitudinal');
    end
    
    handles.rememberCurrAxes = false;
    UpdatePlot(handles);
    handles.rememberCurrAxes = true;

    guidata(hObject, handles);
 
end

% displays the cst in the GUI
function setCstTable(handles,cst)

% create legend according to cst file
colors = colorcube;
colors = colors(round(linspace(1,63,size(cst,1))),:);

for s = 1:size(cst,1)
    handles.VOIPlotFlag(s) = cst{s,5}.Visible;
    clr = dec2hex(round(colors(s,:)*255),2)';
    clr = ['#';clr(:)]';
    if handles.VOIPlotFlag(s)
        tmpString{s} = ['<html><table border=0 ><TR><TD bgcolor=',clr,' width="18"><center>&#10004;</center></TD><TD>',cst{s,2},'</TD></TR> </table></html>'];
    else
        tmpString{s} = ['<html><table border=0 ><TR><TD bgcolor=',clr,' width="18"></TD><TD>',cst{s,2},'</TD></TR> </table></html>'];
    end
end
set(handles.legendTable,'String',tmpString);

%columnname = {'VOI name','VOI type','priority','obj. / const.','penalty','dose', 'EUD','volume','robustness'};

columnname = {'VOI name','VOI type','Dose(Gy)','priority','TMD levels'};

%AllObjectiveFunction = {'square underdosing','square overdosing','square deviation', 'mean', 'EUD',...
%                        'min dose constraint','max dose constraint',...
%                        'min mean dose constraint','max mean dose constraint',...
%                        'min EUD constraint','max EUD constraint',...
%                        'max DVH constraint','min DVH constraint',...
%                        'max DVH objective' ,'min DVH objective'};

columnformat = {cst(:,2)',{'OAR','TARGET'},'numeric','numeric','numeric'};

%columnformatT = { 'numeric','numeric','numeric','numeric'};
   
columneditable = [true true true true false];

%columneditableT = [true true true true];
   
numOfObjectives = 0;
for i = 1:size(cst,1)
    if ~isempty(cst{i,6})
        numOfObjectives = numOfObjectives + numel(cst{i,6});
    end
end

dimArr = [numOfObjectives size(columnname,2)];
data = cell(dimArr);
data(:,6) = {''};
Counter = 1;

%nLevel = 1;
%tmdlabel={};

 
for i = 1:size(cst,1)
   
   if strcmp(cst(i,3),'IGNORED')~=1
       for j=1:size(cst{i,6},1)
           %VOI
           data{Counter,1}  = cst{i,2};
           %VOI Type
           data{Counter,2}  = cst{i,3};
           %Dose Gy prescribed to structure
           data{Counter,3}  = cst{i,6}.dose;
           
           %Priority
           data{Counter,4}  = cst{i,5}.Priority;

           nLevel = 0;
           
           if isfield(cst{i,6}, 'TMDArray')          
               %Number of TMD Level
               nLevel = numel(cst{i,6}.TMDArray);
           end
                 
           data{Counter,5}  = nLevel;

           
           %Objective Function
           %objFunc          = cst{i,6}(j).type;
           %data{Counter,4}  = objFunc;
           % set Penalty
           %data{Counter,5}  = cst{i,6}(j).penalty;
           %data{Counter,6}  = cst{i,6}(j).dose;
           %data{Counter,7}  = cst{i,6}(j).EUD;
           %data{Counter,8}  = cst{i,6}(j).volume;
           %data{Counter,9}  = cst{i,6}(j).robustness;

           Counter = Counter +1;
       end
   end
end

% 
% columnname = addTMDColumnNameAsLevel(columnname,nLevel,tmdlabel);    
% columnformat = addTMDColumnFormatAsLevel(columnformat,nLevel,columnformatT); 
% 
% columneditable = addTMDColumnEditableAsLevel(columneditable,nLevel,columneditableT);
    
set(handles.uiTable,'ColumnName',columnname);
set(handles.uiTable,'ColumnFormat',columnformat);
set(handles.uiTable,'ColumnEditable',columneditable);
set(handles.uiTable,'Data',data);


function Flag = getCstTable (handles)

data = get(handles.uiTable,'Data');
OldCst = evalin('base','cst');
NewCst=[];
Cnt=1;
FlagValidParameters = true;

%% generate new cst from GUI
for i = 1:size(OldCst,1)
    CntObjF = 1;
    FlagFound = false;
    for j = 1:size(data,1)
        
        if strcmp(OldCst{i,2},data{j,1})
            FlagFound = true;
            
            if CntObjF == 1
                %VOI
                if isempty(data{j,1}) || ~isempty(strfind(data{j,1}, 'Select'))
                    FlagValidParameters=false;
                else
                    NewCst{Cnt,1}=data{j,1};  
                end
                %VOI Type
                if isempty(data{j,2})|| ~isempty(strfind(data{j,2}, 'Select'))
                    FlagValidParameters=false;
                else
                    NewCst{Cnt,2}=data{j,2};
                end
                %Dose(Gy) Desired
                if isempty(data{j,3})
                    FlagValidParameters=false;
                else
                    NewCst{Cnt,3}=data{j,3};
                end
                
                
                %Priority
                if isempty(data{j,4})
                    FlagValidParameters=false;
                else
                    NewCst{Cnt,4}=data{j,4};
                end
            end
            
            
            
            
            % Obj Func / constraint
           % if isempty(data{j,4}) ||~isempty(strfind(data{j,4}, 'Select'))
           %    FlagValidParameters=false;
           % else
           %      NewCst{Cnt,4}(CntObjF,1).type = data{j,4};
           % end
         
%            nLevel =  get(handles.popupmenuTMLevel,'Value' );
%           
     
            % get further parameter
%             if FlagValidParameters
%                 
%               NewCst{Cnt,4}(CntObjF,1).dose       = data{j,6};
%               NewCst{Cnt,4}(CntObjF,1).penalty    = data{j,5};
%               NewCst{Cnt,4}(CntObjF,1).EUD        = data{j,7};
%               NewCst{Cnt,4}(CntObjF,1).volume     = data{j,8};
%               NewCst{Cnt,4}(CntObjF,1).robustness = data{j,9};
%              
%             end
            
%            if FlagValidParameters
              %Only save the Truncated Mean Dose related values  
%              NewCst{Cnt,5}(CntObjF,1).TMLevel     = nLevel ;
%              NewCst{Cnt,5}(CntObjF,1).TMDLabel    = columnname(4:numel(columnname));
%              NewCst{Cnt,5}(CntObjF,1).TMDArray    = tmdarray(4:numel(tmdarray));         
%            end
            
            
            
            
            
            CntObjF = CntObjF+1; 
            
        end

    end
    
    if FlagFound == true
       Cnt = Cnt +1;
    end
            
end

if FlagValidParameters
    
       for m=1:size(OldCst,1)
           VOIexist   = OldCst(m,2);
           boolChanged = false;

           for n = 1:size(NewCst,1)

               VOIGUI = NewCst(n,1);

               if strcmp(VOIexist,VOIGUI)
                  % overite existing objectives
                   boolChanged = true;
          
                   OldCst(m,3) = NewCst(n,2);
                   OldCst{m,6}.dose = NewCst{n,3};
                   OldCst{m,5}.Priority = NewCst{n,4};
                   break;
               end 
           end

           if ~boolChanged
               OldCst{m,6}=[];
           end

       end
       assignin('base','cst',OldCst);
       Flag = true;
       
else       
  warndlg('not all values are set - cannot start dose calculation'); 
  Flag = false;
end


% --- Executes on button press in btnuiTableAdd.
function btnuiTableAdd_Callback(hObject, ~, handles)
% hObject    handle to btnuiTableAdd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = get(handles.uiTable, 'data');
sEnd = size(data,1);
data{sEnd+1,1} = 'Select VOI';
data{sEnd+1,2} = 'Select VOI Type';
data{sEnd+1,3} = 1;

%data{sEnd+1,4} = 'Select obj func/constraint';
%data{sEnd+1,9} = 'none';

set(handles.uiTable,'data',data);

%handles.State=1;
guidata(hObject,handles);
UpdateState(handles);


% --- Executes on button press in btnuiTableDel.
function btnuiTableDel_Callback(hObject, eventdata, handles)
% hObject    handle to btnuiTableDel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = get(handles.uiTable, 'data');
Index = get(handles.uiTable,'UserData');
mask = (1:size(data,1))';
mask(Index(:,1))=[];
cst = evalin('base','cst');
% if all rows have been deleted or a target voi was removed
if size(data,1)==1 || strcmp(data(Index(1),2),'TARGET')
    handles.State=1;
end

try
    Idx = find(strcmp(cst(:,2),data(Index(1),1)));
    % if OAR was removed then show a warning 
    if strcmp(data(Index(1),2),'OAR') && length(cst{Idx,6})<=1
      handles.DijCalcWarning =true;
    end
catch 
end
data=data(mask,:);
set(handles.uiTable,'data',data);
guidata(hObject,handles);
UpdateState(handles);
btnTableSave_Callback(hObject, eventdata, handles);

% --- Executes when selected cell(s) is changed in uiTable.
function uiTable_CellSelectionCallback(hObject, eventdata, ~)
% hObject    handle to uiTable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
index = eventdata.Indices;
    if any(index)             %loop necessary to surpress unimportant errors.
        set(hObject,'UserData',index);      
    end
    

% --- Executes when entered data in editable cell(s) in uiTable.
function uiTable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uiTable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)

Placeholder = NaN;
PlaceholderRob  = 'none';

% get table data and current index of cell
if isempty(eventdata)
    data = get(handles.uiTable,'Data');
    Index = get(handles.uiTable,'UserData');

    if ~isempty(Index) && size(Index,1)==1
        % if this callback was invoked by calculate dij button, eventdata is empty
        % and needs to be set manually
        try 
            % if row gots deleted then index is pointing to non existing
            % data
            if size(data,1)<Index(1,1)
                Index(1,1)=1;
                Index(1,2)=1;
            end
            eventdata.Indices(1) = Index(:,1);
            eventdata.Indices(2) = Index(:,2);
            eventdata.PreviousData = 1;
            eventdata.NewData = data{Index(1),Index(2)};
        catch
        end
    else
        return
    end
else
    data = get(hObject,'Data'); 
end


%% if VOI, VOI Type or Overlap was changed
if ~strcmp(eventdata.NewData,eventdata.PreviousData)
    if eventdata.Indices(2) == 1 || eventdata.Indices(2) == 2 ...
            || eventdata.Indices(2) == 3
        
        handles.TableChanged = true;
          %% if a new target is defined set state to one
         if eventdata.Indices(2) == 2 && strcmp('TARGET',eventdata.NewData)
              handles.State=1;
         end
        
        %% if overlap priority of target changed
         if eventdata.Indices(2) == 3 && strcmp('TARGET',data(eventdata.Indices(1),2))
              handles.State=1;
         end
         
        %% if overlap priority of OAR changed
         if eventdata.Indices(2) == 3 && strcmp('OAR',data(eventdata.Indices(1),2))
              handles.DijCalcWarning = true;
         end
         
         %% check if new OAR was added
         cst = evalin('base','cst');
         Idx = ~cellfun('isempty',cst(:,6));
         
         if sum(strcmp(cst(Idx,2),eventdata.NewData))==0 
             handles.DijCalcWarning = true;
         end
        
        
    else
        % if table changed after a optimization was performed
        if handles.State ==3 && handles.TableChanged == false
            handles.State=2;
        end
    end
end
%% if VOI Type was changed -> check if objective function still makes sense
if eventdata.Indices(2) == 2
   
    if strcmp(eventdata.NewData,'OAR')
        
        if sum(strcmp({'square deviation','square underdosing'},data{eventdata.Indices(1),4}))>0
            data{eventdata.Indices(1),4} = 'square overdosing';
        end
        
    else
        
        if sum(strcmp({'EUD','mean'},data{eventdata.Indices(1),4}))>0
            data{eventdata.Indices(1),4} = 'square deviation';
        end
        
    end
end
%% if objective function was changed -> check if VOI Type still makes sense
if eventdata.Indices(2) == 4
    ObjFunction = eventdata.NewData;
else
    ObjFunction = data{eventdata.Indices(1),4};
end


if eventdata.Indices(2) == 4
    if  sum(strcmp(eventdata.NewData,{'square deviation','square underdosing','min dose constraint',...
                                      'min mean dose constraint','min DVH constraint','min DVH objective'})) > 0 
    
        if strcmp('OAR',data{eventdata.Indices(1),2})
            data{eventdata.Indices(1),4} = 'square overdosing';
            ObjFunction                  = 'square overdosing';
            if isnan(data{eventdata.Indices(1),5})
                data{eventdata.Indices(1),5} = 1;
            end
        end
        
        tmpDose = parseStringAsNum(data{eventdata.Indices(1),6},true);
        if numel(tmpDose) == 2
            data{eventdata.Indices(1),6} = num2str(tmpDose(1));
        end
    
    elseif strcmp(eventdata.NewData,'mean')
        
        if strcmp('TARGET',data{eventdata.Indices(1),2})
            data{eventdata.Indices(1),4} = 'square deviation';
        end
        
    end
end

%% set fields to NaN according to objective function

if sum(strcmp(ObjFunction, {'square underdosing','square overdosing','square deviation'})) > 0
    
    for k = [5 6]
        if isnan(data{eventdata.Indices(1),k})
             data{eventdata.Indices(1),k} = 1;
        end
    end 
    data{eventdata.Indices(1),7} = Placeholder;
    data{eventdata.Indices(1),8} = Placeholder;
    data{eventdata.Indices(1),9} = PlaceholderRob;
   
elseif strcmp(ObjFunction,'mean')
    
        if isnan(data{eventdata.Indices(1),5})
                 data{eventdata.Indices(1),5} = 1;
        end
        data{eventdata.Indices(1),6} = Placeholder;    
        data{eventdata.Indices(1),7} = Placeholder;   
        data{eventdata.Indices(1),8} = Placeholder;
        data{eventdata.Indices(1),9} = PlaceholderRob;

elseif strcmp(ObjFunction,'EUD')
    
        for k = [5 7]
            if isnan(data{eventdata.Indices(1),k})
                 data{eventdata.Indices(1),k} = 1;
            end
        end 
       data{eventdata.Indices(1),6} = Placeholder; 
       data{eventdata.Indices(1),8} = Placeholder;
       data{eventdata.Indices(1),9} = PlaceholderRob;
       
elseif sum(strcmp(ObjFunction,{'min dose constraint','max dose constraint'...
                               'min mean dose constraint','max mean dose constraint'}))> 0
         
         if isnan(data{eventdata.Indices(1),6})
                 data{eventdata.Indices(1),6} = 1;
         end
         data{eventdata.Indices(1),5} = Placeholder;
         data{eventdata.Indices(1),7} = Placeholder;
         data{eventdata.Indices(1),8} = Placeholder;
         data{eventdata.Indices(1),9} = PlaceholderRob;
         
elseif sum(strcmp(ObjFunction,{'min EUD constraint','max EUD constraint'}) ) > 0
        
        if isnan(data{eventdata.Indices(1),7})
             data{eventdata.Indices(1),7} = 1;
        end
        data{eventdata.Indices(1),5} = Placeholder;
        data{eventdata.Indices(1),6} = Placeholder;
        data{eventdata.Indices(1),8} = Placeholder;
        data{eventdata.Indices(1),9} = PlaceholderRob;
        
elseif sum(strcmp(ObjFunction,{'min DVH constraint','max DVH constraint'}) ) > 0
        
        for k = [6 8]
            if isnan(data{eventdata.Indices(1),k})
                 data{eventdata.Indices(1),k} = 1;
            end
        end    
        data{eventdata.Indices(1),5} = Placeholder;
        data{eventdata.Indices(1),7} = Placeholder;
        data{eventdata.Indices(1),9} = PlaceholderRob;

elseif sum(strcmp(ObjFunction,{'min DVH objective','max DVH objective'}) ) > 0
        
    for k = [5 6 8]
        if isnan(data{eventdata.Indices(1),k})
             data{eventdata.Indices(1),k} = 1;
        end
    end
    data{eventdata.Indices(1),7} = Placeholder;
    data{eventdata.Indices(1),9} = PlaceholderRob;
    
end
    
%% check if input is a valid
%check if overlap, penalty and and parameters are numbers
if (eventdata.Indices(2) == 3  || eventdata.Indices(2) == 5 || eventdata.Indices(2) == 6 || eventdata.Indices(2) == 7 || eventdata.Indices(2) == 8) ...
        && ~isempty(eventdata.NewData)
    if CheckValidity(eventdata.NewData) == false
            data{eventdata.Indices(1),eventdata.Indices(2)} = eventdata.PreviousData;
    end
end


%% if VOI was changed then change VOI type and overlap according to new VOI
if eventdata.Indices(2) == 1 && eventdata.Indices(1) == size(data,1)
    for i = 1:size(data,1)
        if strcmp(eventdata.NewData,data{i,1})
           data{eventdata.Indices(1),2}=data{i,2};
           data{eventdata.Indices(1),3}=data{i,3};
        end
    end
    
end

%% set VOI type and priority according to existing definitions
for i=1:size(data,1)
    if i~=eventdata.Indices(1) && strcmp(data(i,1),data(eventdata.Indices(1)))
        data{i,2} = data{eventdata.Indices(1),2};
        data{i,3} = data{eventdata.Indices(1),3};
    end
end


if isnan(eventdata.NewData)
    data{eventdata.Indices(1),eventdata.Indices(2)} = eventdata.PreviousData;
end


set(handles.txtInfo,'String','plan changed');
set(handles.uiTable,'data',data);
guidata(hObject, handles);
UpdateState(handles);

% enables/ disables buttons according to the current state      
function UpdateState(handles)

if handles.State > 0
    pln = evalin('base','pln');

    if strcmp(pln.radiationMode,'carbon')
        set(handles.radbtnBioOpt,'Enable','on');
        set(handles.btnTypBioOpt,'Enable','on');
        set(handles.btnSetTissue,'Enable','on');
    else
        set(handles.radbtnBioOpt,'Enable','off');
        set(handles.btnTypBioOpt,'Enable','off');
        set(handles.btnSetTissue,'Enable','off');
    end
    
    cMapControls = allchild(handles.uipanel_colormapOptions);
    for runHandles = cMapControls
        set(runHandles,'Enable','on');
    end
end 

cMapOptionsSelectList = {'None','CT (ED)','Result (i.e. dose)'};
handles.cBarChanged = true;

 switch handles.State
     
     case 0
      
      set(handles.txtInfo,'String','no data loaded');
      set(handles.btnCalcDose,'Enable','off');
      set(handles.btnIntuitiveOptimize ,'Enable','off');
      set(handles.pushbutton_recalc,'Enable','off');
      set(handles.btnSaveToGUI,'Enable','off');
      set(handles.btnDVH,'Enable','off'); 
      set(handles.importDoseButton,'Enable','off');
      set(handles.btn_export,'Enable','off');
      
      cMapControls = allchild(handles.uipanel_colormapOptions);
      for runHandles = cMapControls
          set(runHandles,'Enable','off');
      end
      
      set(handles.popupmenu_chooseColorData,'String',cMapOptionsSelectList{1})
      set(handles.popupmenu_chooseColorData,'Value',1);
      
     case 1
     
      set(handles.txtInfo,'String','ready for dose calculation');
      set(handles.btnCalcDose,'Enable','on');
      set(handles.btnIntuitiveOptimize ,'Enable','off');
      set(handles.pushbutton_recalc,'Enable','off');
      set(handles.btnSaveToGUI,'Enable','off');
      set(handles.btnDVH,'Enable','off');
      set(handles.importDoseButton,'Enable','off');
      set(handles.btn_export,'Enable','on');
      
      AllVarNames = evalin('base','who');
      if ~isempty(AllVarNames)
            if  sum(ismember(AllVarNames,'resultGUI')) > 0
              set(handles.pushbutton_recalc,'Enable','on');
              set(handles.btnSaveToGUI,'Enable','on');
              set(handles.btnDVH,'Enable','on');
            end
      end
      
      set(handles.popupmenu_chooseColorData,'String',cMapOptionsSelectList(1:2))
      set(handles.popupmenu_chooseColorData,'Value',2);
     
     case 2
    
      set(handles.txtInfo,'String','ready for optimization');   
      set(handles.btnCalcDose,'Enable','on');
      set(handles.btnIntuitiveOptimize ,'Enable','on');
      set(handles.pushbutton_recalc,'Enable','off');
      set(handles.btnSaveToGUI,'Enable','off');
      set(handles.btnDVH,'Enable','off');
      set(handles.importDoseButton,'Enable','off');
      set(handles.btn_export,'Enable','on');
      AllVarNames = evalin('base','who');
      if ~isempty(AllVarNames)
            if  sum(ismember(AllVarNames,'resultGUI')) > 0
              set(handles.pushbutton_recalc,'Enable','on');
              set(handles.btnSaveToGUI,'Enable','on');
              set(handles.btnDVH,'Enable','on');
            end
      end
      set(handles.popupmenu_chooseColorData,'String',cMapOptionsSelectList(1:2))
      set(handles.popupmenu_chooseColorData,'Value',2);
      
     case 3
      set(handles.txtInfo,'String','plan is optimized');   
      set(handles.btnCalcDose,'Enable','on');
      set(handles.btnIntuitiveOptimize ,'Enable','on');
      set(handles.pushbutton_recalc,'Enable','on');
      set(handles.btnSaveToGUI,'Enable','on');
      set(handles.btnDVH,'Enable','on');
      set(handles.btn_export,'Enable','on');
      % resultGUI struct needs to be available to import dose
      % otherwise inconsistent states can be achieved
      set(handles.importDoseButton,'Enable','on');
      set(handles.popupmenu_chooseColorData,'String',cMapOptionsSelectList(1:3))
      set(handles.popupmenu_chooseColorData,'Value',3);
 end

guidata(handles.figure1,handles); 
 
% fill GUI elements with plan information
function setPln(handles)
pln = evalin('base','pln');
set(handles.editBixelWidth,'String',num2str(pln.bixelWidth));
set(handles.editFraction,'String',num2str(pln.numOfFractions));

if isfield(pln,'isoCenter')
    set(handles.editIsoCenter,'String',regexprep(num2str((round(pln.isoCenter*10))./10), '\s+', ' '));
end
set(handles.editGantryAngle,'String',num2str((pln.gantryAngles)));
set(handles.editCouchAngle,'String',num2str((pln.couchAngles)));
set(handles.popupRadMode,'Value',find(strcmp(get(handles.popupRadMode,'String'),pln.radiationMode)));
set(handles.popUpMachine,'Value',find(strcmp(get(handles.popUpMachine,'String'),pln.machine)));

if strcmp(pln.bioOptimization,'effect') || strcmp(pln.bioOptimization,'RBExD') ... 
                            && strcmp(pln.radiationMode,'carbon')  
    set(handles.radbtnBioOpt,'Value',1);
    set(handles.radbtnBioOpt,'Enable','on');
    set(handles.btnTypBioOpt,'Enable','on');
    set(handles.btnTypBioOpt,'String',pln.bioOptimization);
    set(handles.btnSetTissue,'Enable','on');
else
    set(handles.radbtnBioOpt,'Value',0);
    set(handles.radbtnBioOpt,'Enable','off');
    set(handles.btnTypBioOpt,'Enable','off');
    set(handles.btnSetTissue,'Enable','off');
end
%% enable sequencing and DAO button if radiation mode is set to photons
if strcmp(pln.radiationMode,'photons') && pln.runSequencing
    set(handles.btnRunSequencing,'Enable','on');
    set(handles.btnRunSequencing,'Value',1);
elseif strcmp(pln.radiationMode,'photons') && ~pln.runSequencing
    set(handles.btnRunSequencing,'Enable','on');
    set(handles.btnRunSequencing,'Value',0);
else
    set(handles.btnRunSequencing,'Enable','off');
end
%% enable DAO button if radiation mode is set to photons
if strcmp(pln.radiationMode,'photons') && pln.runDAO
    set(handles.btnRunDAO,'Enable','on');
    set(handles.btnRunDAO,'Value',1);
elseif strcmp(pln.radiationMode,'photons') && ~pln.runDAO
    set(handles.btnRunDAO,'Enable','on');
    set(handles.btnRunDAO,'Value',0);
else
    set(handles.btnRunDAO,'Enable','off');
end
%% enable stratification level input if radiation mode is set to photons
if strcmp(pln.radiationMode,'photons')
    set(handles.txtSequencing,'Enable','on');
    set(handles.editSequencingLevel,'Enable','on');
else
    set(handles.txtSequencing,'Enable','off');
    set(handles.editSequencingLevel,'Enable','off');
end

% --- Executes on button press in btnTableSave.
function btnTableSave_Callback(~, ~, handles)
% hObject    handle to btnTableSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
getCstTable(handles);
if get(handles.checkIsoCenter,'Value')
    pln = evalin('base','pln'); 
    pln.isoCenter = matRad_getIsoCenter(evalin('base','cst'),evalin('base','ct')); 
    set(handles.editIsoCenter,'String',regexprep(num2str((round(pln.isoCenter*10))./10), '\s+', ' '));
    assignin('base','pln',pln);
end
getPlnFromGUI(handles);

% --- Executes on selection change in listBoxCmd.
function listBoxCmd_Callback(hObject, ~, ~)
numLines = size(get(hObject,'String'),1);
set(hObject, 'ListboxTop', numLines);

% --- Executes on slider movement.
function sliderOffset_Callback(hObject, ~, handles)
handles.profileOffset = get(hObject,'Value');
UpdatePlot(handles);

 
%% HELPER FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% check validity of input for cst
function flagValidity = CheckValidity(Val) 
      
flagValidity = true;

if ischar(Val)
    Val = str2num(Val);
end 

if length(Val) > 2
    warndlg('invalid input!');
end

if isempty(Val)
   warndlg('Input not a number!');
   flagValidity = false;        
end

if any(Val < 0) 
   warndlg('Input not a positive number!');
   flagValidity = false;  
end

% return IPOPT status as message box
function CheckIpoptStatus(info,OptCase) 
      
if info.status == 0
    statusmsg = 'solved';  
elseif info.status == 1
    statusmsg = 'solved to acceptable level';          
elseif info.status == 2
    statusmsg = 'infeasible problem detected';           
elseif info.status == 3    
    statusmsg = 'search direction too small';             
elseif info.status == 4 
    statusmsg = 'diverging iterates';     
elseif info.status == 5
    statusmsg = 'user requested stop';     
elseif info.status == -1        
    statusmsg = 'maximum number of iterations';     
elseif info.status == -2    
    statusmsg = 'restoration phase failed';     
elseif info.status == -3         
    statusmsg = 'error in step computation';     
elseif info.status == -4
    statusmsg = 'maximum CPU time exceeded';     
elseif info.status == -10        
    statusmsg = 'not enough degrees of freedom';     
elseif info.status == -11    
    statusmsg = 'invalid problem definition';     
elseif info.status == -12   
    statusmsg = 'invalid option';     
elseif info.status == -13        
    statusmsg = 'invalid number detected';     
elseif info.status == -100
    statusmsg = 'unrecoverable exception';     
elseif info.status == -101        
    statusmsg = 'non-IPOPT exception thrown';     
elseif info.status == -102    
    statusmsg = 'insufficient memory';     
elseif info.status == -199
    statusmsg = 'IPOPT internal error';     
else
    statusmsg = 'IPOPT returned no status';
end
    
if info.status == 0 || info.status == 1
    status = 'none';
else
    status = 'warn';
end

msgbox(['IPOPT finished with status ' num2str(info.status) ' (' statusmsg ')'],'IPOPT',status,'modal');

% get pln file form GUI     
function getPlnFromGUI(handles)

pln.bixelWidth      = parseStringAsNum(get(handles.editBixelWidth,'String'),false); % [mm] / also corresponds to lateral spot spacing for particles
pln.gantryAngles    = parseStringAsNum(get(handles.editGantryAngle,'String'),true); % [???]
pln.couchAngles     = parseStringAsNum(get(handles.editCouchAngle,'String'),true); % [???]
pln.numOfBeams      = numel(pln.gantryAngles);
try
    ct = evalin('base','ct');
    pln.numOfVoxels     = prod(ct.cubeDim);
    pln.voxelDimensions = ct.cubeDim;
catch
end
pln.numOfFractions  = parseStringAsNum(get(handles.editFraction,'String'),false);
contents            = get(handles.popupRadMode,'String'); 
pln.radiationMode   = contents{get(handles.popupRadMode,'Value')}; % either photons / protons / carbon
contents            = get(handles.popUpMachine,'String'); 
pln.machine         = contents{get(handles.popUpMachine,'Value')}; 

if (logical(get(handles.radbtnBioOpt,'Value')) && strcmp(pln.radiationMode,'carbon'))
    pln.bioOptimization = get(handles.btnTypBioOpt,'String');
else
    pln.bioOptimization = 'none';
end

pln.runSequencing = logical(get(handles.btnRunSequencing,'Value'));
pln.runDAO = logical(get(handles.btnRunDAO,'Value'));

try
    cst = evalin('base','cst');
    if sum(strcmp('TARGET',cst(:,3))) > 0 && get(handles.checkIsoCenter,'Value')
       pln.isoCenter = matRad_getIsoCenter(cst,ct); 
    else
       pln.isoCenter = str2num(get(handles.editIsoCenter,'String'));
    end
catch
    warning('couldnt set isocenter in getPln function')
end

handles.pln = pln;
assignin('base','pln',pln);

% parsing a string as number array
function number = parseStringAsNum(stringIn,isVector)
if isnumeric(stringIn)
    number = stringIn;
else
    number = str2num(stringIn);
    if isempty(number) || length(number) > 1 && ~isVector
        warndlg(['could not parse all parameters (pln, optimization parameter)']); 
        number = NaN;
    elseif isVector && iscolumn(number)
        number = number';
    end
end


% show error
function handles = showError(handles,Message)

if isfield(handles,'ErrorDlg')
    if ishandle(handles.ErrorDlg)
        close(handles.ErrorDlg);
    end
end
handles.ErrorDlg = errordlg(Message);

% show warning
function handles = showWarning(handles,Message)

if isfield(handles,'WarnDlg')
    if ishandle(handles.WarnDlg)
        close(handles.WarnDlg);
    end
end
handles.WarnDlg = warndlg(Message);

% check for valid machine data input file
function flag = checkRadiationComposition(handles)
flag = true;
contents = cellstr(get(handles.popUpMachine,'String'));
Machine = contents{get(handles.popUpMachine,'Value')};
contents = cellstr(get(handles.popupRadMode,'String'));
radMod = contents{get(handles.popupRadMode,'Value')};

if isdeployed
    FoundFile = dir([ctfroot filesep 'matRad' filesep radMod '_' Machine '.mat']);
else
    FoundFile = dir([fileparts(mfilename('fullpath')) filesep radMod '_' Machine '.mat']);    
end
if isempty(FoundFile)
    warndlg(['No base data available for machine: ' Machine]);
    flag = false;
end

function matRadScrollWheelFcn(src,event)

% get handles
handles = guidata(src);

% compute new slice
currSlice = round(get(handles.sliderSlice,'Value'));
newSlice  = currSlice - event.VerticalScrollCount;

% project to allowed set
newSlice = min(newSlice,get(handles.sliderSlice,'Max'));
newSlice = max(newSlice,get(handles.sliderSlice,'Min'));

% update slider
set(handles.sliderSlice,'Value',newSlice);

% update handles object
guidata(src,handles);

% update plot
UpdatePlot(handles);




%% CALLBACKS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% button: show DVH
function btnDVH_Callback(~, ~, handles)

resultGUI = evalin('base','resultGUI');
Content = get(handles.popupDisplayOption,'String');
SelectedCube = Content{get(handles.popupDisplayOption,'Value')};

pln = evalin('base','pln');
resultGUI_SelectedCube.physicalDose = resultGUI.(SelectedCube);

if ~strcmp(pln.bioOptimization,'none') && strcmp(pln.radiationMode,'carbon') == 1 

    %check if one of the default fields is selected
    if sum(strcmp(SelectedCube,{'physicalDose','effect','RBE,','RBExDose','alpha','beta'})) > 0
        resultGUI_SelectedCube.physicalDose = resultGUI.physicalDose;
        resultGUI_SelectedCube.RBExDose     = resultGUI.RBExDose;
    else
        Idx    = find(SelectedCube == '_');
        SelectedSuffix = SelectedCube(Idx:end);
        resultGUI_SelectedCube.physicalDose = resultGUI.(['physicalDose' SelectedSuffix]);
        resultGUI_SelectedCube.RBExDose     = resultGUI.(['RBExDose' SelectedSuffix]);
    end
end

%adapt visibilty
cst = evalin('base','cst');
for i = 1:size(cst,1)
    cst{i,5}.Visible = handles.VOIPlotFlag(i);
end

matRad_calcDVH(resultGUI_SelectedCube,cst,evalin('base','pln'));
%matRad_IntuitiveOpt_calcDVH(resultGUI_SelectedCube,cst,evalin('base','pln'));

% radio button: plot isolines labels
function radiobtnIsoDoseLinesLabels_Callback(~, ~, handles)
UpdatePlot(handles);

% button: refresh
function btnRefresh_Callback(hObject, ~, handles)

% parse variables from base workspace
AllVarNames = evalin('base','who');
handles.State = 0;

if ~isempty(AllVarNames)
    try
        if  sum(ismember(AllVarNames,'ct')) > 0
            % do nothing
        else
            handles = showError(handles,'BtnRefreshCallback: ct struct is missing');
        end

        if  sum(ismember(AllVarNames,'cst')) > 0
            setCstTable(handles,evalin('base','cst'));
        else
            handles = showError(handles,'BtnRefreshCallback: cst struct is missing');
        end

        if sum(ismember(AllVarNames,'pln')) > 0
            setPln(handles);
        else
            getPlnFromGUI(handles);
        end
        
        handles.State = 1;

    catch
        handles = showError(handles,'BtnRefreshCallback: Could not load ct/cst/pln');
        guidata(hObject,handles);
        return;
    end

    % check if a optimized plan was loaded
    if sum(ismember(AllVarNames,'stf')) > 0  && sum(ismember(AllVarNames,'dij')) > 0
        handles.State = 2;
    end

    if sum(ismember(AllVarNames,'resultGUI')) > 0
        handles.State = 3;
        handles.SelectedDisplayOptionIdx = 1;
        handles.SelectedDisplayOption = 'physicalDose';
        handles.SelectedBeam = 1;
    end

    if handles.State > 0
        ct = evalin('base','ct');
        set(handles.sliderSlice,'Min',1,'Max',ct.cubeDim(handles.plane),...
                'Value',ceil(ct.cubeDim(handles.plane)/2),...
                'SliderStep',[1/(ct.cubeDim(handles.plane)-1) 1/(ct.cubeDim(handles.plane)-1)]);      
    end

end

%% delete context menu if workspace was deleted manually and refresh button was clicked
if handles.State == 0
   % objHandle = guidata(findobj('Name','matRad_IntuitiveOptGUI'));  
    objHandle = guidata(findobj('Name','matRad_IntuitiveOptGUI'));  
    contextUi = (get(objHandle.figure1,'UIContextMenu'));
    delete(contextUi)
end

handles.cBarChanged;

guidata(hObject,handles);
UpdateState(handles);
UpdatePlot(handles);




% button: toggle effect based optimization and RBExD optimization
function btnTypBioOpt_Callback(hObject, ~, handles)
if strcmp(get(hObject,'String'),'effect')
    set(hObject,'String','RBExD');
else
    set(hObject,'String','effect');
end
getPlnFromGUI(handles);

% text box: # fractions
function editFraction_Callback(hObject, ~, handles)
getPlnF romGUI(handles);
guidata(hObject,handles);

% text box: stratification levels
function editSequencingLevel_Callback(~, ~, ~)

% text box: isoCenter in [mm]
function editIsoCenter_Callback(hObject, ~, handles)

pln = evalin('base','pln');
tmpIsoCenter = str2num(get(hObject,'String'));

if length(tmpIsoCenter) == 3
    if any(pln.isoCenter~=tmpIsoCenter)
        pln.isoCenter = tmpIsoCenter;
        handles.State = 1;
        UpdateState(handles);
    end
else
    handles = showError(handles,'EditIsoCenterCallback: Could not set iso center');
end

assignin('base','pln',pln);
guidata(hObject,handles);

% check box: iso center auto
function checkIsoCenter_Callback(hObject, ~, handles)

if get(hObject,'Value')
    pln = evalin('base','pln');
    if ~isfield(pln,'isoCenter')
        pln.isoCenter = NaN;
    end
    tmpIsoCenter = matRad_getIsoCenter(evalin('base','cst'),evalin('base','ct'));
    if ~isequal(tmpIsoCenter,pln.isoCenter)
        pln.isoCenter = tmpIsoCenter;
        handles.State = 1;
        UpdateState(handles);
    end
    set(handles.editIsoCenter,'String',regexprep(num2str((round(pln.isoCenter*10))./10), '\s+', ' '));
    set(handles.editIsoCenter,'Enable','off')
    assignin('base','pln',pln);
else
    set(handles.editIsoCenter,'Enable','on')
end

% radio button: run sequencing
function btnRunSequencing_Callback(~, ~, handles)
getPlnFromGUI(handles);

% radio button: run direct aperture optimization
function btnRunDAO_Callback(~, ~, handles)
getPlnFromGUI(handles);

% button: set iso dose levels
function btnSetIsoDoseLevels_Callback(hObject, ~, handles)
prompt = {['Enter iso dose levels in [Gy]. Enter space-separated numbers, e.g. 1.5 2 3 4.98. Enter 0 to use default values']};
def = {'1 2 3 4 5 10 20'};
if numel(handles.IsoDose.Levels) > 0
    def = {num2str(handles.IsoDose.Levels)};
end

try
Input = inputdlg(prompt,'Set iso dose levels ', [1 50],def);
if ~isempty(Input)
     handles.IsoDose.Levels = (sort(str2num(Input{1}))); 
     handles.IsoDose.NewIsoDoseFlag = true;
     if length(handles.IsoDose.Levels) == 1 && handles.IsoDose.Levels(1) == 0     
            handles = getIsoDoseLevels(handles);
     end
end
catch
    warning('Couldnt parse iso dose levels - using default values');
    handles.IsoDose.Levels = 0;
end
%take effect the iso lines
handles = updateIsoDoseLineCache(handles);
UpdatePlot(handles);
guidata(hObject,handles);

% text box: max value
function txtMaxDoseVal_Callback(hObject, ~, handles)

handles.maxDoseVal =  str2double(get(hObject,'String'));
% compute new iso dose lines
handles = updateIsoDoseLineCache(handles);
handles.doseWindow = [0 handles.maxDoseVal];
handles.cBarChanged = true;
guidata(hObject,handles);
UpdatePlot(handles);

% popup menu: machine
function popUpMachine_Callback(hObject, ~, handles)
contents = cellstr(get(hObject,'String'));
checkRadiationComposition(handles);
if handles.State > 0
    pln = evalin('base','pln');
    if handles.State > 0 && ~strcmp(contents(get(hObject,'Value')),pln.machine)
        handles.State = 1;
        UpdateState(handles);
        guidata(hObject,handles);
    end
   getPlnFromGUI(handles);
end

% toolbar load button
function toolbarLoad_ClickedCallback(hObject, eventdata, handles)
btnLoadMat_Callback(hObject, eventdata, handles);

% toolbar save button
function toolbarSave_ClickedCallback(hObject, eventdata, handles)

btnTableSave_Callback(hObject, eventdata, handles);

try

    if handles.State > 0
        ct  = evalin('base','ct');
        cst = evalin('base','cst');
        pln = evalin('base','pln');
    end

    if handles.State > 1
       stf = evalin('base','stf');
       dij = evalin('base','dij');
    end

    if handles.State > 2
       resultGUI = evalin('base','resultGUI');
    end

    switch handles.State
        case 1
            uisave({'cst','ct','pln'});
        case 2
            uisave({'cst','ct','pln','stf','dij'});
        case 3
            uisave({'cst','ct','pln','stf','dij','resultGUI'});
    end

catch
     handles = showWarning(handles,'Could not save files'); 
end
guidata(hObject,handles); 

% button: about
function btnAbout_Callback(hObject, eventdata, handles)

msgbox({'https://github.com/e0404/matRad/' 'email: matrad@dkfz.de'},'About');

% button: close
function figure1_CloseRequestFcn(hObject, ~, ~)
set(0,'DefaultUicontrolBackgroundColor',[0.5 0.5 0.5]);     
selection = questdlg('Do you really want to close matRad?',...
                     'Close matRad',...
                     'Yes','No','Yes');

%BackgroundColor',[0.5 0.5 0.5]
 switch selection
   case 'Yes',
     delete(hObject);
   case 'No'
     return
 end

% --- Executes on button press in pushbutton_recalc.
function pushbutton_recalc_Callback(hObject, ~, handles)

% recalculation only makes sense if ...
if evalin('base','exist(''pln'',''var'')') && ...
   evalin('base','exist(''stf'',''var'')') && ...
   evalin('base','exist(''ct'',''var'')') && ...
   evalin('base','exist(''cst'',''var'')') && ...
   evalin('base','exist(''resultGUI'',''var'')')

    % indicate that matRad is busy
    % change mouse pointer to hour glass 
    Figures = gcf;%findobj('type','figure');
    set(Figures, 'pointer', 'watch'); 
    drawnow;
    % disable all active objects
    InterfaceObj = findobj(Figures,'Enable','on');
    set(InterfaceObj,'Enable','off');
    
    % get all data from workspace
    pln       = evalin('base','pln');
    stf       = evalin('base','stf');
    ct        = evalin('base','ct');
    cst       = evalin('base','cst');
    resultGUI = evalin('base','resultGUI');
    
    % get weights of the selected cube
    Content = get(handles.popupDisplayOption,'String');
    SelectedCube = Content{get(handles.popupDisplayOption,'Value')};
    Suffix = strsplit(SelectedCube,'_');
    if length(Suffix)>1
        Suffix = ['_' Suffix{2}];
    else
        Suffix = '';
    end
    
    if sum([stf.totalNumOfBixels]) ~= length(resultGUI.(['w' Suffix]))
        warndlg('weight vector does not corresponding to current steering file');
        return
    end
    
    % change isocenter if that was changed and do _not_ recreate steering
    % information
    for i = 1:numel(pln.gantryAngles)
        stf(i).isoCenter = pln.isoCenter;
    end

    % recalculate influence matrix
    if strcmp(pln.radiationMode,'photons')
        if get(handles.vmcFlag,'Value') == 0
            dij = matRad_calcPhotonDose(ct,stf,pln,cst);
        elseif get(handles.vmcFlag,'Value') == 1
            dij = matRad_calcPhotonDoseVmc(evalin('base','ct'),stf,pln,evalin('base','cst'));
        end
    elseif strcmp(pln.radiationMode,'protons') || strcmp(pln.radiationMode,'carbon')
        dij = matRad_calcParticleDose(ct,stf,pln,cst);
    end

    % recalculate cubes in resultGUI
    resultGUIreCalc = matRad_calcCubes(resultGUI.(['w' Suffix]),dij,cst);
    
    % delete old variables to avoid confusion
    if isfield(resultGUI,'effect')
        resultGUI = rmfield(resultGUI,'effect');
        resultGUI = rmfield(resultGUI,'RBExDose'); 
        resultGUI = rmfield(resultGUI,'RBE'); 
        resultGUI = rmfield(resultGUI,'alpha'); 
        resultGUI = rmfield(resultGUI,'beta');
    end
    
    % overwrite the "standard" fields
    sNames = fieldnames(resultGUIreCalc);
    for j = 1:length(sNames)
        resultGUI.(sNames{j}) = resultGUIreCalc.(sNames{j});
    end
    
    % assign results to base worksapce
    assignin('base','dij',dij);
    assignin('base','resultGUI',resultGUI);
    
    handles.State = 3;
    
    % show physicalDose of newly computed state
    handles.SelectedDisplayOption = 'physicalDose';
    set(handles.popupDisplayOption,'Value',find(strcmp('physicalDose',Content)));
    
    % change state from busy to normal
    set(Figures, 'pointer', 'arrow');
    set(InterfaceObj,'Enable','on');
    
    handles.cBarChanged = true;
    
    UpdateState(handles);
    
    handles.rememberCurrAxes = false;
    UpdatePlot(handles);
    handles.rememberCurrAxes = true;   

    guidata(hObject,handles);
    
end


% --- Executes on button press in btnSetTissue.
function btnSetTissue_Callback(hObject, ~, handles)

%check if patient is loaded
if handles.State == 0
    return
end

%parse variables from base-workspace
cst = evalin('base','cst');
pln = evalin('base','pln');

fileName = [pln.radiationMode '_' pln.machine];
load(fileName);

% check for available cell types characterized by alphaX and betaX 
for i = 1:size(machine.data(1).alphaX,2)
    CellType{i} = [num2str(machine.data(1).alphaX(i)) ' ' num2str(machine.data(1).betaX(i))];
end

%fill table data array
for i = 1:size(cst,1)
    data{i,1} = cst{i,2};
    data{i,2} = [num2str(cst{i,5}.alphaX) ' ' num2str(cst{i,5}.betaX)];
    data{i,3} = (cst{i,5}.alphaX / cst{i,5}.betaX );
end

Width  = 400;
Height = 200 + 20*size(data,1);
ScreenSize = get(0,'ScreenSize');
% show "set tissue parameter" window
figHandles = get(0,'Children');
if ~isempty(figHandles)
    IdxHandle = strcmp(get(figHandles,'Name'),'Set Tissue Parameters');
else
    IdxHandle = [];
end

%check if window is already exists 
if any(IdxHandle)
    IdxTable = find(strcmp({figHandles(IdxHandle).Children.Type},'uitable'));
    set(figHandles(IdxHandle).Children(IdxTable), 'Data', []);
    figTissue = figHandles(IdxHandle);
    %set focus
    figure(figTissue);
else
    figTissue = figure('Name','Set Tissue Parameters','Color',[.5 .5 .5],'NumberTitle','off','Position',...
        [ceil(ScreenSize(3)/2) ceil(ScreenSize(4)/2) Width Height]);
end

% define the tissue parameter table
cNames = {'VOI','alphaX betaX','alpha beta ratio'};
columnformat = {'char',CellType,'numeric'};

tissueTable = uitable('Parent', figTissue,'Data', data,'ColumnEditable',[false true false],...
                      'ColumnName',cNames, 'ColumnFormat',columnformat,'Position',[50 150 10 10]);
set(tissueTable,'CellEditCallback',@tissueTable_CellEditCallback);
% set width and height
currTablePos = get(tissueTable,'Position');
currTableExt = get(tissueTable,'Extent');
currTablePos(3) = currTableExt(3);
currTablePos(4) = currTableExt(4);
set(tissueTable,'Position',currTablePos);

% define two buttons with callbacks
uicontrol('Parent', figTissue,'Style', 'pushbutton', 'String', 'Save&Close',...
        'Position', [Width-(0.25*Width) 0.1 * Height 70 30],...
        'Callback', @(hpb,eventdata)SaveTissueParameters(hpb,eventdata,handles));
    
uicontrol('Parent', figTissue,'Style', 'pushbutton', 'String', 'Cancel&Close',...
        'Position', [Width-(0.5*Width) 0.1 * Height 80 30],...
        'Callback', 'close');    
    
guidata(hObject,handles); 
UpdateState(handles);
    
    
function SaveTissueParameters(~, ~, handles) 
cst = evalin('base','cst');    
% get handle to uiTable
figHandles = get(0,'Children');
IdxHandle  = find(strcmp(get(figHandles,'Name'),'Set Tissue Parameters'));
% find table in window

figHandleChildren = get(figHandles(IdxHandle),'Children');
IdxTable   = find(strcmp(get(figHandleChildren,'Type'),'uitable'));
uiTable    = figHandleChildren(IdxTable);
% retrieve data from uitable
data       = get(uiTable,'data');

for i = 1:size(cst,1)
   for j = 1:size(data,1)
       if strcmp(cst{i,2},data{j,1})
         alphaXBetaX = str2num(data{j,2});
         cst{i,5}.alphaX = alphaXBetaX(1);
         cst{i,5}.betaX  = alphaXBetaX(2);
       end
   end
end
assignin('base','cst',cst);
close
handles.State = 2;
UpdateState(handles);
 

        
function tissueTable_CellEditCallback(hObject, eventdata, ~) 
if eventdata.Indices(2) == 2
   alphaXBetaX = str2num(eventdata.NewData);
   data = get(hObject,'Data');
   data{eventdata.Indices(1),3} = alphaXBetaX(1)/alphaXBetaX(2);
   set(hObject,'Data',data);
end

% --- Executes on button press in btnSaveToGUI.
function btnSaveToGUI_Callback(hObject, ~, handles)

Width  = 400;
Height = 200;
ScreenSize = get(0,'ScreenSize');

% show "Provide result name" window
figHandles = get(0,'Children');
if ~isempty(figHandles)
    IdxHandle = strcmp(get(figHandles,'Name'),'Provide result name');
else
    IdxHandle = [];
end

%check if window is already exists 
if any(IdxHandle)
    figDialog = figHandles(IdxHandle);
    %set focus
    figure(figDialog);
else
    figDialog = dialog('Position',[ceil(ScreenSize(3)/2) ceil(ScreenSize(4)/2) Width Height],'Name','Provide result name','Color',[0.5 0.5 0.5]);
    
    uicontrol('Parent',figDialog,...
              'Style','text',...
              'Position',[20 Height - (0.35*Height) 350 60],...
              'String','Please provide a decriptive name for your optimization result:','FontSize',10,'BackgroundColor',[0.5 0.5 0.5]);
    
    uicontrol('Parent',figDialog,...
              'Style','edit',...
              'Position',[30 60 350 60],... 
              'String','Please enter name here...','FontSize',10,'BackgroundColor',[0.55 0.55 0.55]);
         
    uicontrol('Parent', figDialog,'Style', 'pushbutton', 'String', 'Save','FontSize',10,...
              'Position', [0.42*Width 0.1 * Height 70 30],...
              'Callback', @(hpb,eventdata)SaveResultToGUI(hpb,eventdata,guidata(hpb)));        
end

uiwait(figDialog);
guidata(hObject, handles);
UpdateState(handles)
UpdatePlot(handles)


function SaveResultToGUI(~, ~, ~)
AllFigHandles = get(0,'Children');    
ixHandle      = strcmp(get(AllFigHandles,'Name'),'Provide result name');
uiEdit        = get(AllFigHandles(ixHandle),'Children');

if strcmp(get(uiEdit(2),'String'),'Please enter name here...')
  
    formatOut = 'mmddyyHHMM';
    Suffix = ['_' datestr(now,formatOut)];
else
    % delete special characters
    Suffix = get(uiEdit(2),'String');
    logIx = isstrprop(Suffix,'alphanum');
    Suffix = ['_' Suffix(logIx)];
end

pln       = evalin('base','pln');
resultGUI = evalin('base','resultGUI');

if isfield(resultGUI,'physicalDose')
    resultGUI.(['physicalDose' Suffix])  = resultGUI.physicalDose; 
end
if isfield(resultGUI,'w')
    resultGUI.(['w' Suffix])             = resultGUI.w;
end

if ~strcmp(pln.bioOptimization,'none') && strcmp(pln.radiationMode,'carbon') == 1 
    if isfield(resultGUI,'effect')
        resultGUI.(['effect' Suffix])= resultGUI.effect; 
    end
    if isfield(resultGUI,'RBExDose')
        resultGUI.(['RBExDose' Suffix]) = resultGUI.RBExDose; 
    end
    if isfield(resultGUI,'RBE')
        resultGUI.(['RBE' Suffix]) = resultGUI.RBE;
    end
    if isfield(resultGUI,'alpha')
        resultGUI.(['alpha' Suffix]) = resultGUI.alpha;
    end
    if isfield(resultGUI,'beta')
        resultGUI.(['beta' Suffix]) = resultGUI.beta;
    end
end

close(AllFigHandles(ixHandle));
assignin('base','resultGUI',resultGUI);

% precompute contours of VOIs
function cst = precomputeContours(ct,cst)
mask = zeros(ct.cubeDim); % create zero cube with same dimeonsions like dose cube
for s = 1:size(cst,1)
    cst{s,7} = cell(max(ct.cubeDim(:)),3);
    mask(:) = 0;
    mask(cst{s,4}{1}) = 1;    
    for slice = 1:ct.cubeDim(1)
        if sum(sum(mask(slice,:,:))) > 0
             cst{s,7}{slice,1} = contourc(squeeze(mask(slice,:,:)),.5*[1 1]);
        end
    end
    for slice = 1:ct.cubeDim(2)
        if sum(sum(mask(:,slice,:))) > 0
             cst{s,7}{slice,2} = contourc(squeeze(mask(:,slice,:)),.5*[1 1]);
        end
    end
    for slice = 1:ct.cubeDim(3)
        if sum(sum(mask(:,:,slice))) > 0
             cst{s,7}{slice,3} = contourc(squeeze(mask(:,:,slice)),.5*[1 1]);
        end
    end
end

%Update IsodoseLines
function handles = updateIsoDoseLineCache(handles)
resultGUI = evalin('base','resultGUI');
% select first cube if selected option does not exist
if ~isfield(resultGUI,handles.SelectedDisplayOption) && ~strcmp(handles.SelectedDisplayOption,'RBETruncated10Perc')
    CubeNames = fieldnames(resultGUI);
    dose = resultGUI.(CubeNames{1,1});
elseif strcmp(handles.SelectedDisplayOption,'RBETruncated10Perc')
    currentCubeName = 'RBE';
    dose = resultGUI.(currentCubeName);
    dose(resultGUI.physicalDose<0.1*max(resultGUI.physicalDose(:))) = 0;
else
    dose = resultGUI.(handles.SelectedDisplayOption);
end


handles.maxDoseVal = max(dose(:));

%ensure there are ISODoseLevels
if ~numel(handles.IsoDose.Levels) >1
    handles  = getIsoDoseLevels(handles);
end

set(handles.txtMaxDoseVal,'String',num2str(handles.maxDoseVal))
 

handles.IsoDose.Contours = matRad_computeIsoDoseContours(dose,handles.IsoDose.Levels);

function handles =  getIsoDoseLevels(handles)
    SpacingLower = 0.1;
    SpacingUpper = 0.05;
    vLow  = 0.1:SpacingLower:0.9;
    vHigh = 0.95:SpacingUpper:1.2;
    vLevels = [vLow vHigh];  
    handles.IsoDose.Levels = (round((vLevels.*((handles.maxDoseVal*100)/120))*1000))/1000;   % 

    
    
   
%% CREATE FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% popup menu: machine
function popUpMachine_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% text box: max value
function txtMaxDoseVal_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% text box: edit iso center
function editIsoCenter_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% text box: stratification levels
function editSequencingLevel_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function slicerPrecision_CreateFcn(hObject, ~, ~)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function editBixelWidth_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editGantryAngle_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editCouchAngle_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupRadMode_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editFraction_CreateFcn(hObject, ~, ~) 
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupPlane_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function sliderSlice_CreateFcn(hObject, ~, ~)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function popupTypeOfPlot_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupDisplayOption_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function sliderBeamSelection_CreateFcn(hObject, ~, ~)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function listBoxCmd_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function sliderOffset_CreateFcn(hObject, ~, ~)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in vmcFlag.
function vmcFlag_Callback(hObject, eventdata, handles)
% hObject    handle to vmcFlag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of vmcFlag


% --- Executes on selection change in legendTable.
function legendTable_Callback(hObject, eventdata, handles)
% hObject    handle to legendTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns legendTable contents as cell array
%        contents{get(hObject,'Value')} returns selected item from legendTable
cst = evalin('base','cst');

colors = colorcube;
colors = colors(round(linspace(1,63,size(cst,1))),:);
idx    = get(hObject,'Value');
clr    = dec2hex(round(colors(idx,:)*255),2)';
clr    = ['#';clr(:)]';

%Get the string entries
tmpString = get(handles.legendTable,'String');

if handles.VOIPlotFlag(idx)
    handles.VOIPlotFlag(idx) = false;
    tmpString{idx} = ['<html><table border=0 ><TR><TD bgcolor=',clr,' width="18"></TD><TD>',cst{idx,2},'</TD></TR> </table></html>'];
elseif ~handles.VOIPlotFlag(idx)
    handles.VOIPlotFlag(idx) = true;
    tmpString{idx} = ['<html><table border=0 ><TR><TD bgcolor=',clr,' width="18"><center>&#10004;</center></TD><TD>',cst{idx,2},'</TD></TR> </table></html>'];
end
set(handles.legendTable,'String',tmpString);

guidata(hObject, handles);
UpdatePlot(handles)

% --- Executes during object creation, after setting all properties.
function legendTable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to legendTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in importDoseButton.
function importDoseButton_Callback(hObject,eventdata, handles)
% hObject    handle to importDoseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
extensions{1} = '*.nrrd';
[filenames,filepath,~] = uigetfile(extensions,'MultiSelect','on');

if ~iscell(filenames)
    tmp = filenames;
    filenames = cell(1);
    filenames{1} = tmp;
end

ct = evalin('base','ct');
resultGUI = evalin('base','resultGUI');

for filename = filenames
    [~,name,~] = fileparts(filename{1});
    matRadRootDir = fileparts(mfilename('fullpath'));
    addpath(fullfile(matRadRootDir,'IO'))
    [cube,~] = matRad_readCube(fullfile(filepath,filename{1}));
    if ~isequal(ct.cubeDim, size(cube))
        errordlg('Dimensions of the imported cube do not match with ct','Import failed!','modal');
        continue;
    end
    
    fieldname = ['import_' matlab.lang.makeValidName(name, 'ReplacementStyle','delete')];
    resultGUI.(fieldname) = cube;
end

assignin('base','resultGUI',resultGUI);
btnRefresh_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton_importFromBinary.
function pushbutton_importFromBinary_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_importFromBinary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    % delete existing workspace - parse variables from base workspace
    AllVarNames = evalin('base','who');
    RefVarNames = {'ct','cst','pln','stf','dij','resultGUI'};
    for i = 1:length(RefVarNames)  
        if sum(ismember(AllVarNames,RefVarNames{i}))>0
            evalin('base',['clear ', RefVarNames{i}]);
        end
    end
    handles.State = 0;
    if ~isdeployed
        matRadRootDir = fileparts(mfilename('fullpath'));
        addpath(fullfile(matRadRootDir,'IO'))
    end
    
    %call the uigetfile,import aim file
    [DataFile basePath ] = uigetfile('*.mat');
    IntuitivOptBaseDataFile = fullfile(basePath,DataFile);
    
    fprintf('Begin loading the base mat file for Intuitive Opt ........ \n');
    load(IntuitivOptBaseDataFile);
    fprintf('End of loading mat file for Intuitive Opt ........ \n');
    
    
    
    
    %Check if we have the variables in the workspace
    %if evalin('global','exist(''cst'',''var'')') == 1 && evalin('global','exist(''ct'',''var'')') == 1
     if exist('cst','var')  &&  exist('ct','var') 
        
        assignin('base','ct',ct);
        assignin('base','cst',cst);
        
        cst = evalin('base','cst');
        ct = evalin('base','ct');
        setCstTable(handles,cst);
        handles.TableChanged = false;
        set(handles.popupTypeOfPlot,'Value',1);
        % precompute contours 
        %cst = precomputeContours(ct,cst);
        
        if exist('pln','var')
            assignin('base','pln',pln);
            setPln(handles);
        else
            getPlnFromGUI(handles);
            setPln(handles);
        end
        handles.State = 1;
     end
    
      if exist('dij','var')  
          assignin('base','dij',dij); 
          handles.State = 2; 
      end
     
     
    
    % set slice slider
    handles.plane = get(handles.popupPlane,'value');
    if handles.State >0
        set(handles.sliderSlice,'Min',1,'Max',ct.cubeDim(handles.plane),...
            'Value',round(ct.cubeDim(handles.plane)/2),...
            'SliderStep',[1/(ct.cubeDim(handles.plane)-1) 1/(ct.cubeDim(handles.plane)-1)]);
    end

    if handles.State > 0
        % define context menu for structures
        for i = 1:size(cst,1)
            if cst{i,5}.Visible
                handles.VOIPlotFlag(i) = true;
            else
                handles.VOIPlotFlag(i) = false;
            end
        end
    end
    
    handles.ctWindow = [];
    handles.doseWindow = [];
    handles.cBarChanged = true;
    
    UpdateState(handles);
    handles.rememberCurrAxes = false;
    UpdatePlot(handles);
    handles.rememberCurrAxes = true;
catch
   handles = showError(handles,'Binary Patient Import: Could not import Intuitive Opt Base data');
   UpdateState(handles);
end

guidata(hObject,handles);

% --- Executes on button press in radioBtnIsoCenter.
function radioBtnIsoCenter_Callback(hObject, eventdata, handles)
% hObject    handle to radioBtnIsoCenter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UpdatePlot(handles)
% Hint: get(hObject,'Value') returns toggle state of radioBtnIsoCenter

% --------------------------------------------------------------------
function uipushtool_screenshot_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool_screenshot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 
tmpFig = figure('position',[100 100 700 600],'Visible','off','name','Current View'); 
cBarHandle = findobj(handles.figure1,'Type','colorbar');
if ~isempty(cBarHandle)
    new_handle = copyobj([handles.axesFig cBarHandle],tmpFig);
else
    new_handle = copyobj(handles.axesFig,tmpFig);
end

oldPos = get(handles.axesFig,'Position');
set(new_handle(1),'units','normalized', 'Position',oldPos);

[filename, pathname] = uiputfile({'*.jpg;*.tif;*.png;*.gif','All Image Files'; '*.fig','MATLAB figure file'},'Save current view','./screenshot.png');

if ~isequal(filename,0) && ~isequal(pathname,0)
    set(gcf, 'pointer', 'watch');
    saveas(tmpFig,fullfile(pathname,filename));
    set(gcf, 'pointer', 'arrow');
    close(tmpFig);
    uiwait(msgbox('Current view has been succesfully saved!'));
else
    uiwait(msgbox('Aborted saving, showing figure instead!'));
    set(tmpFig,'Visible','on');
end

%% Callbacks & Functions for color setting
function UpdateColormapOptions(handles)

selectionIndex = get(handles.popupmenu_chooseColorData,'Value');

cMapSelectionIndex = get(handles.popupmenu_chooseColormap,'Value');
cMapStrings = get(handles.popupmenu_chooseColormap,'String');

if selectionIndex > 1 
    set(handles.uitoggletool8,'State','on');
else
    set(handles.uitoggletool8,'State','off');
end

try 
    if selectionIndex == 2
        ct = evalin('base','ct');
        currentMap = handles.ctColorMap;
        window = handles.ctWindow;
        minMax = [min(ct.cube{1}(:)) max(ct.cube{1}(:))];
    elseif selectionIndex == 3
        result = evalin('base','resultGUI');        
        dose = result.(handles.SelectedDisplayOption);
        currentMap = handles.doseColorMap;
        minMax = [min(dose(:)) max(dose(:))];
        window = handles.doseWindow;
    else
        window = [0 1];
        minMax = window;
        currentMap = 'bone';
    end
catch
    window = [0 1];
    minMax = window;
    currentMap = 'bone';
end

valueRange = minMax(2) - minMax(1);

windowWidth = window(2) - window(1);
windowCenter = mean(window);

%This are some arbritrary settings to configure the sliders
sliderCenterMinMax = [minMax(1)-valueRange/2 minMax(2)+valueRange/2];
sliderWidthMinMax = [0 valueRange*2];

%if we have selected a value outside this range, we adapt the slider
%windows
if windowCenter < sliderCenterMinMax(1)
    sliderCenterMinMax(1) = windowCenter;
end
if windowCenter > sliderCenterMinMax(2)
    sliderCenterMinMax(2) = windowCenter;
end
if windowWidth < sliderWidthMinMax(1)
    sliderWidthMinMax(1) = windowWidth;
end
if windowCenter > sliderCenterMinMax(2)
    sliderWidthMinMax(2) = windowWidth;
end


set(handles.edit_windowCenter,'String',num2str(windowCenter,3));    
set(handles.edit_windowWidth,'String',num2str(windowWidth,3));
set(handles.edit_windowRange,'String',num2str(window,4));
set(handles.slider_windowCenter,'Min',sliderCenterMinMax(1),'Max',sliderCenterMinMax(2),'Value',windowCenter);
set(handles.slider_windowWidth,'Min',sliderWidthMinMax(1),'Max',sliderWidthMinMax(2),'Value',windowWidth);

cMapPopupIndex = find(strcmp(currentMap,cMapStrings));
set(handles.popupmenu_chooseColormap,'Value',cMapPopupIndex);

% --- Executes on selection change in popupmenu_chooseColorData.
function popupmenu_chooseColorData_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_chooseColorData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_chooseColorData contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_chooseColorData

%index = get(hObject,'Value') - 1;

handles.cBarChanged = true;

guidata(hObject,handles);
UpdatePlot(handles);


% --- Executes during object creation, after setting all properties.
function popupmenu_chooseColorData_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_chooseColorData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider_windowCenter_Callback(hObject, eventdata, handles)
% hObject    handle to slider_windowCenter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

newCenter = get(hObject,'Value');
range = get(handles.slider_windowWidth,'Value');

selectionIndex = get(handles.popupmenu_chooseColorData,'Value');

switch selectionIndex 
    case 2
        handles.ctWindow = [newCenter-range/2 newCenter+range/2];
    case 3
        handles.doseWindow = [newCenter-range/2 newCenter+range/2];
    otherwise
end

handles.cBarChanged = true;

guidata(hObject,handles);
UpdatePlot(handles);

% --- Executes during object creation, after setting all properties.
function slider_windowCenter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_windowCenter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

set(hObject,'Value',0.5);

% --- Executes on slider movement.
function slider_windowWidth_Callback(hObject, eventdata, handles)
% hObject    handle to slider_windowWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

newWidth = get(hObject,'Value');
center = get(handles.slider_windowCenter,'Value');

selectionIndex = get(handles.popupmenu_chooseColorData,'Value');

switch selectionIndex 
    case 2
        handles.ctWindow = [center-newWidth/2 center+newWidth/2];
    case 3
        handles.doseWindow = [center-newWidth/2 center+newWidth/2];
    otherwise
end

handles.cBarChanged = true;

guidata(hObject,handles);
UpdatePlot(handles);

% --- Executes during object creation, after setting all properties.
function slider_windowWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_windowWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

set(hObject,'Value',1.0);


% --- Executes on selection change in popupmenu_chooseColormap.
function popupmenu_chooseColormap_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_chooseColormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_chooseColormap contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_chooseColormap

index = get(hObject,'Value');
strings = get(hObject,'String');

selectionIndex = get(handles.popupmenu_chooseColorData,'Value');

switch selectionIndex 
    case 2
        handles.ctColorMap = strings{index};
    case 3
        handles.doseColorMap = strings{index};
    otherwise
end

handles.cBarChanged = true;

guidata(hObject,handles);
UpdatePlot(handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_chooseColormap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_chooseColormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_windowRange_Callback(hObject, eventdata, handles)
% hObject    handle to edit_windowRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_windowRange as text
%        str2double(get(hObject,'String')) returns contents of edit_windowRange as a double

selectionIndex = get(handles.popupmenu_chooseColorData,'Value');

switch selectionIndex 
    case 2
        handles.ctWindow = str2num(get(hObject,'String'));
    case 3
        handles.doseWindow = str2num(get(hObject,'String'));
    otherwise
end

handles.cBarChanged = true;

guidata(hObject,handles);
UpdatePlot(handles);

% --- Executes during object creation, after setting all properties.
function edit_windowRange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_windowRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String','0 1');


function edit_windowCenter_Callback(hObject, eventdata, handles)
% hObject    handle to edit_windowCenter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_windowCenter as text
%        str2double(get(hObject,'String')) returns contents of edit_windowCenter as a double

newCenter = str2double(get(hObject,'String'));
width = get(handles.slider_windowWidth,'Value');

selectionIndex = get(handles.popupmenu_chooseColorData,'Value');

switch selectionIndex 
    case 2
        handles.ctWindow = [newCenter-width/2 newCenter+width/2];
    case 3
        handles.doseWindow = [newCenter-width/2 newCenter+width/2];
    otherwise
end

handles.cBarChanged = true;

guidata(hObject,handles);
UpdatePlot(handles);

% --- Executes during object creation, after setting all properties.
function edit_windowCenter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_windowCenter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_windowWidth_Callback(hObject, eventdata, handles)
% hObject    handle to edit_windowWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_windowWidth as text
%        str2double(get(hObject,'String')) returns contents of edit_windowWidth as a double

newWidth = str2double(get(hObject,'String'));
center = get(handles.slider_windowCenter,'Value');

selectionIndex = get(handles.popupmenu_chooseColorData,'Value');

switch selectionIndex 
    case 2
        handles.ctWindow = [center-newWidth/2 center+newWidth/2];
    case 3
        handles.doseWindow = [center-newWidth/2 center+newWidth/2];
    otherwise
end

handles.cBarChanged = true;

guidata(hObject,handles);
UpdatePlot(handles);


% --- Executes during object creation, after setting all properties.
function edit_windowWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_windowWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function uitoggletool8_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Check if on or off
val = strcmp(get(hObject,'State'),'on');

%Now we have to apply the new selection to our colormap options panel
if ~val
    newSelection = 1;
else
    %Chooses the selection from the highest state
    selections = get(handles.popupmenu_chooseColorData,'String');
    newSelection = numel(selections);
end    
set(handles.popupmenu_chooseColorData,'Value',newSelection);

handles.cBarChanged = true;
guidata(hObject,handles);
UpdatePlot(handles);
    


% --- Executes on slider movement.
function sliderOpacity_Callback(hObject, eventdata, handles)
% hObject    handle to sliderOpacity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.doseOpacity = get(hObject,'Value');
guidata(hObject,handles);
UpdatePlot(handles);

% --- Executes during object creation, after setting all properties.
function sliderOpacity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderOpacity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in btnSaveBDataforIntOpt.
function btnSaveBDataforIntOpt_Callback(hObject, eventdata, handles)
% hObject    handle to btnSaveBDataforIntOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


currPath = fileparts(mfilename('fullpath'));% get current path

FilePath = uigetdir(currPath);
%handles.DijCalcWarning = true;   

% if a critical change to the cst has been made which affects the dij matrix
if handles.DijCalcWarning == true

    choice = questdlg('Overlap priorites of OAR constraints have been edited, a new OAR VOI was added or a critical row constraint was deleted. A new Dij calculation might be necessary.', ...
    'Title','Cancel','Calculate Dij then Save','Save directly','Save directly');

    switch choice
        case 'Cancel'
            return
        case 'Calculate Dij then Save'
            handles.DijCalcWarning = false;
            btnCalcDose_Callback(hObject, eventdata, handles)      
        case 'Save directly'
            handles.DijCalcWarning = false;       
    end
end

pln = evalin('base','pln');
ct  = evalin('base','ct');
cst = evalin('base','cst');


stf = evalin('base','stf');
dij = evalin('base','dij');




% determine the existing workspace - parse variables from base workspace
AllVarNames = evalin('base','who');
RefVarNames = {'ct','cst','pln','stf','dij'};

FileName = strcat(ct.dicomInfo.PatientName.FamilyName,'_',ct.dicomInfo.PatientName.GivenName,'_B',num2str(pln.numOfBeams),'IntOpData.mat');
intOptDataFullname = fullfile(FilePath,FileName);

if (ismember(RefVarNames,AllVarNames))
    fprintf('Begin Saving the base mat file for Intuitive Opt ........ \n');
    save(intOptDataFullname,'ct','cst','pln','stf','dij','-v7.3');
    fprintf('Save base mat file for Intuitive Opt: Done! \n');
end







% 
% % --- Executes on selection change in popupmenuTMLevel.
% function popupmenuTMLevel_Callback(hObject, eventdata, handles)
% % hObject    handle to popupmenuTMLevel (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: contents = cellstr(get(hObject,'String')) returns popupmenuTMLevel contents as cell array
% %        contents{get(hObject,'Value')} returns selected item from popupmenuTMLevel
% 
% %update the tabel gui tabel column
% nTMLevel = get(hObject,'Value');
% 
% precnames = get(handles.uiTable,'ColumnName');
% precwidth = get(handles.uiTable,'ColumnWidth');
% 
% npre= numel(precnames);
% 
% %Template of name and width
% cnamesT = {'TMU','TMU r','TML','TML r'};
% cwidthT = {50,60,50,60};
% 
% dataT = {NaN, NaN, NaN, NaN};
% 
% 
% %Deta number of unit
% nUnit = nTMLevel -(npre -3 )/4;
% 
% cnames = precnames;
% cwidth = precwidth;
% 
% if ( nUnit ) == 0
%     return;
% elseif nUnit > 0
%    
%     for i = 0:nUnit-1
%         cnames{npre + i *4 +1,1} =cnamesT{1,1};
%         cwidth{1,npre + i *4 +1} =cwidthT{1,1};
%          
%         cnames{npre + i *4 +2,1} =cnamesT{1,2};
%         cwidth{1,npre + i *4 +2} =cwidthT{1,2};
%         
%         cnames{npre + i *4 +3,1} =cnamesT{1,3};
%         cwidth{1,npre + i *4 +3} =cwidthT{1,3};
%         
%         cnames{npre + i *4 +4,1} =cnamesT{1,4};
%         cwidth{1,npre + i *4 +4} =cwidthT{1,4};   
%         
%         
%     end
% else
%      
%     for i = nUnit:-1
%         cnames = cnames(1:npre + i *4 ,1);
%         cwidth = cwidth(1,1:npre + i *4);
%          
%     end     
%   
% end
%     
% %update the uitable data content
% 
% cdata = get(handles.uiTable,'Data');
% 
% [countobjct,ncolumn] = size(cdata);
% 
% newData = {};
% 
% if nUnit > 0
%     for i = 1:countobjct
%         Newobjectdata =  addTMDColumnDataAsLevel(cdata(i,:),nUnit,dataT);
%         newData(i,:) = Newobjectdata;
%     end 
% 
% elseif nUnit <0
%     for i = 1:countobjct
%         Newobjectdata =  cdata(i,1:ncolumn-abs(nUnit)*4);
%         newData(i,:) = Newobjectdata;
%     end 
%     
% end
% 
% 
% set(handles.uiTable, 'ColumnName',cnames, ...
%                      'ColumnWidth',cwidth, ...
%                      'Data',newData    );       
%               
% 
% 
% %handles.State=1;
% guidata(hObject,handles);
% UpdateState(handles);
% 



% 
% % --- Executes during object creation, after setting all properties.
% function popupmenuTMLevel_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to popupmenuTMLevel (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: popupmenu controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end


% --- Executes during object creation, after setting all properties.
function uiTable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uiTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in TMDDetail_pushbutton.
function TMDDetail_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to TMDDetail_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

matRad_IntuitiveOptTMDDetials;
%updateUITabelData(handles);


function updateUITabelData(handles)
global intOptParameters

data = handles.uiTable.Data;

structlist = data(:,1);

for i =1:numel(structlist)
    TMDArray = GetTMDArray(structlist(i));
    if(isempty (TMDArray))
        continue;
    end
    
    data{i,4} = numel(TMDArray);
end

 handles.uiTable.Data = data;




% --- Executes on button press in updateTabel_pushbutton.
function updateTabel_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to updateTabel_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

updateUITabelData(handles);


% --- Executes on button press in resumeOpt_pushbutton.
function resumeOpt_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to resumeOpt_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global intOptResultGUI
global intOptParameters

fprintf('Resume  cvx IntuitiveOpt .....\n');


dij = evalin('base','dij');
cst = evalin('base','cst');
pln = evalin('base','pln');


fprintf('Update cvx intOptParameters .....\n');

%get the intOpt Parameters
intOptParameters = getIntuitiveOptParameters(cst,dij);


fprintf('Beging cvx IntuitiveOpt .....\n');

resultGUI = matRad_IntuitiveOptFluenceOptimization(dij,cst,pln);
intOptResultGUI = resultGUI;

fprintf('End cvx IntuitiveOpt \n');



%update the matRad GUI Show
UpdatePlot(handles);



