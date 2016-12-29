function  newColumnname =  addTMDTableColumnNames(existCloumnname,TMDArray)

% addTMDTableColumnNames
% used for Intuitive Opt
% paramters:
%      existCloumnname:  a cell array
%      tmdArray: used for test

presize = numel(existCloumnname);


newColumnname = existCloumnname;
index = 1;

for j = 1:numel(TMDArray)   
    TMD = TMDArray{j};      
          
    item = sprintf('TMD_%.2f_%s',TMD.doseValue,TMD.direction );
  
    newColumnname{presize + index} = item;
    index = index + 1;
    
end



