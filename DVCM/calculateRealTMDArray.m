function tmdArrayReal = calculateRealTMDArray(strutName,tmdArrayPrescibed);
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global intOptParameters
global intOptResultGUI

tmdArrayReal = tmdArrayPrescibed;
IM= getStructureInfluenceMatrixbyName(strutName,intOptParameters );

StructureDose = IM * intOptResultGUI.w;


for j = 1:numel(tmdArrayPrescibed)
   DoseValue = tmdArrayPrescibed{j}.doseValue;   
   direction = strtrim(tmdArrayPrescibed{j}.direction);  
   
   tmd = TMDValue(direction,DoseValue,StructureDose);

   tmdArrayReal{j}.TMDValue = tmd;
end 




end

