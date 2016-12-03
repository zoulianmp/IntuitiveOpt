function  newtablecolumndata =  addTMDColumnDataAsLevel(existCloumndata,addlevel,datatmp)

% addTMDColumnDataAsLevel++
% used for Intuitive Opt
% paramters:
%      existCloumndata:  a cell array
%      addlevel : added int type
%      datatmp: a data value cell array

{NaN, NaN, NaN, NaN};

nTMLevel = addlevel;
presize = numel(existCloumndata);

%Template of name 
tsize = numel(datatmp);

newtablecolumndata = existCloumndata;
index = 1;

for i = 1:nTMLevel
    
    for j = 1:tsize
        newtablecolumndata{presize + index} = datatmp{j};
        index = index + 1;
    
    end
end
