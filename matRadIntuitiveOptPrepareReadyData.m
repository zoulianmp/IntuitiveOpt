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

clear all
close all
clc

% load patient data, i.e. ct, voi, cst

%load HEAD_AND_NECK.mat
%load TG119.mat
load PROSTATE.mat
%load LIVER.mat
%load BOXPHANTOM.mat

% meta information for treatment plan
pln.isoCenter       = matRad_getIsoCenter(cst,ct,0);
pln.bixelWidth      = 10; % [mm] / also corresponds to lateral spot spacing for particles
pln.gantryAngles    = [0:72:359]; % [°]
pln.couchAngles     = [0 0 0 0 0]; % [°]
pln.numOfBeams      = numel(pln.gantryAngles);
pln.numOfVoxels     = prod(ct.cubeDim);
pln.voxelDimensions = ct.cubeDim;
pln.radiationMode   = 'photons'; % either photons / protons / carbon
pln.bioOptimization = 'none'; % none: physical optimization; effect: effect-based optimization; RBExD: optimization of RBE-weighted dose
pln.numOfFractions  = 30;
pln.runSequencing   = false; % 1/true: run sequencing, 0/false: don't / will be ignored for particles and also triggered by runDAO below
pln.runDAO          = false; % 1/true: run DAO, 0/false: don't / will be ignored for particles
pln.machine         = 'Generic';

% Add new MLC Structure
if pln.runDAO  
    addMLCPhysicalParameters;
    pln.aperturesPerBeam = [15,15,15,15,15];
    pln.totalApertures = sum( pln.aperturesPerBeam);
    
end
%% initial visualization and change objective function settings if desired
%matRad_IntuitiveOptGUI


%% generate steering file
if pln.runDAO  
   % mlc = evalin('base','MLC');
    stf_dao = matRad_generateStfDAO(ct,cst,pln,MLC);
else
    stf = matRad_generateStf(ct,cst,pln);
end


%% dose calculation
if strcmp(pln.radiationMode,'photons')
    if pln.runDAO  
        dij_dao = matRad_calcPhotonDoseDAO(ct,stf_dao,pln,cst,MLC);
    else
        dij = matRad_calcPhotonDose(ct,stf,pln,cst);
    end

    %dij = matRad_calcPhotonDoseVmc(ct,stf,pln,cst);
elseif strcmp(pln.radiationMode,'protons') || strcmp(pln.radiationMode,'carbon')c
    dij = matRad_calcParticleDose(ct,stf,pln,cst);
end

 
%%%******** ******************
% save  the intuitive readyDATA

 if pln.runDAO  
     
        
     %save HEAD_AND_NECK_intopt_ready_dao.mat cst ct dij_dao pln stf_dao MLC

     save TG119_intopt_ready_dao.mat cst ct dij_dao pln stf_dao MLC

        
     %save PROSTATE_intopt_ready_dao.mat cst ct dij_dao pln stf_dao MLC
     %save LIVER_intopt_ready_dao.mat cst ct dij_dao pln stf_dao MLC
     %save BOXPHANTOM_intopt_ready_dao.mat cst ct dij_dao pln stf_dao MLC

 else

    %save HEAD_AND_NECK_intopt_ready.mat cst ct dij pln stf
    %save TG119_intopt_ready.mat cst ct dij pln stf
    save PROSTATE_intopt_ready.mat cst ct dij pln stf
    %save LIVER_intopt_ready.mat cst ct dij pln stf
    %save BOXPHANTOM_intopt_ready.mat cst ct dij pln stf

 end


 fprintf('intopt ready mat saved');
