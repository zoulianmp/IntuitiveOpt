global intOptParameters;
dim = intOptParameters.numOfBixels;


%%% *******************************************
%%% Here begins the cvx model
cvx_begin
cvx_solver Mosek  %specifies Mosek as the solver. Please comment out this line when Mosek is not available
cvx_precision high
%%%DAO Variables needed to be optimized
%%% Left Leaves Position Array Per Beam
variable LLeafPositions1(20,15) integer; 
variable LLeafPositions2(20,15) integer;
variable LLeafPositions3(20,15) integer;
variable LLeafPositions4(20,15) integer;
variable LLeafPositions5(20,15) integer;
%%% Right Leaves Position Array Per Beam
variable RLeafPositions1(20,15) integer;
variable RLeafPositions2(20,15) integer;
variable RLeafPositions3(20,15) integer;
variable RLeafPositions4(20,15) integer;
variable RLeafPositions5(20,15) integer;

%%% ApertureWeights For Beams
variables ApertureWeights1(15) ApertureWeights2(15) ApertureWeights3(15) ApertureWeights4(15) ApertureWeights5(15);
%%% WV is the vector of beamlet intensities
expression WV(1610);
%%%Dummy expression hodlers to help calculate the truncated means
%%% Target dummy expression:
expression z3(2,7429);
%%% OAR dummy expressions:

%% PPP measures the infeasibility of satisfying the truncated means constraints
variable PPP
minimize(PPP)
subject to
  %************************Begin of Beam 1  WV Calculation
  fitShape1 = intOptParameters.fitShapes{1};
  BeamWV1 = zeros(1,351);
  for leafindex = 1:20
       nleafBixels = fitShape1.indexEndX(leafindex) - fitShape1.indexStartX(leafindex)
       leafWV = zeros(1,nleafBixels);
       for apertureindex = 1:15
        
           length = 5* ones(1,nleafBixels);
           cslen = cumsum(length);
           x1 = zeros(1,56);
           x2 = ones(1,5);
           G = cat( 1, RLeafPositions1 , RLeafPositions2);
           
           WV(1) = 2;
           
          % x1 = zeros(1,LLeafPositions1(leafindex,apertureindex));
           x2 = ones(1, RLeafPositions1(leafindex,apertureindex));
         
           
           weightI =ApertureWeights1(apertureindex);
           x2 = weightI * x2;
           
           leafWVAperture = [x1 x2 x1];
          
           
           
          
           if leafindex == 1 
                BeamWV1(1:fitShape1.cumsumIndex(leafindex)) = BeamWV1(1:fitShape1.cumsumIndex(leafindex)) + leafWV;
           else
                BeamWV1(fitShape1.cumsumIndex(leafindex-1)+1:fitShape1.cumsumIndex(leafindex))= BeamWV1(fitShape1.cumsumIndex(leafindex-1)+1:fitShape1.cumsumIndex(leafindex)) + leafWV; 
           end
       end
  end
  %************************End of Beam 1  WV Calculation
  
  WV = [ BeamWV1 BeamWV2 BeamWV3 BeamWV4 BeamWV5];
  % TM constraints for OuterTarget
  z3(1,:) =  pos( 1.930000-intOptParameters.targetSet(1).influenceM*WV) ;
  sum(z3(1,:))/7429<= 0.106400+0.005800+PPP

  z3(2,:) =  pos(intOptParameters.targetSet(1).influenceM*WV-2.000000) ;
  sum(z3(2,:))/7429<= 0.961100+0.013000+PPP
  % TM constraints for Core
  WV<=4.239946e-01;
  WV>=0;
  PPP>=0;
cvx_end 
%%% Here End the cvx model
%%% *******************************************
