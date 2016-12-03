function  newtablecolumnformat =  addTMDColumnFormatAsLevel(existCloumnformat,addlevel,formattmp)

% addTMDColumnFormatAsLevel
% used for Intuitive Opt
% paramters:
%      existCloumnformat:  a cell array
%      addlevel : added int type
%      formattmp: format cell array


nTMLevel = addlevel;
presize = numel(existCloumnformat);

%Template of name 
cformatT = formattmp;
tsize = numel(formattmp);

newtablecolumnformat = existCloumnformat;
index = 1;

for i = 1:nTMLevel
    
    for j = 1:tsize
        newtablecolumnformat{presize + index} = cformatT{j};
        index = index + 1;
    
    end
end
