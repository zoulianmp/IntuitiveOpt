function namelist = getInvolvedStructureNameList( intOptParameters)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
namelist = {};
index = 1;


%find the target
for i=1:numel(intOptParameters.targetSet)
    label = intOptParameters.targetSet(i).label;

    namelist{index} = label;

    index = index + 1;
end


%find the oar
for j=1:numel(intOptParameters.oarSet)
    label = intOptParameters.oarSet(j).label;
    
    namelist{index} = label;
       
    index = index + 1;
end

 



end

