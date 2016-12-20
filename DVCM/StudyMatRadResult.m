
%% TG119 Example
%Target Prescribed Dose:  50Gy, 25 fraction

%OutTarget Dose distribution
OuterTargetIndex = cst{3,4}{1,1};


OuterTargetDose = dij.physicalDose{1}(OuterTargetIndex,:)* resultGUI.wUnsequenced;


OuterTargetMean = mean(OuterTargetDose)

OuterTarget_tmd_u1 = TMD('U',2.00,OuterTargetDose)

OuterTarget_tmd_l1 = TMD('L',1.93,OuterTargetDose)



%Core Dose distribution
CoreIndex = cst{2,4}{1,1};

CoreDose = dij.physicalDose{1}(CoreIndex,:)* resultGUI.wUnsequenced;


CoreMean = mean(CoreDose)

Core_tmd_u1 = TMD('U',1.1,CoreDose)

Core_tmd_u2 = TMD('U',0.5,CoreDose)




%BODY Dose distribution
BODYIndex = cst{1,4}{1,1};

BODYDose = dij.physicalDose{1}(BODYIndex,:)* resultGUI.wUnsequenced;


BODYMean = mean(BODYDose)

BODY_tmd_u1 = TMD('U',1.1,BODYDose)

BODY_tmd_u2 = TMD('U',0.5,BODYDose)

