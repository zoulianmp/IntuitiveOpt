%%ReindexPrescribedTMDS
%%intOptParameters: the parameter for intuitive Optimization

global intOptParameters

%find the target

tmdindex = 1;


for i=1:numel(intOptParameters.targetSet)
    
    if isfield(intOptParameters.targetSet(i), 'TMDArray')        
        tmdArray =  intOptParameters.targetSet(i).TMDArray;
    else
        tmdArray = [];

    end 


    
    for j=1:numel(tmdArray)       
        
        intOptParameters.targetSet(i).TMDArray{j}.TMDindex = tmdindex;      
        tmdindex = tmdindex + 1;             
  
    end
    
end


%find the oar

for i=1:numel(intOptParameters.oarSet)
    
    if isfield(intOptParameters.oarSet(i), 'TMDArray')        
        tmdArray =  intOptParameters.oarSet(i).TMDArray;
    else
        tmdArray = [];

    end 

    
    for j=1:numel(tmdArray)
        
        intOptParameters.oarSet(i).TMDArray{j}.TMDindex = tmdindex;
        tmdindex = tmdindex + 1;             
  
    end
    
end

intOptParameters.totalTM = tmdindex -1;

