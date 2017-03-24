% Test simultaneous computation of residual and Jacobian on 
%      Freudenstein and Roth [MoreGH #2] test problem (mgh_prob no 2)

    Name  ='Freudenstein and Roth [MoreGH #2]';
    x_opt = [5 4; 11.412779 -0.896805];
    f_opt = [0; 24.49212684];
    y     = [0 0]';
    x_0   = [0.5 -2]';
    x_L   = [0 -30]';
    x_U   = [20 -0.9]';
    x_min = [0 -3]';
    x_max = [6  5]';
    x_L   = -inf*ones(length(x_0),1);
    x_U   =  inf*ones(length(x_0),1);


%function Prob = clsAssign(r, J, JacPattern, x_L, x_U, Name, x_0, ...
%                            y, t, weightType, weightY, SepAlg, fLowBnd, ...
%                            A, b_L, b_U, c, dc, ConsPattern, c_L, c_U, ...
%                            x_min, x_max, f_opt, x_opt, ...
%                            IntVars, VarWeight, fIP, xIP);
 
% Use functions cls_rJ and cls_Jr to handle
% simultaneous computation of residual and Jacobian

JacPattern = []; t = []; weightType = []; weightY = [];
SepAlg = []; f_Low = []; A = []; b_L = []; b_U = [];

Prob = clsAssign('cls_rJ','cls_Jr', JacPattern, x_L, x_U, Name, x_0, ...
       y, t, weightType, weightY, SepAlg, f_Low, ...
       A, b_L, b_U, [], [], [], [], [], ...
       x_min, x_max, f_opt, x_opt);
Prob.P          = 2;
% Set user routine that computes r and J: function [r,J] = FrRothJr(x, Prob,varargin)
Prob.USER.SimrJ = 'FrRothJr';
 
%global LS_J LS_xr LS_xJ LS_r
%LS_xr=[]; LS_xJ=[]; LS_r=[]; LS_J=[];

%r=tomRun('clsSolve',Prob,2);
r=tomRun('nlssol',Prob,2);
r=tomRun('snopt',Prob,2);



