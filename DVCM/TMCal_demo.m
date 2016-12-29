%%%TM Transform Concept demo
numVoxel = 16;

Deviation = 0.5;
MeanDose = 2.1;
Dose = Deviation.*randn(numVoxel,1) + MeanDose;


maxDose = max(Dose);

TMU_500_index =  find( Dose > 500);


TMU_500 =  sum(Dose(TMU_500_index))/ numVoxel;



targetIM = getStructureInfluenceMatrixbyName('OuterTarget',intOptParameters );

targetdose = targetIM*resultGUI.w;





StructureDose = targetdose;

TMD(direction,DoseValue,StructureDose)