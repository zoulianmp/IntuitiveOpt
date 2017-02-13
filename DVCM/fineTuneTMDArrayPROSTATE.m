%%% This Script Used for fine tune the TMD Sets for intuitiveOpt 

%%%****************************************************
%%Used for PROSTATE


%% parse variables from base workspace
AllVarNames = evalin('base','who');


if  ismember('cst',AllVarNames)
    cst = evalin('base','cst');
end

%BODY cst{1,6}

TMDStruct1.doseValue =60;
TMDStruct1.direction = 'U'; % The U: UP, L: Low
TMDStruct1.TMDValue =  0;
TMDStruct1.TMDRange =0.05;
TMDStruct1.TMDindex = 1;

cst{1,6}.TMDArray ={};

cst{1,6}.TMDArray{1} = TMDStruct1;

%Bladder  cst{2,6}

TMDStruct1.doseValue = 50;
TMDStruct1.direction = 'U'; % The U: UP, L: Low
TMDStruct1.TMDValue = 25;
TMDStruct1.TMDRange = 0.5;
TMDStruct1.TMDindex = 2;
% 
% TMDStruct2.doseValue = 10;
% TMDStruct2.direction = 'U'; % The U: UP, L: Low
% TMDStruct2.TMDValue = 0.7;
% TMDStruct2.TMDRange = 0.05;
% TMDStruct2.TMDindex = 3;
% 
 cst{2,6}.TMDArray = {};
% 
 cst{2,6}.TMDArray{1} = TMDStruct1;
% cst{2,6}.TMDArray{2} = TMDStruct2;

%Lt femoral head  cst{3,6}

% TMDStruct1.doseValue = 50;
% TMDStruct1.direction = 'L'; % The U: UP, L: Low
% TMDStruct1.TMDValue = 0;
% TMDStruct1.TMDRange = 0.005;
% TMDStruct1.TMDindex = 4;
% 
% TMDStruct2.doseValue = 54;
% TMDStruct2.direction = 'U'; % The U: UP, L: Low
% TMDStruct2.TMDValue =  0;
% TMDStruct2.TMDRange = 0;
% TMDStruct2.TMDindex = 5;
% 
% cst{3,6}.TMDArray = {};
% 
% cst{3,6}.TMDArray{1} = TMDStruct1;
% cst{3,6}.TMDArray{2} = TMDStruct2;
        
%Lymph Nodes  cst{4,6}

% TMDStruct1.doseValue = 50;
% TMDStruct1.direction = 'L'; % The U: UP, L: Low
% TMDStruct1.TMDValue = 0;
% TMDStruct1.TMDRange = 0.005;
% TMDStruct1.TMDindex = 6;
% 
% TMDStruct2.doseValue = 54;
% TMDStruct2.direction = 'U'; % The U: UP, L: Low
% TMDStruct2.TMDValue =  0;
% TMDStruct2.TMDRange = 0;
% TMDStruct2.TMDindex = 7;
% 
% cst{4,6}.TMDArray = {};
% 
% cst{4,6}.TMDArray{1} = TMDStruct1;
% cst{4,6}.TMDArray{2} = TMDStruct2;

%PTV 56  cst{5,6}

TMDStruct1.doseValue = 56;
TMDStruct1.direction = 'L'; % The U: UP, L: Low
TMDStruct1.TMDValue = 0;
TMDStruct1.TMDRange = 0.05;
TMDStruct1.TMDindex = 8;

TMDStruct2.doseValue = 60;
TMDStruct2.direction = 'U'; % The U: UP, L: Low
TMDStruct2.TMDValue =  0;
TMDStruct2.TMDRange = 0.05;
TMDStruct2.TMDindex = 9;

cst{5,6}.TMDArray = {};

cst{5,6}.TMDArray{1} = TMDStruct1;
cst{5,6}.TMDArray{2} = TMDStruct2;
%PTV 68  cst{6,6}

TMDStruct1.doseValue = 56;
TMDStruct1.direction = 'L'; % The U: UP, L: Low
TMDStruct1.TMDValue = 0;
TMDStruct1.TMDRange = 0.05;
TMDStruct1.TMDindex = 10;

TMDStruct2.doseValue = 60;
TMDStruct2.direction = 'U'; % The U: UP, L: Low
TMDStruct2.TMDValue =  0;
TMDStruct2.TMDRange = 0.05;
TMDStruct2.TMDindex = 11;
 
cst{6,6}.TMDArray = {};

cst{6,6}.TMDArray{1} = TMDStruct1;
cst{6,6}.TMDArray{2} = TMDStruct2;

%Penile bulb  cst{7,6}

% TMDStruct1.doseValue = 50;
% TMDStruct1.direction = 'L'; % The U: UP, L: Low
% TMDStruct1.TMDValue = 0;
% TMDStruct1.TMDRange = 0.005;
% TMDStruct1.TMDindex = 12;
% 
% TMDStruct2.doseValue = 54;
% TMDStruct2.direction = 'U'; % The U: UP, L: Low
% TMDStruct2.TMDValue =  0;
% TMDStruct2.TMDRange = 0;
% TMDStruct2.TMDindex = 13;
% 
% cst{7,6}.TMDArray = {};
% 
% cst{7,6}.TMDArray{1} = TMDStruct1;
% cst{7,6}.TMDArray{2} = TMDStruct2;

%'Rectum  cst{8,6}

TMDStruct1.doseValue = 50;
TMDStruct1.direction = 'U'; % The U: UP, L: Low
TMDStruct1.TMDValue = 25;
TMDStruct1.TMDRange = 0.5;
TMDStruct1.TMDindex = 14;

% TMDStruct2.doseValue = 50;
% TMDStruct2.direction = 'U'; % The U: UP, L: Low
% TMDStruct2.TMDValue = 25;
% TMDStruct2.TMDRange = 0.5;
% TMDStruct2.TMDindex = 15;

cst{8,6}.TMDArray = {};

cst{8,6}.TMDArray{1} = TMDStruct1;
%cst{8,6}.TMDArray{2} = TMDStruct2;

%Rt femoral head  cst{9,6}

% TMDStruct1.doseValue = 50;
% TMDStruct1.direction = 'L'; % The U: UP, L: Low
% TMDStruct1.TMDValue = 0;
% TMDStruct1.TMDRange = 0.005;
% TMDStruct1.TMDindex = 16;
% 
% TMDStruct2.doseValue = 54;
% TMDStruct2.direction = 'U'; % The U: UP, L: Low
% TMDStruct2.TMDValue =  0;
% TMDStruct2.TMDRange = 0;
% TMDStruct2.TMDindex = 17;
% 
% cst{9,6}.TMDArray = {};
% 
% cst{9,6}.TMDArray{1} = TMDStruct1;
% cst{9,6}.TMDArray{2} = TMDStruct2;

%prostate bed  cst{10,6}

TMDStruct1.doseValue = 60;
TMDStruct1.direction = 'U'; % The U: UP, L: Low
TMDStruct1.TMDValue = 0;
TMDStruct1.TMDRange = 0.05;
TMDStruct1.TMDindex = 18;
% 
% TMDStruct2.doseValue = 54;
% TMDStruct2.direction = 'U'; % The U: UP, L: Low
% TMDStruct2.TMDValue =  0;
% TMDStruct2.TMDRange = 0;
% TMDStruct2.TMDindex = 19;
% 
 cst{10,6}.TMDArray = {};
% 
 cst{10,6}.TMDArray{1} = TMDStruct1;
% cst{10,6}.TMDArray{2} = TMDStruct2;

assignin('base','cst',cst);


%%End of PROSTATE        
%%%**************************************************