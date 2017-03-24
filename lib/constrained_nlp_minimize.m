% $Rev: 112 $
% $Date: 2017-03-13 16:40:30 -0700 (Mon, 13 Mar 2017) $
% $LastChangedBy: jlperla $

% Author: Jesse Perla (c) 2016
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

function [result, success, problem, all_results] = constrained_nlp_minimize(method, f, g, x_0, constraints, parameters, settings)
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
        constraints.x_L = [];
    end
    if ~isfield(constraints, 'x_H')
        constraints.x_H = [];
    end    
    if ~isfield(settings, 'use_AD')
        settings.use_AD = true;
    end
    if ~isfield(settings, 'accept_any_solutions')
        settings.accept_any_solutions = true;
    end
	
	if ~isfield(settings, 'objective_gradient')
		settings.objective_gradient = [];
	end
	if ~isfield(settings, 'objective_hessian')
		settings.objective_hessian = [];
	end
	if ~isfield(settings, 'constraint_jacobian')
		settings.constraint_jacobian = [];
	end
    

    %% Knitro is having trouble with the Inf on constraints, so ...
    if(strcmp(method, 'knitro'))
       knitro_Inf = 1E15; %Knitro isn't accepting Infinity                
        snap_inf = @(v, inf_value) arrayfun(@(x) ifthenelse(x == Inf, inf_value, ifthenelse(x == -Inf, -inf_value, x)), v);
        constraints.b_L = snap_inf(constraints.b_L,knitro_Inf);
        constraints.b_H = snap_inf(constraints.b_H,knitro_Inf);
    end

    %% Calling with different ADs, using different wrappers.
    problem = conAssign(f, settings.objective_gradient, settings.objective_hessian, [], ...
                 constraints.x_L, constraints.x_H, ...
                settings.name,...
                x_0(1,:), ...
                 [], [], ...
                 constraints.A, constraints.b_L, constraints.b_H, ...
                 g, settings.constraint_jacobian, [], [], ...
                 constraints.c_L, constraints.c_H, constraints.x_L, constraints.x_H);
    if(settings.use_AD)
        %Only supports MAD
        problem.ADCons = 1;
        problem.ADObj = 1;
    end
    problem.parameters = parameters;
    problem.settings = settings;
    
    %method specific settings
    if(strcmp(method, 'knitro'))
        problem.KNITRO.options.HESSOPT = 6; %Sparse hessian with BFGS      
    end

    %Setup tolerances
        %SNOPT, NPSOL use Prob.SOL.optPar(10) for the major optimality tolerance.
        %KNITRO: Prob.KNITRO.options.OPTTOL (relative), and/or .OPTTOL_ABS (absolute).
        %clsSolve has a whole range of optimality tolerance tests; mostly governed by fields in Prob.optParam: %most important ones are eps_g, eps_x and eps_absf
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
        problem.SOL.optPar(30) = settings.max_iterations;
        problem.KNITRO.options.MAXIT = settings.max_iterations; %Sparse hessian with BFGS              
    end    
    if(~(isnan(absolute_tolerance) && isnan(relative_tolerance)))
        %TODO: Can't figure out.
%        problem.SOL.optPar(9) = min(relative_tolerance, absolute_tolerance);
        problem.SOL.optPar(10) = min(relative_tolerance, absolute_tolerance);
%        problem.SOL.optPar(11) = min(relative_tolerance, absolute_tolerance);
        problem.SOL.optPar(41) = min(relative_tolerance, absolute_tolerance);
    end
    if(~isnan(absolute_tolerance))
        problem.KNITRO.options.OPTTOL_ABS = absolute_tolerance;
        problem.optParam.eps_absf = absolute_tolerance;
       %most important ones are eps_g, eps_x and eps_absf
    end
    if(~isnan(relative_tolerance))
        problem.KNITRO.options.OPTTOL = relative_tolerance;
        problem.optParam.eps_g = relative_tolerance;
        problem.optParam.eps_x = relative_tolerance;
    end
    if(isfield(settings, 'algorithm'))
        problem.Solver.Alg = settings.algorithm; %        %if(strcmp(method, 'nlpSolve'))  %These are algorithm dependent?
    end
    problem.PriLev = settings.print_level;
    problem.PriLevOpt = settings.print_level;
    
    %Try all initial conditions (if required)
    for i=1:size(x_0,1) %rows of initial conditions
        problem.x_0 = x_0(i,:);
        result = tomRun(method, problem, []);         
        all_results.results{i} = result;
        all_results.x_sols(i,:) = result.x_k';
        all_results.f_sols(i) = result.f_k'; %Norm of the minimum
        if(settings.accept_any_solutions)
            all_results.success(i) = (result.ExitFlag == 0 || result.ExitFlag == 3); %i.e., successful or not, but allow optimal solution found without requested accuracy.
        else
            all_results.success(i) = (result.ExitFlag == 0); %i.e., successful or not?
        end
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

end
