%%% *******************************************
%%% Here begins the cvx model
cvx_begin
cvx_solver Mosek  %specifies Mosek as the solver. Please comment out this line when Mosek is not available
cvx_precision high
variables WV(dim) %%% WV is the vector of beamlet intensities
%% PPP measures the infeasibility of satisfying the truncated means constraints
variable PPP
