function generate_cvx_opt_script(intOptParameters)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% intuitive Optimization cvx model script  creation
%
% call
%   generate_cvx_script(intOptParameters,filename)
%
% input
%   intOptParameters:     structure set with TM Constraints 
%   filenameroot:   the cvx_opt filesname the cvx script name for optimization
%
%
% References
%   
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% cvx opt script head
 
cvx_commonhead = {...
            ['intOptParameters=evalin(''base'',''intOptParameters'');'],...
            ['dim = intOptParameters.numOfBixels;'],...
            ['%%% *******************************************'],...
            ['%%% Here begins the cvx model'],...
            ['cvx_begin'],...
            ['cvx_solver Mosek  %specifies Mosek as the solver. Please comment out this line when Mosek is not available'],...
            ['cvx_precision high'],...
            ['variables WV(dim) %%% WV is the vector of beamlet intensities'],...
            };

cvx_phase1_object = {['%% PPP measures the infeasibility of satisfying the truncated means constraints'],...
                     ['variable PPP']
            };
        
cvx_phase1_dummyVars = getDummyVarsP1(intOptParameters);

filenameroot = intOptParameters.cvxScriptRootName;

currFolder = fileparts(mfilename('fullpath'));
%***************************************
% begin write cvx phase1 script 


phase1name= strcat(filenameroot,'phase1.m');

fullphase1name = fullfile(currFolder,phase1name);

fid1 = fopen(fullphase1name,'wt');

print_script_lines(fid1,cvx_commonhead);

print_script_lines(fid1,cvx_phase1_dummyVars);

print_script_lines(fid1,cvx_phase1_object);
fclose(fid1);


%end write cvx phase1 script
%*****************************************


       
  
%***************************************
% begin write cvx phase2 script 


phase2name= strcat(filenameroot,'phase2.m');

fullphase2name = fullfile(currFolder,phase2name);

fid2 = fopen(fullphase2name,'wt');
print_script_lines(fid2,cvx_commonhead);
fclose(fid2);


%end write cvx phase2 script
%*****************************************



%*****************************************
%Begin Inner function block

%%% Phase 1


function dummyVars = getDummyVarsP1(intOptParameters)

dummyVars{1} =['%%%Dummy variables to help calculate the truncated means'];
targetvars = 'variables';
for i = 1 : length(intOptParameters.targetSet)
   nvoxel =  intOptParameters.targetSet(i).numVoxel;
   dv = sprintf(' z%d(2,%d)',i,nvoxel);
   targetvars = strcat(targetvars,dv);
 
end
dummyVars{2}= targetvars;

oarvars = 'variables';
for i = 1 : length(intOptParameters.oarSet)
   nvoxel =  intOptParameters.oarSet(i).numVoxel;
   dv = sprintf(' z%d(2,%d)',i,nvoxel);
   oarvars = strcat(oarvars,dv);
 
end
dummyVars{3}= oarvars;




function targetConstraints = getTargetTMConstraintsP1(targetSet)
% targetArray: target TM Constraints data from cst{2,6}










function oarConstraints = getOARTMConstraintsP1(oarSet)
% oarArray: OAR TM Constraints data from cst{2,6}













%%% Phase 2
function targetConstraints = getTargetTMConstraintsP2(targetSet)
% targetArray: target TM Constraints data from cst{2,6}










function oarConstraints = getOARTMConstraintsP2(oarSet)
% oarArray: OAR TM Constraints data from cst{2,6}









function print_script_lines(fid,stringcell)
% fid :the handle of opened file,
% stringcell: the string  cellarray

for i = 1 : length(stringcell)
  fprintf(fid,'%s\n',stringcell{i});
end

    



%end Inner function block
%*****************************************




