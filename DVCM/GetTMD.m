function TMD = GetTMD(structName,tmdIndex)
%UNTITLED7 Summary of this function goes here
%  Get the TMD Structure by structure name and tmd Index
% tmdIndex : int type 
% structName: string type


global intOptParameters 

%find the target
for i=1:numel(intOptParameters.targetSet)
    label = intOptParameters.targetSet(i).label;

    if strcmp(structName,label)
      
        if ~isfield(intOptParameters.targetSet(i), 'TMDArray')        
            continue;       
        end 
        
        tmdarray =  intOptParameters.targetSet(i).TMDArray;
       
        for j = 1:numel(tmdarray)
                   
            if tmdIndex == tmdarray{j}.TMDindex
                TMD = tmdarray{j};      
                return 
            end
           
        end 

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
          
            if tmdIndex == tmdarray{j}.TMDindex       
                TMD = tmdarray{j};      
                return   
            end  
       end 
    end   
    
    
end

TMD = [];





