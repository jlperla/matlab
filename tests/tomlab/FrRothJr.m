% FrRothJr.m
%
% Freudenstein and Roth [MoreGH #2] test problem (mgh_prob no 2)
%
% Computing both r and J
%
% function [r,J] = FrRothJr(x, Prob,varargin)
%

% Kenneth Holmstrom, Tomlab Optimization Inc, E-mail: tomlab@tomopt.com
% Copyright (c) 2016-2016 by Tomlab Optimization Inc., $Release: 8.0.0$
% Written Feb 9, 2016.    Last modified Feb 9, 2016.
%

function [r,J] = FrRothJr(x, Prob,varargin)

% Freudenstein and Roth [More G H #2]
r    = zeros(2,1);
r(1) = -13 + x(1) + ((5 - x(2))*x(2) - 2)*x(2);
r(2) = -29 + x(1) + (( x(2) + 1)*x(2) - 14)*x(2);

J      = zeros(2,2);
J(1,1) = 1;
J(2,1) = 1;
J(1,2) = (10 - 3*x(2))*x(2) - 2;
J(2,2) = (3*x(2) + 2)*x(2) - 14;


% MODIFICATION LOG:
%
% 160209  hkh  Written

