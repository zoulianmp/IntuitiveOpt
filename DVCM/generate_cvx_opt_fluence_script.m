function generate_cvx_opt_fluence_script(intOptParameters)
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
                     ['variable PPP'],...
                     ['minimize(PPP)'],
            };
        
cvx_phase1_dummyVars = getDummyVarsP1(intOptParameters);

cvx_phase1_targetConstraints = getTargetTMConstraintsP1(intOptParameters.targetSet);


filenameroot = strcat(intOptParameters.cvxScriptRootName,'_fluence_');

currFolder = fileparts(mfilename('fullpath'));
%***************************************
% begin write cvx phase1 script 


phase1name= strcat(filenameroot,'phase1.m');

fullphase1name = fullfile(currFolder,phase1name);

fid1 = fopen(fullphase1name,'wt');

print_script_lines(fid1,cvx_commonhead);

print_script_lines(fid1,cvx_phase1_dummyVars);

print_script_lines(fid1,cvx_phase1_object);

print_script_lines(fid1,cvx_phase1_targetConstraints);




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
dummyVars{2} =['%%% Target dummy variables:'];
targetvars = 'variables';



for i = 1 : length(intOptParameters.targetSet)
   nvoxel =  intOptParameters.targetSet(i).numVoxel;
   nTMD = numel(intOptParameters.targetSet(i).TMDArray);
   dummyIndex = intOptParameters.targetSet(i).index;
   
   dv = sprintf(' z%d(%d,%d)',dummyIndex,nTMD,nvoxel);
   targetvars = strcat(targetvars,dv);
   dummyIndex = dummyIndex +1;
end
dummyVars{3}= targetvars;

dummyVars{4}= ['%%% OAR dummy variables:'];
oarvars = 'variables';
for i = 1 : length(intOptParameters.oarSet)
   nvoxel =  intOptParameters.oarSet(i).numVoxel;
   
   nTMD = numel(intOptParameters.oarSet(i).TMDArray);
   dummyIndex = intOptParameters.oarSet(i).index;  
   
   dv = sprintf(' z%d(%d,%d)',dummyIndex,nTMD,nvoxel);
   oarvars = strcat(oarvars,dv);
  
end
dummyVars{5}= oarvars;




function targetConstraints = getTargetTMConstraintsP1(targetSet)
% targetArray: target TM Constraints data from cst{2,6}

lineIndex = 1;

for i = 1 : length(targetSet)
    target = targetSet(i);
    
    targetNote =  sprintf('%% TM constraints for %s',target.label);
    targetConstraints{lineIndex} = targetNote;
    
    tmdArray = target.TMDArray;
    
    for j= 1 : numel(tmdArray)
       innerIndex = lineIndex + (j-1)*3;
       
       tmd = tmdArray{j};
       
       if strcmp(tmd.direction,'U')
           tmdstr1 =  sprintf('intOptParameters.targetSet(%d)*WV-%f<=z%d(%d,:)'';',i,tmd.doseValue,target.index,j);   
       elseif strcmp(tmd.direction,'L')
           tmdstr1 =  sprintf('%f-intOptParameters.targetSet(%d)*WV<=z%d(%d,:)'';',tmd.doseValue,i,target.index,j);   
       end
       
       targetConstraints{innerIndex +1} = tmdstr1;
       
       
       tmdstr2 = sprintf('z%d(%d,:)>=0;',target.index,j);
       targetConstraints{innerIndex +2} = tmdstr2;
       
       tmdstr3 = sprintf('sum(z%d(%d,:))/%d<= %f+%f+PPP',target.index,j,target.numVoxel,tmd.TMDValue,tmd.TMDRange);
       targetConstraints{innerIndex +3} = tmdstr3;
        
    end
    lineIndex = lineIndex + numel(tmdArray)*3;
    
end







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




