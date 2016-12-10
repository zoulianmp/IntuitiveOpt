%%% Script for preparing sample date for Intuitive Opt, add TMD datas 

load constraint.mat

%**************************************
% Begin BOXPHANTOM
load BOXPHANTOM.mat
cst{1,6}.TMLevel = a.TMLevel;
cst{1,6}.TMDLabel = a.TMDLabel;
cst{1,6}.TMDArray = a.TMDArray;

cst{2,6}.TMLevel = a.TMLevel;
cst{2,6}.TMDLabel = a.TMDLabel;
cst{2,6}.TMDArray = a.TMDArray;
save BOXPHANTOM_intopt.mat cst ct ; 

% End BOXPHANTOM
%**************************************

%**************************************
% Begin HEAD_AND_NECK
load HEAD_AND_NECK.mat
cst{7,6}.TMLevel = a.TMLevel;
cst{7,6}.TMDLabel = a.TMDLabel;
cst{7,6}.TMDArray = a.TMDArray;

cst{15,6}.TMLevel = a.TMLevel;
cst{15,6}.TMDLabel = a.TMDLabel;
cst{15,6}.TMDArray = a.TMDArray;

cst{16,6}.TMLevel = a.TMLevel;
cst{16,6}.TMDLabel = a.TMDLabel;
cst{16,6}.TMDArray = a.TMDArray;

cst{17,6}.TMLevel = a.TMLevel;
cst{17,6}.TMDLabel = a.TMDLabel;
cst{17,6}.TMDArray = a.TMDArray;


cst{18,6}.TMLevel = a.TMLevel;
cst{18,6}.TMDLabel = a.TMDLabel;
cst{18,6}.TMDArray = a.TMDArray;


cst{19,6}.TMLevel = a.TMLevel;
cst{19,6}.TMDLabel = a.TMDLabel;
cst{19,6}.TMDArray = a.TMDArray;


save HEAD_AND_NECK_intopt.mat cst ct ; 

% End HEAD_AND_NECK
%**************************************


%**************************************
% Begin LIVER
load LIVER.mat
cst{10,6}.TMLevel = a.TMLevel;
cst{10,6}.TMDLabel = a.TMDLabel;
cst{10,6}.TMDArray = a.TMDArray;

cst{12,6}.TMLevel = a.TMLevel;
cst{12,6}.TMDLabel = a.TMDLabel;
cst{12,6}.TMDArray = a.TMDArray;
save LIVER_intopt.mat cst ct ; 

% End LIVER
%**************************************



%**************************************
% Begin PROSTATE
load PROSTATE.mat
cst{1,6}.TMLevel = a.TMLevel;
cst{1,6}.TMDLabel = a.TMDLabel;
cst{1,6}.TMDArray = a.TMDArray;

cst{2,6}.TMLevel = a.TMLevel;
cst{2,6}.TMDLabel = a.TMDLabel;
cst{2,6}.TMDArray = a.TMDArray;

cst{5,6}.TMLevel = a.TMLevel;
cst{5,6}.TMDLabel = a.TMDLabel;
cst{5,6}.TMDArray = a.TMDArray;

cst{6,6}.TMLevel = a.TMLevel;
cst{6,6}.TMDLabel = a.TMDLabel;
cst{6,6}.TMDArray = a.TMDArray;

cst{8,6}.TMLevel = a.TMLevel;
cst{8,6}.TMDLabel = a.TMDLabel;
cst{8,6}.TMDArray = a.TMDArray;

save PROSTATE_intopt.mat cst ct ; 

% End PROSTATE
%**************************************



%**************************************
% Begin TG119
load TG119.mat
cst{1,6}.TMLevel = a.TMLevel;
cst{1,6}.TMDLabel = a.TMDLabel;
cst{1,6}.TMDArray = a.TMDArray;

cst{2,6}.TMLevel = a.TMLevel;
cst{2,6}.TMDLabel = a.TMDLabel;
cst{2,6}.TMDArray = a.TMDArray;

cst{3,6}.TMLevel = a.TMLevel;
cst{3,6}.TMDLabel = a.TMDLabel;
cst{3,6}.TMDArray = a.TMDArray;

save TG119_intopt.mat cst ct ; 

% End TG119
%**************************************










