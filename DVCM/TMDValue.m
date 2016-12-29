function tmd = TMDValue(direction,DoseValue,StructureDose)
%direction: U : Up ,L:Low
%DoseValue: dose value position for TMD Calculation
%StructureDose: 1 dimension array of structure Dose.


if strcmp(direction,'U')
           
    validindex = find(StructureDose > DoseValue);
    tmd =  sum(StructureDose(validindex))/length(StructureDose);
      
elseif strcmp(direction,'L')
           
    validindex = find(StructureDose < DoseValue);
    tmd =  sum(StructureDose(validindex))/length(StructureDose);
       
else
    tmd = 0;
end
