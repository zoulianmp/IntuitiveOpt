function  newCloumnformat =  addTMDTableColumnFormat(existCloumnformat,TMDArray)

% addTMDTableColumnFormat
% used for Intuitive Opt
% paramters:
%      existCloumnformat:  a cell array
%      addlevel : added int type
%      formattmp: format cell array


presize = numel(existCloumnformat);


newCloumnformat = existCloumnformat;
index = 1;

for j = 1:numel(TMDArray)   
    
    newCloumnformat{presize + index} = 'numeric';
    index = index + 1;
    
end
