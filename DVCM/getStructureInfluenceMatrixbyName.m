function IM= getStructureInfluenceMatrixbyName(name,intOptParameters )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% name : Structure Name
% intOptParameters : the intOptParameters
% IM: the InfluenceMatrix for structure Dose calculation

%find the target
for i=1:numel(intOptParameters.targetSet)
    label = intOptParameters.targetSet(i).label;

    if strcmp(name,label)
       IM =  intOptParameters.targetSet(i).influenceM;
       return;
    end    
    
    
end


%find the oar
for j=1:numel(intOptParameters.oarSet)
    label = intOptParameters.oarSet(j).label;

    if strcmp(name,label)
       IM =  intOptParameters.oarSet(j).influenceM;
       return;
    end   
    
    
end

 

end

