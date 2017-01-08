global intOptParameters;
dim = intOptParameters.numOfBixels;
%%% *******************************************
%%% Here begins the cvx model
cvx_begin
cvx_solver Mosek  %specifies Mosek as the solver. Please comment out this line when Mosek is not available
cvx_precision high
%%%DAO Variables needed to be optimized
%%% Left Leaves Position Array Per Beam
variables LLeafPositions1(20,15) LLeafPositions2(20,15) LLeafPositions3(20,15) LLeafPositions4(20,15) LLeafPositions5(20,15)
%%% Right Leaves Position Array Per Beam
variables RLeafPositions1(20,15) RLeafPositions2(20,15) RLeafPositions3(20,15) RLeafPositions4(20,15) RLeafPositions5(20,15)
%%% ApertureWeights For Beams
variables ApertureWeights1(15) ApertureWeights2(15) ApertureWeights3(15) ApertureWeights4(15) ApertureWeights5(15)
%%% WV is the vector of beamlet intensities
expression WV(1610)
%%%Dummy expression hodlers to help calculate the truncated means
%%% Target dummy expression:
expression z3(2,7429)
%%% OAR dummy expressions:

%%%Intermedia expression for easier setting contraints 
expression ApertureWeights LLeafPositions RLeafPositions
%% PPP measures the infeasibility of satisfying the truncated means constraints
variable PPP
minimize(PPP)
subject to
fitShape1 = intOptParameters.fitShapes{1};
for apertureindex = 1:15
    for leafindex = 1:20
         nleafBixels = fitShape1.indexEndX(leafindex) - fitShape1.indexEndX(leafindex)
         x1 = LLeafPositions1(leafindex,apertureindex);
         x2 = RLeafPositions1(leafindex,apertureindex);
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
