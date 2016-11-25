function [oar,num_oar] = ExtractingInfluenceMatrix(structureList)

global planC;

indexS = planC{end};

IMNumber = size(planC{indexS.IM},2);
counter = 1;
for ii=1:length(structureList)
    try
     oar{ii}.influenceM = getSingleGlobalInfluenceM(planC{indexS.IM}(IMNumber).IMDosimetry, structureList(ii));
     counter = counter + 1;
    catch
        warning('not all stuctures in the list is loaded... ')
    end
end
num_oar = counter-1;