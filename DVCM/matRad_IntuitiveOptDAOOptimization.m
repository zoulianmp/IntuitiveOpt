function [resultIntuitiveOptGUI,infoIntuitiveOpt] = matRad_IntuitiveOptDAOOptimization(dij,cst)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% matRad Intuitive Optimization inverse planning wrapper function
% 
% call
%    [resultIntuitiveOptGUI,infoIntuitiveOpt] = matRad_IntuitiveOptDAOOptimization(dij,cst)
%
% input
%   dij:        matRad dij struct
%   cst:        matRad cst struct
%
% output
%   resultIntuitiveOptGUI:  struct containing optimized fluence vector, dose, and (for
%                           biological optimization) RBE-weighted dose etc.
%   infoIntuitiveOpt:       struct containing information about optimization
%
% References
%   -
%
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

%%% Prepare the data for generate cvx opt scripts
global intOptParameters;

%get the intOpt Parameters place out of the function body
%intOptParameters = getIntuitiveOptParameters(cst,dij);

%generate the cvx opt scripts for DVCM
generate_cvx_opt_dao_script(intOptParameters);


%%%********************
% cvx optimization
cvx_opt_dao_phase1;

% saves the output values to file TTPvalue1
%save TTPvalue1.mat  WV PPP


%cvx_opt_dao_phase2;
% saves the output values to file TTPvalue1
%save TTPvalue2.mat  WV


%Assigne the WV result to wOpt
wOpt = WV;


% calc dose and reshape from 1D vector to 2D array
fprintf('Calculating final cubes...\n');
resultGUI = matRad_calcCubes(wOpt,dij,cst);
resultGUI.wUnsequenced = wOpt;


resultIntuitiveOptGUI = resultGUI;



