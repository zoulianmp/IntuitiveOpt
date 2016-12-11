
function addTMSetToMatRadSampleData(fullfilename)
%%% fullfilename  the full name include path and name.

[pathstr,name,ext] = fileparts(fullfilename) ;



load(fullfilename);

for i=1:size(cst,1)
    % for Target
    if not( isempty (cst{i,6}) )
        %%% The Default TMDStruct values
        TMDStruct.doseValue = 20;
        TMDStruct.direction = 'U'; % The U: UP, L: Low
        TMDStruct.TMDValue = 1.0;
        TMDStruct.TMDRange = 0.05;
        
        cst{i,6}.TMDArray(1) = TMDStruct;
    
    end
end

newfilename = strcat(name,'_intopt',ext);

intopsampe =  fullfile(pathstr,newfilename);

save(intopsampe, 'cst','ct') ; 

end 
