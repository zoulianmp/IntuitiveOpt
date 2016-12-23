function  newtCloumneditable =  addTMDTableColumnEditable(existCloumneditable,TMDArray)

% addTMDLabelAsLevel
% used for Intuitive Opt
% paramters:
%      existCloumneditable:  a cell array
%      addlevel : added int type
%      editabletmp: a logic array


presize = numel(existCloumneditable);

newtCloumneditable = existCloumneditable;

index = 1;

for j = 1:numel(TMDArray)   
     
    newtCloumneditable{presize + index} =  false;
    index = index + 1;
    
end

