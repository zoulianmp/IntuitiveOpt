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
variables z1(1,599440) z2(1,1280)
%% PPP2 measures how much we can shrink the right hand side of the truncated mean constrants
variable PPP2(4);
maximize(sum(PPP2))
% TM constraints for OuterTarget
1.930000-intOptParameters.targetSet(1).influenceM*WV<=z3(1,:)';
z3(1,:)>=0;
sum(z3(1,:))/7429<= 0.106400+0.005800+PPP-PPP2(4)
intOptParameters.targetSet(1).influenceM*WV-2.000000<=z3(2,:)';
z3(2,:)>=0;
sum(z3(2,:))/7429<= 0.961100+0.013000+PPP-PPP2(5)
% TM constraints for BODY
intOptParameters.oarSet(1).influenceM*WV-20.000000<=z1(1,:)';
z1(1,:)>=0;
sum(z1(1,:))/599440<= 1.000000+0.050000+PPP-PPP2(1)
% TM constraints for Core
intOptParameters.oarSet(2).influenceM*WV-20.000000<=z2(1,:)';
z2(1,:)>=0;
sum(z2(1,:))/1280<= 1.000000+0.050000+PPP-PPP2(2)
WV<=7.928591e-01;
WV>=0;
PPP2>=0;
cvx_end 
%%% Here End the cvx model
%%% *******************************************
