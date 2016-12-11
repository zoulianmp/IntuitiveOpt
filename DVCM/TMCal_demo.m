%%%TM Transform Concept demo
numVoxel = 100;

Deviation = 25;
MeanDose = 500;
Dose = Deviation.*randn(numVoxel,1) + MeanDose;


maxDose = max(Dose);

TMU_500_index =  find( Dose > 500);


TMU_500 =  sum(Dose(TMU_500_index))/ numVoxel;
