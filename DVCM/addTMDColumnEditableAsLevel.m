function  newtablecolumneditable =  addTMDColumnEditableAsLevel(existCloumneditable,addlevel,editabletmp)

% addTMDLabelAsLevel
% used for Intuitive Opt
% paramters:
%      existCloumneditable:  a cell array
%      addlevel : added int type
%      editabletmp: a logic array


nTMLevel = addlevel;
presize = numel(existCloumneditable);

%Template of name 
ceditableT = editabletmp;
tsize = numel(editabletmp);

newtablecolumneditable = existCloumneditable;
index = 1;

for i = 1:nTMLevel
    
    for j = 1:tsize
        newtablecolumneditable(presize + index) = ceditableT(j);
        index = index + 1;
    
    end
end
