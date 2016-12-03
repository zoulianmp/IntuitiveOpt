function  newtablecolumnname =  addTMDColumnNameAsLevel(existCloumnname,addlevel,labeltmp)

% addTMDColumnNameAsLevel++
% used for Intuitive Opt
% paramters:
%      existCloumnname:  a cell array
%      addlevel : added int type
%      labeltmp:  name cell array

nTMLevel = addlevel;
presize = numel(existCloumnname);

%Template of name 
cnamesT = labeltmp;
tsize = numel(labeltmp);

newtablecolumnname = existCloumnname;
index = 1;

for i = 1:nTMLevel
    
    for j = 1:tsize
        newtablecolumnname{presize + index} = cnamesT{j};
        index = index + 1;
    
    end
end
