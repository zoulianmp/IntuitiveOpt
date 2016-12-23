function  newColumndata =  addTMDTableColumnData(existCloumndata,TMDArray)

% addTMDTableColumnData++
% used for Intuitive Opt
% paramters:
%      existCloumndata:  a cell array
%     TMDArray

presize = numel(existCloumndata);

newColumndata = existCloumndata;

index = 1;

for j = 1:numel(TMDArray)   
    TMD = TMDArray{j};      
    
    newColumndata{presize + index} =  TMD.TMDValue;
    index = index + 1;
    
end

