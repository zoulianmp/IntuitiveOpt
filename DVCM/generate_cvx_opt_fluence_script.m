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




% cvx opt script blocks
 
cvx_commonhead = {...
            ['global intOptParameters;'],...
            ['dim = intOptParameters.numOfBixels;'],...
            ['%%% *******************************************'],...
            ['%%% Here begins the cvx model'],...
            ['cvx_begin'],...
            ['cvx_solver Mosek  %specifies Mosek as the solver. Please comment out this line when Mosek is not available'],...
            ['cvx_precision high'],...
            ['variables WV(dim) %%% WV is the vector of beamlet intensities'],...
            };
        
%********************************
%Begin cvx phase1 blocks        
cvx_phase1_object = {['%% PPP measures the infeasibility of satisfying the truncated means constraints'],...
                     ['variable PPP'],...
                     ['minimize(PPP)'],...
                     ['subject to'],...
            };
        
cvx_phase1_dummyExpression = getDummyExpressionP1(intOptParameters);

cvx_phase1_targetConstraints = getTargetTMConstraintsP1(intOptParameters.targetSet);



    

cvx_phase1_oarConstraints =  getOARTMConstraintsP1(intOptParameters.oarSet);

%wvstr = sprintf('  WV<=%d;',intOptParameters.intensityMax );


cvx_phase1_footer = {...
                  %   [wvstr],...
                     ['  WV>=0;'],...
                     ['  PPP>=0;'],...
                     ['cvx_end '],...            
                     ['%%% Here End the cvx model'],...
                     ['%%% *******************************************'],...
                     };

%cvx_phase1_save_result = {...
%                     ['% saves the output values to file TTPvalue1'],...
%                     ['save TTPvalue1.mat  WV PPP' ],...
%                     };
                 
                 
                 
                 
%********************************
%Begin cvx phase2 blocks     

p2_str1 = sprintf('variable PPP2(%d);',intOptParameters.totalTM );

cvx_phase2_object = {['%% PPP2 measures how much we can shrink the right hand side of the truncated mean constrants'],...
                     [p2_str1],...
                     ['maximize(sum(PPP2))'],... 
                     ['subject to'],...
                     
            };

cvx_phase2_dummyExpression = getDummyExpressionP1(intOptParameters);


cvx_phase2_targetConstraints = getTargetTMConstraintsP2(intOptParameters.targetSet);

cvx_phase2_oarConstraints =  getOARTMConstraintsP2(intOptParameters.oarSet);



cvx_phase2_footer = {...
                     [wvstr],...
                     ['WV>=0;'],...
                     ['PPP2>=0;'],...
                     ['cvx_end '],...            
                     ['%%% Here End the cvx model'],...
                     ['%%% *******************************************'],...
                     };


%cvx_phase2_save_result = {...
%                     ['% saves the output values to file TTPvalue2'],...
%                     ['save TTPvalue2.mat  WV' ],...
%                     };
                 
%End cvx phase2 blocks         
%********************************






%End cvx phase2 blocks         
%********************************



filenameroot = strcat(intOptParameters.cvxScriptRootName,'_fluence_');

currFolder = fileparts(mfilename('fullpath'));
%***************************************
% begin write cvx phase1 script 


phase1name= strcat(filenameroot,'phase1.m');

fullphase1name = fullfile(currFolder,phase1name);

fid1 = fopen(fullphase1name,'wt');

print_script_lines(fid1,cvx_commonhead);

print_script_lines(fid1,cvx_phase1_dummyExpression);

print_script_lines(fid1,cvx_phase1_object);

print_script_lines(fid1,cvx_phase1_targetConstraints);

print_script_lines(fid1,cvx_phase1_oarConstraints);


print_script_lines(fid1,cvx_phase1_footer);

%print_script_lines(fid1,cvx_phase1_save_result);

fclose(fid1);


%end write cvx phase1 script
%*****************************************


       
  
%***************************************
% begin write cvx phase2 script 


phase2name= strcat(filenameroot,'phase2.m');

fullphase2name = fullfile(currFolder,phase2name);

fid2 = fopen(fullphase2name,'wt');
print_script_lines(fid2,cvx_commonhead);

print_script_lines(fid2,cvx_phase2_dummyExpression);

print_script_lines(fid2,cvx_phase2_object);

print_script_lines(fid2,cvx_phase2_targetConstraints);

print_script_lines(fid2,cvx_phase2_oarConstraints);


print_script_lines(fid2,cvx_phase2_footer);

%print_script_lines(fid2,cvx_phase2_save_result);


fclose(fid2);


%end write cvx phase2 script
%*****************************************



%*****************************************
%Begin Inner function block

%%% Phase 1


function dummyExpression = getDummyExpressionP1(intOptParameters)

dummyExpression{1} =['%%%Dummy expression hodlers to help calculate the truncated means'];
dummyExpression{2} =['%%% Target dummy expression:'];

nvars_t = 0;
dummyvars = '';

for i = 1 : length(intOptParameters.targetSet)
   nvoxel =  intOptParameters.targetSet(i).numVoxel;
       
   if ~isfield(intOptParameters.targetSet(i), 'TMDArray')
        continue;                              
   end
     
   nTMD = numel(intOptParameters.targetSet(i).TMDArray);
   dummyIndex = intOptParameters.targetSet(i).index;
   
   dv = sprintf(' z%d(%d,%d)',dummyIndex,nTMD,nvoxel);
   dummyvars = strcat(dummyvars,dv);
    
   nvars_t = nvars_t +1;
end

if nvars_t ==  1
    targetvars = 'expression';
elseif  nvars_t ==  0
    targetvars = '';   
elseif nvars_t >1
    targetvars = 'expressions';
end

targetvars = strcat(targetvars,dummyvars);

dummyExpression{3}= targetvars;
%******************************************************
dummyExpression{4}= ['%%% OAR dummy expressions:'];

nvars_o = 0;
dummyvars = '';

for i = 1 : length(intOptParameters.oarSet)
   nvoxel =  intOptParameters.oarSet(i).numVoxel; 
      
   if ~isfield(intOptParameters.oarSet(i), 'TMDArray')
        continue;                                  
   end
   
   nTMD = numel(intOptParameters.oarSet(i).TMDArray);
   dummyIndex = intOptParameters.oarSet(i).index;  
   
   dv = sprintf(' z%d(%d,%d)',dummyIndex,nTMD,nvoxel);
   dummyvars = strcat(dummyvars,dv);
   
   nvars_o = nvars_o + 1;
  
end


if nvars_o ==  1
    oarvars = 'expression';
elseif  nvars_o ==  0
    oarvars = '';   
elseif nvars_o >1
    oarvars = 'expressions';
end


oarvars = strcat(oarvars,dummyvars);

dummyExpression{5}= oarvars;

function targetConstraints = getTargetTMConstraintsP1(targetSet)
% targetArray: target TM Constraints data from cst{2,6}

targetConstraints = {};
lineIndex = 1;

for i = 1 : length(targetSet)
    target = targetSet(i);
    
    targetNote =  sprintf('  %% TM constraints for %s',target.label);
    targetConstraints{lineIndex} = targetNote;
    
    if ~isfield(target, 'TMDArray')
        continue;                              
    end
    tmdArray = target.TMDArray;
    
    for j= 1 : numel(tmdArray)
       innerIndex = lineIndex + (j-1)*3;
       
       tmd = tmdArray{j};
       
       if strcmp(tmd.direction,'U')
           tmdstr1 =  sprintf('  z%d(%d,:) =  pos(intOptParameters.targetSet(%d).influenceM*WV-%f) ;',target.index,j,i,tmd.doseValue);   
       elseif strcmp(tmd.direction,'L')
           tmdstr1 =  sprintf('  z%d(%d,:) =  pos( %f-intOptParameters.targetSet(%d).influenceM*WV) ;',target.index,j,tmd.doseValue,i);   
       end
       
       targetConstraints{innerIndex +1} = tmdstr1;
            
       tmdstr2 = sprintf('  sum(z%d(%d,:))/%d<= %f+%f+PPP',target.index,j,target.numVoxel,tmd.TMDValue,tmd.TMDRange);
       targetConstraints{innerIndex +2} = tmdstr2;
        
    end
    lineIndex = lineIndex + numel(tmdArray)*3;
    
end

function oarConstraints = getOARTMConstraintsP1(oarSet)
% oarArray: OAR TM Constraints data from cst{2,6}

oarConstraints = {};
lineIndex = 1;

for i = 1 : length(oarSet)
    oar = oarSet(i);
    
    oarNote =  sprintf('  %% TM constraints for %s',oar.label);
    oarConstraints{lineIndex} = oarNote;
    if ~isfield(oar, 'TMDArray')
        continue;                              
    end
    
    tmdArray = oar.TMDArray;
    
    for j= 1 : numel(tmdArray)
       innerIndex = lineIndex + (j-1)*3;
       
       tmd = tmdArray{j};
       
       
        
       if strcmp(tmd.direction,'U')
           tmdstr1 =  sprintf('  z%d(%d,:) =  pos(intOptParameters.targetSet(%d).influenceM*WV-%f) ;',oar.index,j,i,tmd.doseValue);   
       elseif strcmp(tmd.direction,'L')
           tmdstr1 =  sprintf('  z%d(%d,:) =  pos( %f-intOptParameters.targetSet(%d).influenceM*WV) ;',oar.index,j,tmd.doseValue,i);   
       end
       

       oarConstraints{innerIndex +1} = tmdstr1;

       
       tmdstr2 = sprintf('  sum(z%d(%d,:))/%d<= %f+%f+PPP',oar.index,j,oar.numVoxel,tmd.TMDValue,tmd.TMDRange);
       oarConstraints{innerIndex +2} = tmdstr2;
        
    end
    lineIndex = lineIndex + numel(tmdArray)*3+1;
    
end


%%% Phase 2
function targetConstraints = getTargetTMConstraintsP2(targetSet)
% targetArray: target TM Constraints data from cst{2,6}

targetConstraints = {};
lineIndex = 1;

for i = 1 : length(targetSet)
    target = targetSet(i);
    
    targetNote =  sprintf('%% TM constraints for %s',target.label);
    targetConstraints{lineIndex} = targetNote;
    
    if ~isfield(target, 'TMDArray')
        continue;                              
    end
    tmdArray = target.TMDArray;
    
    for j= 1 : numel(tmdArray)
       innerIndex = lineIndex + (j-1)*3;
       
       tmd = tmdArray{j};
       
       
       if strcmp(tmd.direction,'U')
           tmdstr1 =  sprintf('  z%d(%d,:) =  pos(intOptParameters.targetSet(%d).influenceM*WV-%f) ;',target.index,j,i,tmd.doseValue);   
       elseif strcmp(tmd.direction,'L')
           tmdstr1 =  sprintf('  z%d(%d,:) =  pos( %f-intOptParameters.targetSet(%d).influenceM*WV) ;',target.index,j,tmd.doseValue,i);   
       end

       targetConstraints{innerIndex +1} = tmdstr1;
       
       tmdstr2 = sprintf('  sum(z%d(%d,:))/%d<= %f+%f+PPP-PPP2(%d)',target.index,j,target.numVoxel,tmd.TMDValue,tmd.TMDRange,tmd.TMDindex);
       targetConstraints{innerIndex +2} = tmdstr2;
        
    end
    lineIndex = lineIndex + numel(tmdArray)*3;
    
end


function oarConstraints = getOARTMConstraintsP2(oarSet)
% oarArray: OAR TM Constraints data from cst{2,6}

oarConstraints = {};
lineIndex = 1;

for i = 1 : length(oarSet)
    oar = oarSet(i);
    
    oarNote =  sprintf('%% TM constraints for %s',oar.label);
    oarConstraints{lineIndex} = oarNote;
    
        
    if ~isfield(oar, 'TMDArray')
        continue;                              
    end
    
    tmdArray = oar.TMDArray;
    
    for j= 1 : numel(tmdArray)
       innerIndex = lineIndex + (j-1)*3;
       
       tmd = tmdArray{j};
       
       
       if strcmp(tmd.direction,'U')
           tmdstr1 =  sprintf('  z%d(%d,:) =  pos(intOptParameters.targetSet(%d).influenceM*WV-%f) ;',oar.index,j,i,tmd.doseValue);   
       elseif strcmp(tmd.direction,'L')
           tmdstr1 =  sprintf('  z%d(%d,:) =  pos( %f-intOptParameters.targetSet(%d).influenceM*WV) ;',oar.index,j,tmd.doseValue,i);   
       end
             
       oarConstraints{innerIndex +1} = tmdstr1;
             
       tmdstr = sprintf('  sum(z%d(%d,:))/%d<= %f+%f+PPP-PPP2(%d)',oar.index,j,oar.numVoxel,tmd.TMDValue,tmd.TMDRange,tmd.TMDindex);
       oarConstraints{innerIndex +2} = tmdstr2;
        
    end
    lineIndex = lineIndex + numel(tmdArray)*3+1;
    
end



function print_script_lines(fid,stringcell)
% fid :the handle of opened file,
% stringcell: the string  cellarray

for i = 1 : length(stringcell)
  fprintf(fid,'%s\n',stringcell{i});
end

    



%end Inner function block
%*****************************************




