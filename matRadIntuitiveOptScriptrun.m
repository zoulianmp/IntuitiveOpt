% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% matRad script
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright 2015 the matRad development team. 
% 
% This file is part of the matRad project. It is subject to the license 
% terms in the LICENSE file found in the top-level directory of this 
% distribution and at https://github.com/e0404/matRad/LICENSES.txt. No part 
% of the matRad project, including this file, may be copied, modified, 
% propagated, or distributed except according to the terms contained in the 
% LICENSE file.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
close all
clc

% load patient data, i.e. ct, voi, cst

%load HEAD_AND_NECK_intopt.mat

load TG119_intopt_ready.mat


%load PROSTATE_intopt.mat
%load LIVER_intopt.mat
%load BOXPHANTOM_intopt.mat


resultGUI = matRad_IntuitiveOptfluenceOptimization(dij,cst,pln);


% %% sequencing
% if strcmp(pln.radiationMode,'photons') && (pln.runSequencing || pln.runDAO)
%     %resultGUI = matRad_xiaLeafSequencing(resultGUI,stf,dij,5);
%     resultGUI = matRad_engelLeafSequencing(resultGUI,stf,dij,5);
% end
% 
% %% DAO
% if strcmp(pln.radiationMode,'photons') && pln.runDAO
%    resultGUI = matRad_directApertureOptimization(dij,cst,resultGUI.apertureInfo,resultGUI,pln);
%    matRad_visApertureInfo(resultGUI.apertureInfo);
% end
% 
% %% start gui for visualization of result
% matRad_IntuitiveOptGUI
% 
% %% dvh
% matRad_calcDVH(resultGUI,cst,pln)

