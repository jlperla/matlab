% cls_rJ.m
%
% function r_k=cls_rJ(x_k, Prob)
%
% cls_rJ combined with cls_Jr implements efficient handling of
% simulataneous residual r and Jacobian J computation in Tomlab
%
% The residual r_k is returned
% The Jacobian J_k is set in the standard TOmlab global variable LS_J
% Global variable LS_xJ stores the x_k value used to compute J_k
% Global counter n_J is incremented
%

% Kenneth Holmstrom, Tomlab Optimization Inc, E-mail: tomlab@tomopt.com
% Copyright (c) 2016-2016 by Tomlab Optimization Inc., $Release: 8.0.0$
% Written Feb 8, 2016.    Last modified Feb 9, 2016.

function r_k=cls_rJ(x_k, Prob, varargin)

global LS_xJ LS_J n_J


% Call the user routine to compute r_k and J_k
[r_k,J_k]   = feval(Prob.USER.SimrJ, x_k, Prob, varargin{:});

% Set global variables used by Tomlab Jacobian routines
LS_xJ       = x_k(:);
LS_J        = J_k;
n_J         = n_J+1;


% MODIFICATION LOG:
%
% 160209  hkh  Written
