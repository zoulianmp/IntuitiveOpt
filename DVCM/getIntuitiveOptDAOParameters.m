function intOptParameters = getIntuitiveOptDAOParameters(cst,dij,stf,pln)
%%% Generate intuitive OptParameters from matrad data structure
% the data struct from matRad
%cst :
%dij : dij_dao
%mlc : stf_dao
%intOptParameters: Used for intuitive Optimization


tagetIndex = 1;
oarIndex = 1;
uidIndex =1; %Give structure a uid for index
totalTM = 0;

targetSet = [];
oarSet = [];

 for i=1:size(cst,1)
    % for Target
    if strcmp(cst{i,3},'TARGET') &&  not( isempty (cst{i,6}) )

        targetSet(tagetIndex).numVoxel = numel(cst{i,4}{1,1});
        
        targetSet(tagetIndex).label = cst{i,2};
        targetSet(tagetIndex).index = uidIndex;
        
        if isfield(cst{i,6}, 'TMDArray')
            
            targetSet(tagetIndex).TMDArray = cst{i,6}.TMDArray;
            totalTM = totalTM + numel(cst{i,6}.TMDArray);
                
        end
        
        
        targetSet(tagetIndex).influenceM = dij.physicalDose{1,1}(cst{i,4}{1},:);

        tagetIndex = tagetIndex + 1;

        uidIndex = uidIndex +1;
    end

    %for OAR
    if strcmp(cst{i,3},'OAR') &&  not( isempty (cst{i,6}) )
        oarSet(oarIndex).numVoxel = numel(cst{i,4}{1,1});
        
        oarSet(oarIndex).label = cst{i,2};
        
        oarSet(oarIndex).index = uidIndex;
        
        if isfield(cst{i,6}, 'TMDArray')  
            oarSet(oarIndex).TMDArray = cst{i,6}.TMDArray; 
            totalTM = totalTM + numel(cst{i,6}.TMDArray);            
        end
        
        oarSet(oarIndex).influenceM = dij.physicalDose{1,1}(cst{i,4}{1},:);

        oarIndex = oarIndex + 1;
        uidIndex = uidIndex +1;
    end

end

intOptParameters.cvxScriptRootName = 'cvx_opt';
intOptParameters.targetSet = targetSet;
intOptParameters.oarSet = oarSet;

intOptParameters.numOfBixels = dij.totalNumOfBixels;

%the bixel intensity value
intOptParameters.intensityMax = guessIntensityMax(cst,dij,2.0);

%the total number of TM Constraints
intOptParameters.totalTM = totalTM;

%the total apertures distributions
intOptParameters.aperturesPerBeam = pln.aperturesPerBeam ;

%Number of ray per beam for inverse Optimization
intOptParameters.numOfRaysPerBeam = dij.numOfRaysPerBeam ;


intOptParameters.totalApertures =  pln.totalApertures;


%each beam has a fit shape
intOptParameters.fitShapes = {};

for j = 1: size(stf,2)
    intOptParameters.fitShapes{j} = stf(j).fitShape;
    
end



%assign the variable to base space
  assignin('base','intOptParameters',intOptParameters);


function max = guessIntensityMax(cst,dij,fractiondose)
%Guese the IntensityMax of Bixels
%fractiondose: dose value per fraction for target

% find target indices and described dose(s) for weight vector
% initialization
V          = [];

for i=1:size(cst,1)
    if isequal(cst{i,3},'TARGET') && ~isempty(cst{i,6})
        V = [V;cst{i,4}{1}];
        break;
    end
end


wOnes       = ones(dij.totalNumOfBixels,1);
bixelWeight =  fractiondose /(mean(dij.physicalDose{1}(V,:)*wOnes)); 

max  = 1.4 * bixelWeight;




 