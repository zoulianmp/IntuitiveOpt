intOptParameters=evalin('base','intOptParameters');
dim = intOptParameters.numOfBixels;
%%% *******************************************
%%% Here begins the cvx model
cvx_begin
cvx_solver Mosek  %specifies Mosek as the solver. Please comment out this line when Mosek is not available
cvx_precision high
variables WV(dim) %%% WV is the vector of beamlet intensities
%%%Dummy variables to help calculate the truncated means
%%% Target dummy variables:
variables z3(2,7429)
%%% OAR dummy variables:
variables z1(1,599440) z2(2,1280)
%% PPP2 measures how much we can shrink the right hand side of the truncated mean constrants
variable PPP2(5);
maximize(sum(PPP2))
% TM constraints for OuterTarget
24.000000-intOptParameters.targetSet(1).influenceM*WV<=z3(1,:)';
z3(1,:)>=0;
sum(z3(1,:))/7429<= 0.200000+0.005800+PPP-PPP2(4)
intOptParameters.targetSet(1).influenceM*WV-25.300000<=z3(2,:)';
z3(2,:)>=0;
sum(z3(2,:))/7429<= 0.080000+0.006300+PPP-PPP2(5)
% TM constraints for BODY
intOptParameters.oarSet(1).influenceM*WV-19.200000<=z1(1,:)';
z1(1,:)>=0;
sum(z1(1,:))/599440<= 0.000000+0.000000+PPP-PPP2(1)
% TM constraints for Core
intOptParameters.oarSet(2).influenceM*WV-6.000000<=z2(1,:)';
z2(1,:)>=0;
sum(z2(1,:))/1280<= 1.400000+0.020600+PPP-PPP2(2)
intOptParameters.oarSet(2).influenceM*WV-25.300000<=z2(2,:)';
z2(2,:)>=0;
sum(z2(2,:))/1280<= 0.003000+0.000500+PPP-PPP2(3)
WV<=30;
WV>=0;
PPP2>=0;
cvx_end 
%%% Here End the cvx model
%%% *******************************************
% saves the output values to file TTPvalue2
save TTPvalue2.mat  WV
