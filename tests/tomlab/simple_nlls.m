% $Rev: 89 $
% $Date: 2016-09-17 11:21:10 -0700 (Sat, 17 Sep 2016) $
% $LastChangedBy: jlperla $

% Author: Jesse Perla (c) 2016
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

close all;
clc;
clear settings parameters constraints;
Name='Simple quadratic';
% Nonlinear system is:
% x_1^2 - a_1 = 0
% x_2^2 - a_2 = 0
% subject to
% x_2 = a_2^(1/2) ---> linear constraint to be put into matrix A
% x_1 >= d_1, x_2 >= d_2 ---> linear constraints to be put into bounds

a_1 = 1;
a_2 = 1;
d_1 = -10;
d_2 = -20;
parameters.a_1 = a_1;
parameters.a_2 = a_2;

%b_L <= A x <= b_H, where b_L(i) = b_H(i) for equality constraint.
A = [1 0; 0 1];
%b_L = [-Inf; sqrt(a_2)];
%b_H = [Inf; sqrt(a_2)];
knitro_Inf = 100; %Knitro isn't accepting Infinity
b_L = [-Inf; sqrt(a_2)];
b_H = [Inf; sqrt(a_2)];


%Bounds
x_L = [d_1; d_2];
x_H = [Inf; Inf];

%% Parameters and calling with MAD
x_0 = [2, 3];
% y = zeros(length(x_0),1);
% 
% problem = clsAssign('simple_nlls_system', [], [], [], [], Name, x_0, y, [], [] , [], [], [], A, b_L, b_H, [], [], [], [], [], x_L, x_H);
% problem.ADCons = 1;
% problem.ADObj = 1;
% problem.parameters = parameters;
% problem.KNITRO.options.HESSOPT = 6; %Sparse hessian with BFGS
% 
% 
% %result = tomRun('clsSolve', problem, 1);
% %result = tomRun('knitro', problem, 1);
% result = tomRun('snopt', problem, 1); %Seems to have the lowest number of evaluations...
% %result = tomRun('npsol', problem, 1);
% %result = tomRun('minos', problem, 1);
% 
% %% Calling with separate AD.  The AD wrappers call Prob.f for the evaluation...
% problem = clsAssign('ad_wrapper_f', 'ad_wrapper_J', [], [], [], Name, x_0, y, [], [] , [], [], [], A, b_L, b_H, [], [], [], [], [], x_L, x_H);
% 
% problem.f = @simple_nlls_system;
% problem.ADCons = 0; %Will do manually
% problem.ADObj = 0;
% problem.parameters = parameters;
% problem.KNITRO.options.HESSOPT = 6; %Sparse hessian with BFGS
% [r, J] =  eval_AD(@simple_nlls_system, x_0, problem); %Can differentiate...
% r = ad_wrapper_f(x_0, problem);
% J = ad_wrapper_J(x_0, problem);
% result = tomRun('snopt', problem, 1); %Seems to have the lowest number of evaluations...

%% Fully wrapped versions
settings.print_level = 1;
settings.name = 'simple quadratic';
settings.use_MAD = false; %will use ADImat
%settings.relative_tolerance = 1E-6;
%settings.absolute_tolerance = 1E-6;

constraints.A = A;
constraints.b_L = b_L;
constraints.b_H = b_H;
constraints.x_L = x_L;
constraints.x_H = x_H;
[result, problem] = constrained_nls('snopt', @simple_nlls_system, x_0, constraints, parameters, settings);
[result, problem] = constrained_nls('nlssol', @simple_nlls_system, x_0, constraints, parameters, settings);

settings.use_MAD = true; %Otherwise, leave the same.
[result, problem] = constrained_nls('snopt', @simple_nlls_system, x_0, constraints, parameters, settings);
[result, problem] = constrained_nls('nlssol', @simple_nlls_system, x_0, constraints, parameters, settings);