load TG119_intopt_ready.mat;

global intOptParameters;
dim = intOptParameters.numOfBixels;

%% the prescribed total Aperture Numbers
preScribedTotalApertures = 85 ;

%% the beam weight to get the numer aptures per beam
beamAW = ones(1,pln.numOfBeams);

%%The real Apertures number assgined to beams
beamApertures = round( 85*(beamAW/sum(beamAW)));

realTotalApertures = sum(beamApertures);

%% 最终所有的射野都会转换为一个向量： WV(dim) %%% WV is the vector of beamlet intensities
%% 
%**************
%%AptureInfo.Weight = 
%%AptureInfo.LLeafPosition =  
%%AptureInfo.RLeafPosition =  
%%AptureInfo.BeamRange = {}
%%                 .nleaves         MLC Leaves number involved
%%                 .ncolumn       MLC Position range bixels number
%%                 .indexBegin    在WV(dim)中的index
%%                 .indexEnd      在WV(dim)中的index
%%                 .x1Border      BeamRange x1 border
%%AptureInfo.StartLeafIndex = []  each beam has a indivadial start leaf  index
%%


numLeaves1 = 20;
numBixels1 = 129;

%%%%%%%%%%%%%%%%%%%%%%%%%
%%BeamBixel1 = 297; each beam has the fixed number BeamBixels,and can
%%determine the leaf numbers and start leaf index. 

%%% *******************************************
%%% Here begins the cvx model
cvx_begin
cvx_solver Mosek  %specifies Mosek as the solver. Please comment out this line when Mosek is not available
cvx_precision high






variable ApertureWeight(realTotalApertures)

%%每个beam的覆盖范围是不一样的，所以变量后面数字表示Beam的编号
variables LLeafPosition1(numLeaves1) RLeafPosition1(numLeaves1) 

expression WV(dim) %%% WV is the vector of beamlet intensities
%%%Dummy expression hodlers to help calculate the truncated means
%%% Target dummy expression:
expression z3(2,7429)
%%% OAR dummy expressions:

%% PPP measures the infeasibility of satisfying the truncated means constraints
variable PPP
minimize(PPP)
subject to

%% dynamic generate the WV for optimization
% iteration of Beams

    apertureIndex = 1;
    for beamindex = 1: totalBeam
        beamWV = zeros(1,numBixels);
        for apertureindex = 1:numApertures
            for leafindex = 1:nleaves
                
                x1 = LLeafPosition1(leafindex);     
                x2 = RLeafPosition1(leafindex);
                
                % x1Border
                i = ceil( (x1 - x1Border)/bixelWidth );
                
                weightI =apertureWeight* ((i* bixelWidth) - (x1 - x1Border))/bixelWidth;
                beamWV (i) = beamWV (i) + weightI;
                
                j = floor( (x2 - x1Border)/bixelWidth );
                weightjp = apertureWeight* ( (x2 - x1Border) - (j* bixelWidth))/bixelWidth;
                
                if j +1 <= ncolumn
                   beamWV (j+1) = beamWV (j+1) + weightjp;
                end
                
                beamWV (i+1: j) =   beamWV (i+1: j) + apertureWeight; 
 
            end
        end
        
              WV(indexBegin:indexEnd) =  beamWV;
    end


  % TM constraints for OuterTarget
  z3(1,:) =  pos( 1.930000-intOptParameters.targetSet(1).influenceM*WV) ;
  sum(z3(1,:))/7429<= 0.156400+0.058000+PPP

  z3(2,:) =  pos(intOptParameters.targetSet(1).influenceM*WV-2.000000) ;
  sum(z3(2,:))/7429<= 1.200000+0.130000+PPP
  % TM constraints for Core
  
  
  % Physical Contraints
  -20 <= LLeafPosition1 <= 20;
  -20 <= RLeafPosition1 <= 20;
  
  LLeafPosition1 <= RLeafPosition1;
  ApertureWeight >= 0;
  
  PPP>=0;
cvx_end 
%%% Here End the cvx model
%%% *******************************************
