function [resultIntuitiveOptGUI,infoIntuitiveOpt] = matRad_IntuitiveOptfluenceOptimization(dij,cst,pln)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% matRad Intuitive Optimization inverse planning wrapper function
% 
% call
%    [resultIntuitiveOptGUI,infoIntuitiveOpt] = matRad_IntuitiveOptfluenceOptimization(dij,cst,pln)
%
% input
%   dij:        matRad dij struct
%   cst:        matRad cst struct
%   pln:        matRad pln struct
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

% fine tune the TMDArray for structures in the intuitive Optimization
fineTuneTMDArrayForIntuitiveOpt;

%get the intOpt Parameters
intOptParameters = getIntuitiveOptParameters(cst,stf,dij);

%generate the cvx opt scripts for DVCM
generate_cvx_opt_fluence_script(intOptParameters);


%%%********************
% cvx optimization
cvx_opt_fluence_phase1;

cvx_opt_fluence_phase2;












% Run IPOPT.
[wOpt, info]           = ipopt(wInit,funcs,options);

% calc dose and reshape from 1D vector to 2D array
fprintf('Calculating final cubes...\n');
resultGUI = matRad_calcCubes(wOpt,dij,cst);
resultGUI.wUnsequenced = wOpt;

% unset Key Pressed Callback of Matlab command window
if ~isdeployed
    set(h_cw, 'KeyPressedCallback',' ');
end






