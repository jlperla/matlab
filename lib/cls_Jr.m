% cls_Jr.m.m
%
% function J = cls_Jr.m(x_k, Prob)
%
% cls_Jr combined with cls_rJ implements efficient handling of
% simulataneous residual r and Jacobian J computation in Tomlab
%
% cls_Jr will onlyh be called if x_k is not matching the current value 
% in global variable LS_xJ, i.e. LS_J(x_k) is different from LS_J(LS_xJ)
%
% Therefore call cls_rJ from cls_Jr to compute fresh set (r_k(x_k),J_k(x_k))
%
% If then nlp_r is called to get r_k, the user routine will not be called
% instead r_k = LS_r, the global LS_r value
%
% This routine will set global variables LS_x LS_r and increment counter n_r

% Kenneth Holmstrom, Tomlab Optimization Inc, E-mail: tomlab@tomopt.com
% Copyright (c) 2016-2016 by Tomlab Optimization Inc., $Release: 8.0.0$
% Written Feb 8, 2016.    Last modified Feb 9, 2016.
%
function J_k = cls_Jr(x_k, Prob,varargin)

global LS_xr LS_r n_r

% Call the user routine to compute r_k and J_k
[r_k,J_k]   = feval(Prob.USER.SimrJ, x_k, Prob, varargin{:});

% Set global variables used by Tomlab residual function routines
LS_xr       = x_k(:);
LS_r        = r_k;
n_r         = n_r+1;

% MODIFICATION LOG:
%
% 160209  hkh  Written

