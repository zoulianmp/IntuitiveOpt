function  RemoveTMD(structName,tmdIndex,TMD)
%UNTITLED7 Summary of this function goes here
%  find the TMD Structure by structure name and tmd Index
%  If the TMD Exist: remove the TMD from array

global intOptParameters  

tempTMDArray = {};
tempIndex = 1;

%find the target
for i=1:numel(intOptParameters.targetSet)
    label = intOptParameters.targetSet(i).label;

    if strcmp(structName,label)
      
       tmdarray =  intOptParameters.targetSet(i).TMDArray;
       
       for j = 1:numel(tmdarray)
                   
           if tmdIndex == tmdarray{j}.TMDindex        
               continue;
           end
           
           tempTMDArray{tempIndex} = tmdarray{j};
           
           tempIndex = tempIndex +1;
           
       end 
       
       intOptParameters.targetSet(i).TMDArray = tempTMDArray;        
       return;
       
    end    
    
    
end


%find the oar
for i=1:numel(intOptParameters.oarSet)
    label = intOptParameters.oarSet(i).label;

    if strcmp(structName,label)
       tmdarray =  intOptParameters.oarSet(i).TMDArray;
     
       for j = 1:numel(tmdarray)
                   
           if tmdIndex == tmdarray{j}.TMDindex        
               continue;
           end
           
           tempTMDArray{tempIndex} = tmdarray{j};
           
           tempIndex = tempIndex +1;
           
       end 
       
       intOptParameters.oarSet(i).TMDArray = tempTMDArray; 
       break;
    end   
    
    
end
