%% Portfolio maximization problem under rational inattention.  It solves,
%min {sum_i(alpha_i^2 x_i^2)}
% st .5 sum_i(log(sigma^2) - log(x^2)) = kappa
% where alpha_i are idiosyncratic weights in the portfolio, and sigma are the variance of the underlying assets, x is the posterior variance an individual would choose, and kappa is an entropy constraint.

%Either ensure that "tomlab" is in your path on starting up matlab, or run the startup script, e.g. "run C:/apps/tomlab/startup.m"

madinitglobals; %Need to run for auto-differentiation to work.

clc;
clear all;


%A few constants
max_N = 100000; %The biggest value we will use for the number of variables
epsilon = 1E-10; %Will use to bound things above zero.
x_0 = 1.1*ones(max_N,1); %Used as the initial condition for the choice of x
x_L = epsilon * ones(max_N,1); %Bounding a little above 0 since it takes logs.
x_U = inf(max_N,1);         % Upper bounds for x.

% Generating alpha and signa uniformly from (1,2) for both alpha and sigma
alpha_all = 1 + rand(max_N,1);
sigma_all = 1 + rand(max_N,1); %Don't want it going below 0 since taking logs, so bound away with epsilon

%Setup nonlinear constraint
kappa = 0.7; %Used in the constraint
kappa_L = kappa; %i.e. this is an equality constraint.
kappa_U = kappa; 



%% Trying without any auto-differentiation
%NOTE: With fmincon in matlab, coulddn't get much about N = 30
N = 50; %Use the maximum with knitro.  Fast for large numbers, even hit 200000 in about a minute
alpha = alpha_all(1:N);
sigma = sigma_all(1:N);
objective = @(x) sum((x.^2).*(alpha.^2)); %Objective
constraint = @(x) (1/2)*sum( log(sigma.^2) - log(x.^2) ); %Constraint

Prob = conAssign(objective, [], [], [], x_L(1:N), x_U(1:N), 'Portfolio example', x_0(1:N), [], [], [], [], [], constraint, [], [], [], kappa_L, kappa_U);
%This tells the problem to use auto-differentiation
%Prob.ADObj = 1; % Gradient calculated with finite differences
%Prob.ADCons = 1; % Jacobian calculated with finite differences
Prob.PriLevOpt =2; %Print level in the problem, 0 is nothing, 1 is final result, etc.
Prob.NumDiff = 1; %use finite differences
Prob.options.GRADOPT = 1; %use finite differences

%Solve the problem
Result = tomRun('knitro', Prob); %The last 

%% Trying with knitro and the maximum number of N
N = max_N; %Use the maximum with knitro.  Fast for large numbers, even hit 200000 in about a minute
alpha = alpha_all(1:N);
sigma = sigma_all(1:N);
objective = @(x) sum((x.^2).*(alpha.^2)); %Objective
constraint = @(x) (1/2)*sum( log(sigma.^2) - log(x.^2) ); %Constraint


Prob = conAssign(objective, [], [], [], x_L(1:N), x_U(1:N), 'Portfolio example', x_0(1:N), [], [], [], [], [], constraint, [], [], [], kappa_L, kappa_U);
%This tells the problem to use auto-differentiation
Prob.ADObj = 1; % Gradient calculated with AD
Prob.ADCons = 1; % Jacobian calculated with AD
Prob.PriLevOpt = 1; %Print level in the problem, 0 is nothing, 1 is final result, etc.



%Solve the problem
Result = tomRun('knitro', Prob); %The last 

%This isn't bad, but gets pretty slow for larger N.  Might be tweaks in settings which get it faster.
%Result = tomRun('npsol', Prob, 1); 

%All of these are orders of magnitude slower...
%Result = tomRun('conSolve', Prob, 1);%very slow, turned off
%Result = tomRun('nlpSolve', Prob, 1);%very slow, turned off
%Result = tomRun('sTrustr', Prob, 1); 
%Result = tomRun('minos', Prob, 1);
