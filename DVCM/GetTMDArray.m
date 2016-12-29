function TMDArray = GetTMDArray(structName)
%UNTITLED7 Summary of this function goes here
%  Get the TMDArray Structure by structure name
% structName: string type


global intOptParameters 

%find the target
for i=1:numel(intOptParameters.targetSet)
    label = intOptParameters.targetSet(i).label;

    if strcmp(structName,label)
      
         if isfield(intOptParameters.targetSet(i), 'TMDArray')
               
             TMDArray =  intOptParameters.targetSet(i).TMDArray;
         else
              TMDArray = [];

         end
         return;

    end    
    
    
end


%find the oar
for i=1:numel(intOptParameters.oarSet)
    label = intOptParameters.oarSet(i).label;

    if strcmp(structName,label)
        
         if isfield(intOptParameters.oarSet(i), 'TMDArray')        
             TMDArray =  intOptParameters.oarSet(i).TMDArray;
         else
             TMDArray = [];

         end 
         return;
     
    end   
    
end

TMD = [];





