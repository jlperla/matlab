% $Rev: 100 $
% $Date: 2016-12-21 11:24:46 -0800 (Wed, 21 Dec 2016) $
% $LastChangedBy: jlperla $

% Author: Jesse Perla (c) 2016
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

function [result, success, problem, all_results] = constrained_nlp_global_minimize(method, f, g, x_0, constraints, parameters, settings)
    success = false; %Assume failure.
	%% The settings structure may have empty elements, so default if required.    
    if ~isfield(settings, 'name')
        settings.name = '';
    end 
    if ~isfield(settings, 'print_level')
        settings.print_level = 1;
    end
    if ~isfield(constraints, 'A')
        constraints.A = [];
    end     
    if ~isfield(constraints, 'b_L')
        constraints.b_L = [];
    end
    if ~isfield(constraints, 'b_H')
        constraints.b_H = [];
    end
    if ~isfield(constraints, 'c_L')
        constraints.c_L = [];
    end
    if ~isfield(constraints, 'c_H')
        constraints.c_H = [];
    end
    if ~isfield(constraints, 'x_L')
        error('Box-bounds required for global optimizer');
    end
    if ~isfield(constraints, 'x_H')
        error('Box-bounds required for global optimizer');
    end    
    if ~isfield(settings, 'use_AD') %???? Not sure if we will be able to use this.
        settings.use_AD = true;
    end
    
    if ~isfield(settings, 'max_function_evaluations')
        settings.max_function_evaluations = [];
    end
    
    if ~isfield(settings, 'use_initial_conditions')
        settings.use_initial_conditions = ~isempty(x_0);
    end    
    
    if ~isfield(settings, 'integer_variables')
        settings.integer_variables = []; %For mixed-integer
    end        

    %% Calling with different ADs, using different wrappers.
    problem = glcAssign(f, constraints.x_L, constraints.x_H, ...
                settings.name,...
                 constraints.A, constraints.b_L, constraints.b_H, ...
                 g, constraints.c_L, constraints.c_H,...
                 [], settings.integer_variables);
    problem.parameters = parameters;
    problem.settings = settings;
    
    if(settings.use_AD)
        %Only supports MAD
        problem.ADCons = 1;
        problem.ADObj = 1;
    end
    
    %Setup tolerances
    if(isfield(settings, 'absolute_tolerance'))
        absolute_tolerance = settings.absolute_tolerance;
    else
        absolute_tolerance = NaN;
    end
    if(isfield(settings, 'relative_tolerance'))
        relative_tolerance = settings.relative_tolerance;
    else
        relative_tolerance = NaN;
    end
    if(isfield(settings, 'max_iterations'))
        problem.optParam.MaxIter = settings.max_iterations;
        Prob.optParam.MaxFunc = settings.max_function_evaluations;
    end
    
%     if(~(isnan(absolute_tolerance) && isnan(relative_tolerance)))
%     end
%     if(~isnan(absolute_tolerance))
%     end
    if(~isnan(relative_tolerance))
        problem.optParam.eps_g = relative_tolerance;
        problem.optParam.eps_x = relative_tolerance;
    end
%     if(isfield(settings, 'algorithm'))
%         problem.Solver.Alg = settings.algorithm; %        %if(strcmp(method, 'nlpSolve'))  %These are algorithm dependent?
%     end
    problem.PriLev = settings.print_level;
    problem.PriLevOpt = settings.print_level;
    
    %Try all initial conditions (if required)
    if(settings.use_initial_conditions)
        for i=1:size(x_0,1) %rows of initial conditions
            problem.x_0 = x_0(i,:);
            result = tomRun(method, problem, []);         
            all_results.results{i} = result;
            all_results.x_sols(i,:) = result.x_k';
            all_results.f_sols(i) = result.f_k'; %Norm of the minimum
            all_results.success(i) = (result.ExitFlag == 0); %i.e., successful or not?
        end
        %Pick the best among the sucessful result
        all_successful_f = all_results.f_sols;
        all_successful_f(all_results.success ~= true) = NaN;

        if(min(isnan(all_successful_f)) == 1) %i.e., all were unsuccessful.
            result = NaN;    
        else
            [~, min_i] = min(all_successful_f);
            %Change the problem initial condition back to the best, as well.    
            problem.x_0 = x_0(min_i, :);
            result = all_results.results{min_i};        
            success = true;
        end
    else
        %Otherwise, just run it without setting any initial conditions.
        result = tomRun(method, problem, []);         
        all_results.results = result;
        all_results.x_sols = result.x_k';
        all_results.f_sols = result.f_k'; %Norm of the minimum
        all_results.success = (result.ExitFlag == 0); %i.e., successful or not?        
    end
end
