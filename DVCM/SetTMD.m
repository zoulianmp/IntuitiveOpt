function  SetTMD(structName,tmdIndex,TMD)
%UNTITLED7 Summary of this function goes here
%  Set the TMD Structure by structure name and tmd Index
%  If the TMD Exist: update the tmdarray 
%  If the TMD is New: add the tmd to tmdarray

global intOptParameters  

%find the target
for i=1:numel(intOptParameters.targetSet)
    label = intOptParameters.targetSet(i).label;

    if strcmp(structName,label)
      
       tmdarray =  intOptParameters.targetSet(i).TMDArray;
       
       for j = 1:numel(tmdarray)
                   
           if tmdIndex == tmdarray{j}.TMDindex
               
               intOptParameters.targetSet(i).TMDArray{j} = TMD;      
               
               return 
           end
           
       end 
       
       intOptParameters.targetSet(i).TMDArray{numel(tmdarray) +1 } = TMD;      
       
    end    
    
    
end


%find the oar
for i=1:numel(intOptParameters.oarSet)
    label = intOptParameters.oarSet(i).label;

    if strcmp(structName,label)
       tmdarray =  intOptParameters.oarSet(i).TMDArray;
     
       for j = 1:numel(tmdarray)
         if tmdIndex == tmdarray{j}.TMDindex
              intOptParameters.oarSet(i).TMDArray{j} = TMD;  
               return 
         end
       end 
       
       intOptParameters.oarSet(i).TMDArray{numel(tmdarray) +1 } = TMD; 
    end   
    
    
end
