%%% This Script Used for fine tune the TMD Sets for intuitiveOpt 

%%%****************************************************
%%Used for TG119 

%BODY cst{1,6}

TMDStruct1.doseValue = 19.2;
TMDStruct1.direction = 'U'; % The U: UP, L: Low
TMDStruct1.TMDValue = 0;
TMDStruct1.TMDRange = 0;
TMDStruct1.TMDindex = 1;

cst{1,6}.TMDArray ={};

cst{1,6}.TMDArray{1} = TMDStruct1;



%Core  cst{2,6}

TMDStruct1.doseValue = 6.0;
TMDStruct1.direction = 'U'; % The U: UP, L: Low
TMDStruct1.TMDValue = 1.4;
TMDStruct1.TMDRange = 0.0206;
TMDStruct1.TMDindex = 2;

TMDStruct2.doseValue = 25.3;
TMDStruct2.direction = 'U'; % The U: UP, L: Low
TMDStruct2.TMDValue = 0.003;
TMDStruct2.TMDRange = 0.0005;
TMDStruct2.TMDindex = 3;

cst{2,6}.TMDArray = {};

cst{2,6}.TMDArray{1} = TMDStruct1;
cst{2,6}.TMDArray{2} = TMDStruct2;

%OuterTarget  cst{3,6}

TMDStruct1.doseValue = 24.0;
TMDStruct1.direction = 'L'; % The U: UP, L: Low
TMDStruct1.TMDValue = 0.2;
TMDStruct1.TMDRange = 0.0058;
TMDStruct1.TMDindex = 4;

TMDStruct2.doseValue = 25.3;
TMDStruct2.direction = 'U'; % The U: UP, L: Low
TMDStruct2.TMDValue = 0.08;
TMDStruct2.TMDRange = 0.0063;
TMDStruct2.TMDindex = 5;

cst{3,6}.TMDArray = {};

cst{3,6}.TMDArray{1} = TMDStruct1;
cst{3,6}.TMDArray{2} = TMDStruct2;
        
%%End of TG119        
%%%**************************************************