function plotdifferent3(WV,planC,PrintName)
indexS=planC{end};
IMNumber = size(planC{indexS.IM},2); %to use the last IM structure created
%influenceM = getSingleGlobalInfluenceM(planC{indexS.IM}(IMNumber).IMDosimetry, 1:13);

%dose3DM = influenceM * wV;
%showIMDose(dose3DM,'Test dose name');
IM = planC{indexS.IM}(IMNumber).IMDosimetry;

dose3D = getIMDose(IM,WV,1:25);
showIMDose(dose3D,PrintName);
