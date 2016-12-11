%%% Script for preparing sample date for Intuitive Opt, add TMD datas 


currFolder = fileparts(mfilename('fullpath'));

sampleDataFolder = strcat(currFolder,'\..');

%***************************************


%**************************************
% Begin BOXPHANTOM

fulldataname = fullfile(sampleDataFolder,'BOXPHANTOM.mat');
addTMSetToMatRadSampleData(fulldataname);

% End BOXPHANTOM
%**************************************

%**************************************
% Begin HEAD_AND_NECK
fulldataname = fullfile(sampleDataFolder,'HEAD_AND_NECK.mat');
addTMSetToMatRadSampleData(fulldataname); 
 

% End HEAD_AND_NECK
%**************************************


%**************************************
% Begin LIVER
fulldataname = fullfile(sampleDataFolder,'LIVER.mat');

addTMSetToMatRadSampleData(fulldataname);


% End LIVER
%**************************************



%**************************************
% Begin PROSTATE
fulldataname = fullfile(sampleDataFolder,'PROSTATE.mat');
addTMSetToMatRadSampleData(fulldataname);

% End PROSTATE
%**************************************



%**************************************
% Begin TG119
fulldataname = fullfile(sampleDataFolder,'TG119.mat');
addTMSetToMatRadSampleData(fulldataname);

% End TG119
%**************************************



