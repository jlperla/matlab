% $Rev: 91 $
% $Date: 2016-09-19 20:07:53 -0700 (Mon, 19 Sep 2016) $
% $LastChangedBy: jlperla $
% Author: Jesse Perla (c) 2013
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

%Tests the experiment permutations code

function test_experiment_permutations()
init_lib(); %Initialize the library, clearing the screen, etc.

%% Define the parameter experiments
%% Set up the grid of values to experiment with
% Structure is a list of field names, then values to try for that field name.
experiments = {
    {'a', [100, 200, 300]}, ...
    {'b', [10, 20]}, ...
    {'c', [1, 2, 3]}
    }; 
[parameter_names, parameter_arrays, parameter_permutations] = generate_experiment_parameters(experiments); %This takes the structure and returns a list of parameter names along with the permutations of those values.
for i=1:length(parameter_permutations)
    g_raw(i) = sum(parameter_permutations(i, :)); %Sum up the parameters, easy to test the results.
end

g = reshape_experiment_results(experiments, g_raw);

assert(g(1,2,1) == 121);
assert(g(3,1,2) == 312);
assert(g(2,1,3) == 213);

% Doing the same thing with a structure, etc.
param.a = 0; %Some default
for i=1:length(parameter_permutations)
    g_raw(i) = f(parameter_names, parameter_permutations(i, :), param); %Sets in the default param the parameter names to the parameter values.
end
g = reshape_experiment_results(experiments, g_raw);
assert(g(1,2,1) == parameter_arrays{1}(1) +parameter_arrays{2}(2) + parameter_arrays{3}(1));
assert(g(3,1,2) == 312);
assert(g(2,1,3) == 213);

%Trying a 1D version
experiments = {
    {'a', [100, 200, 300]}
    }; 
[parameter_names, parameter_arrays, parameter_permutations] = generate_experiment_parameters(experiments); %This takes the structure and returns a list of parameter names along with the permutations of those values.
g_raw = parameter_permutations * 2; %A simple function.
g = reshape_experiment_results(experiments, g_raw);

assert(g(1) == 200);
assert(g(2) == 400);


end

function result = f(parameter_names, parameter_values, default_param) %This fills in a parameter structure with the names and values.
    param = set_parameters_by_name(parameter_names, parameter_values, default_param);
    
    result = param.a + param.b + param.c;% still does the sum.
end