%%ReindexPrescribedTMDS
%%intOptParameters: the parameter for intuitive Optimization

global intOptParameters

%find the target

tmdindex = 1;


for i=1:numel(intOptParameters.targetSet)
    tmdArray = intOptParameters.targetSet(i).TMDArray;

    
    for j=1:numel(tmdArray)       
        
        intOptParameters.targetSet(i).TMDArray{j}.TMDindex = tmdindex;      
        tmdindex = tmdindex + 1;             
  
    end
    
end


%find the oar

for i=1:numel(intOptParameters.oarSet)
    tmdArray = intOptParameters.oarSet(i).TMDArray;

    
    for j=1:numel(tmdArray)
        
        intOptParameters.oarSet(i).TMDArray{j}.TMDindex = tmdindex;
        tmdindex = tmdindex + 1;             
  
    end
    
end


