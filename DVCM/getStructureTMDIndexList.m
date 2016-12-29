function indexList = getStructureTMDIndexList( structName , intOptParameters )
%UNTITLED6 Summary of this function goes here
% structName : selected structure name 
% intOptParameters : data structure for intuitive Optimization
% indexList :output variable, as string array


indexList = {};

%find the target
for i=1:numel(intOptParameters.targetSet)
    label = intOptParameters.targetSet(i).label;

    if strcmp(structName,label)
      
       if ~isfield(intOptParameters.targetSet(i), 'TMDArray')        
            continue;
       end 
         
       tmdarray =  intOptParameters.targetSet(i).TMDArray;
       
       for j = 1:numel(tmdarray)
           indexList{j} = tmdarray{j}.TMDindex;          
           
       end 

       return;
    end    
    
    
end


%find the oar
for i=1:numel(intOptParameters.oarSet)
    label = intOptParameters.oarSet(i).label;

    if strcmp(structName,label)
         
        if ~isfield(intOptParameters.oarSet(i), 'TMDArray')        
            continue;       
        end 
       
       tmdarray =  intOptParameters.oarSet(i).TMDArray;
     
       for j = 1:numel(tmdarray)
           indexList{j} = tmdarray{j}.TMDindex;               
       end 
       return;
    end   
    
    
end


end

