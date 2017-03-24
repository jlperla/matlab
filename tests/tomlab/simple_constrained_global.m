% $Rev: 100 $
% $Date: 2016-12-21 11:24:46 -0800 (Wed, 21 Dec 2016) $
% $LastChangedBy: jlperla $

init_lib();

clc;
%% Other simple tests (this one unconstrained)
clearvars result problem parameters settings constraints;
constraints = [];
parameters.a = 2;
settings.name = 'Test Unconstrained';
settings.relative_tolerance = 1E-6;
settings.absolute_tolerance = 1E-6;
test_f = @(x, problem) (x - problem.parameters.a).^2;
x_0_all = [-4; 5]; %Tries multiple initial conditions.
settings.print_level = 0;
tic;
[result, success, problem] = constrained_nlp_minimize('npsol', test_f, [], x_0_all, constraints, parameters, settings);
result.x_k
result.f_k
toc

settings.print_level = 1;
constraints.x_L = [-10];
constraints.x_H = [10];
tic;
[result, success,  problem] = constrained_nlp_global_minimize('lgo', test_f, [], x_0_all, constraints, parameters, settings);
result.x_k
result.f_k
toc

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
constraints.x_L = [-100, 2];
constraints.x_H = [100, 2];

tic;
settings.use_initial_conditions = true;
[result,success, problem] = constrained_nlp_global_minimize('lgo', test_f, [], x_0_all, constraints, parameters, settings); %IN REALITY, SPECIALIZED ALGORITHMS ARE PREFERRRED IF UNCONSTRAINED!
result.x_k
result.f_k
toc

tic;
settings = rmfield(settings, 'use_initial_conditions'); %testing without initial conditions.
x_0_all = [];
[result,success, problem] = constrained_nlp_global_minimize('lgo', test_f, [], x_0_all, constraints, parameters, settings); %IN REALITY, SPECIALIZED ALGORITHMS ARE PREFERRRED IF UNCONSTRAINED!
result.x_k
result.f_k
toc

%% The direct methods are slow
% tic;
% settings.print_level = 1;
% [result,success, problem] = constrained_nlp_global_minimize('glcFast', test_f, [], x_0_all, constraints, parameters, settings);
% result.x_k
% result.f_k
% toc
% 
% tic;
% settings.print_level = 1;
% [result,success, problem] = constrained_nlp_global_minimize('glcSolve', test_f, [], x_0_all, constraints, parameters, settings);
% result.x_k
% result.f_k
% toc

%% Using for mixed-integer.  DOESN'T SEEM TO WORK??????
clearvars result problem parameters settings constraints;
constraints = [];
parameters.a = 2.1;
settings.name = 'Test Unconstrained';
settings.relative_tolerance = 1E-6;
settings.absolute_tolerance = 1E-6;
test_f = @(x, problem) (x(1) - problem.parameters.a).^2 + x(2);
constraints.x_L = [-5, 1.1];
constraints.x_H = [5, 5.0];
settings.integer_variables = [true; false]; %i.e., first is integer
settings.print_level = 1;
 
tic;
[result,success, problem] = constrained_nlp_global_minimize('lgo', test_f, [], [], constraints, parameters, settings); %IN REALITY, SPECIALIZED ALGORITHMS ARE PREFERRRED IF UNCONSTRAINED!
result.x_k
result.f_k
toc



