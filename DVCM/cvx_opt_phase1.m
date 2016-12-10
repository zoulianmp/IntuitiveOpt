intOptParameters=evalin('base','intOptParameters');
dim = intOptParameters.numOfBixels;
%%% *******************************************
%%% Here begins the cvx model
cvx_begin
cvx_solver Mosek  %specifies Mosek as the solver. Please comment out this line when Mosek is not available
cvx_precision high
variables WV(dim) %%% WV is the vector of beamlet intensities
%%%dummy variables to help calculate the truncated means
variables z1(2,7429)
variables z1(2,599440) z2(2,1280)
%% PPP measures the infeasibility of satisfying the truncated means constraints
variable PPP
