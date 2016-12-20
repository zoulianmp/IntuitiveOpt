%%% This Script Used for fine tune the TMD Sets for intuitiveOpt 

%%%****************************************************
%%Used for TG119 

%BODY cst{1,6}

% TMDStruct1.doseValue = 1.1;
% TMDStruct1.direction = 'U'; % The U: UP, L: Low
% TMDStruct1.TMDValue =  0.0914;
% TMDStruct1.TMDRange = 0.003;
% TMDStruct1.TMDindex = 1;
% 
% cst{1,6}.TMDArray ={};
% 
% cst{1,6}.TMDArray{1} = TMDStruct1;



%Core  cst{2,6}

% TMDStruct1.doseValue = 1.1;
% TMDStruct1.direction = 'U'; % The U: UP, L: Low
% TMDStruct1.TMDValue = 0.0244;
% TMDStruct1.TMDRange = 0.006;
% TMDStruct1.TMDindex = 2;
% 
% TMDStruct2.doseValue = 0.5;
% TMDStruct2.direction = 'U'; % The U: UP, L: Low
% TMDStruct2.TMDValue = 0.7305;
% TMDStruct2.TMDRange = 0.05;
% TMDStruct2.TMDindex = 3;
% 
% cst{2,6}.TMDArray = {};
% 
% cst{2,6}.TMDArray{1} = TMDStruct1;
% cst{2,6}.TMDArray{2} = TMDStruct2;

%OuterTarget  cst{3,6}

TMDStruct1.doseValue = 1.93;
TMDStruct1.direction = 'L'; % The U: UP, L: Low
TMDStruct1.TMDValue = 0.1064;
TMDStruct1.TMDRange = 0.0058;
TMDStruct1.TMDindex = 4;

TMDStruct2.doseValue = 2.0;
TMDStruct2.direction = 'U'; % The U: UP, L: Low
TMDStruct2.TMDValue =  0.9611;
TMDStruct2.TMDRange = 0.013;
TMDStruct2.TMDindex = 5;

cst{3,6}.TMDArray = {};

cst{3,6}.TMDArray{1} = TMDStruct1;
cst{3,6}.TMDArray{2} = TMDStruct2;
        
%%End of TG119        
%%%**************************************************