global intOptParameters;
dim = intOptParameters.numOfBixels;
%%% *******************************************
%%% Here begins the cvx model
cvx_begin
cvx_solver Mosek  %specifies Mosek as the solver. Please comment out this line when Mosek is not available
cvx_precision high
%%% WV is the vector of beamlet intensities
expression WV(1610)
%%%Dummy expression hodlers to help calculate the truncated means
%%% Target dummy expression:
expression z3(2,7429)
%%% OAR dummy expressions:

%%%Intermedia expression for easier setting contraints 
expression ApertureWeights LLeafPositions RLeafPositions
%% PPP2 measures how much we can shrink the right hand side of the truncated mean constrants
variable PPP2(2);
maximize(sum(PPP2))
subject to
% TM constraints for OuterTarget
  z3(1,:) =  pos( 1.930000-intOptParameters.targetSet(1).influenceM*WV) ;
  sum(z3(1,:))/7429<= 0.106400+0.005800+PPP-PPP2(4)

  z3(2,:) =  pos(intOptParameters.targetSet(1).influenceM*WV-2.000000) ;
  sum(z3(2,:))/7429<= 0.961100+0.013000+PPP-PPP2(5)
% TM constraints for Core
  WV<=4.239946e-01;
WV>=0;
PPP2>=0;
cvx_end 
%%% Here End the cvx model
%%% *******************************************
