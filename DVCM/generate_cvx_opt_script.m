function generate_cvx_opt_script(cst,filenameroot)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% intuitive Optimization cvx model script  creation
%
% call
%   generate_cvx_script(cst,filename)
%
% input
%   cst:     structure set with TM Constraints 
%   filenameroot:   the cvx_opt filesname the cvx script name for optimization
%
%
% References
%   
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% cvx opt script head
 
cvx_commonhead = {...
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
        

       
if(isempty(filenameroot))
    filenameroot= 'cvx_opt_';
end


currFolder = fileparts(mfilename('fullpath'));
%***************************************
% begin write cvx phase1 script 


phase1name= strcat(filenameroot,'phase1.m');

fullphase1name = fullfile(currFolder,phase1name);

fid1 = fopen(fullphase1name,'wt');

print_script_lines(fid1,cvx_commonhead);
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

function targetConstraints = getTargetTMConstraints(targetArray)
% targetArray: target TM Constraints data from cst{2,6}






function oarConstraints = getOARTMConstraints(oarArray)
% oarArray: OAR TM Constraints data from cst{2,6}






function print_script_lines(fid,stringcell)
% fid :the handle of opened file,
% stringcell: the string  cellarray

for i = 1 : length(stringcell)
  fprintf(fid,'%s\n',stringcell{i});
end

    



%end Inner function block
%*****************************************




