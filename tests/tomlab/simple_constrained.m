% $Rev: 98 $
% $Date: 2016-09-23 14:12:40 -0700 (Fri, 23 Sep 2016) $
% $LastChangedBy: jlperla $

init_lib();

Name='Exponential problem 3. 1 linear eq.+ 2 nonlinear ineq.';
A       = [1 1];        % One linear constraint
b_L     = 0;            % Lower bound on linear constraint
b_U     = 0;            % b_L == b_U implies equality
c_L     = [1.5;-10];     % Two nonlinear inequality constraints
c_U     = [];           % Empty means Inf (default)
x_0     = [-5;5];       % Initial value
x_L     = [-10;-10];    % Lower bounds on x
x_U     = [10;10];      % Upper bounds on x

% Generate the problem structure using the TOMLAB Quick format
Prob = conAssign('con1_f', [], [], [], ...
                 x_L, x_U, ...
                Name,...
                x_0, ...
                 [], [], ...
                 A, b_L, b_U, ...
                 'con1_c',[], [], [], ...
                 c_L, c_U , ...
                 x_L, x_U );% ...
                 %f_opt, x_opt );

Prob.ADCons = 1; %use MAD
Prob.ADObj = 1; %use MAD

Prob.SOL.optPar(9) = 1E-5; % Major feasibility tolerance nonlinear constraints
Prob.SOL.optPar(10) = 1E-5; % Major feasibility tolerance in x
Prob.SOL.optPar(1) = 10;  % Increase Print Level for NPSOL to 10 (default 0, maximum is 50)

Result  = tomRun('npsol',Prob,2);
Result.x_k
Result.f_k

%% Using the wrapper.
parameters = []; %Can pass things otherwise.
settings.print_level = 0;
settings.name = Name;
settings.use_MAD = true;
settings.relative_tolerance = 1E-6;
settings.absolute_tolerance = 1E-6;

constraints.A = A;
constraints.b_L = b_L;
constraints.b_H = b_U;
constraints.x_L = x_L;
constraints.x_H = x_U;
constraints.c_L = c_L;
constraints.c_H = c_U;
x_0_all = [-5 5;
         -2 4];

%Can embed functions as required, or give the names.
test_constraint_c = @(x, problem) [ - x(1)*x(2) + x(1) + x(2); x(1)*x(2)];
test_f = @(x, problem) exp(x(1)) * (4*x(1)^2 + 2*x(2)^2 + 4*x(1)*x(2) + 2*x(2) + 1); 

[result, success,  problem] = constrained_nlp_minimize('npsol', test_f, test_constraint_c, x_0_all, constraints, parameters, settings);
result.x_k
result.f_k

%% Other simple tests (this one unconstrained)
clearvars result problem parameters settings constraints;
constraints = [];
parameters.a = 2;
settings.name = 'Test Unconstrained';
settings.relative_tolerance = 1E-6;
settings.absolute_tolerance = 1E-6;
test_f = @(x, problem) (x - problem.parameters.a).^2;
x_0_all = [-4; 5]; %Tries multiple initial conditions.

[result, success, problem] = constrained_nlp_minimize('npsol', test_f, [], x_0_all, constraints, parameters, settings);
result.x_k
result.f_k

%% Another with a fixed variable.

clearvars result problem parameters settings constraints;
constraints = [];
parameters.a = 2;
settings.name = 'Test Unconstrained';
settings.relative_tolerance = 1E-6;
settings.absolute_tolerance = 1E-6;
test_f = @(x, problem) (x(1) - problem.parameters.a).^2 + x(2);
x_0_all = [-4 3;
    5 3]; %Tries multiple initial conditions.
constraints.x_L = [-Inf, 2];
constraints.x_H = [Inf, 2];

[result,success, problem] = constrained_nlp_minimize('npsol', test_f, [], x_0_all, constraints, parameters, settings);
result.x_k
result.f_k

[result,success, problem] = constrained_nlp_minimize('knitro', test_f, [], x_0_all, constraints, parameters, settings);
result.x_k
result.f_k