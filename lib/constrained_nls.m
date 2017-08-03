% Author: Jesse Perla (c) 2016-2017
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

function [result, success, problem, all_results] = constrained_nls(method, f, x_0, constraints, parameters, settings)
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
    if ~isfield(constraints, 'x_L')
        constraints.x_L = [];
    end
    if ~isfield(constraints, 'x_H')
        constraints.x_H = [];
    end    
    if ~isfield(settings, 'use_MAD');
        settings.use_MAD = true;
    end
    if ~isfield(constraints, 'y') %The list of y's to hit.
        dummy_problem.parameters = parameters; %Need to call f with parameters of some sort.
        dummy_problem.settings = settings;
        constraints.y = zeros(length(f(x_0(1,:), dummy_problem)),1);
    end
    
   
    

    %% Knitro is having trouble with the Inf on constraints, so ...
    if(strcmp(method, 'knitro'))
       knitro_Inf = 1E15; %Knitro isn't accepting Infinity                
        snap_inf = @(v, inf_value) arrayfun(@(x) ifthenelse(x == Inf, inf_value, ifthenelse(x == -Inf, -inf_value, x)), v);
        constraints.b_L = snap_inf(constraints.b_L,knitro_Inf);
        constraints.b_H = snap_inf(constraints.b_H,knitro_Inf);
    end

    %% Calling with different ADs, using different wrappers.
    if ~isfield(settings, 'use_AD')
        settings.use_AD = true;
    end
    if(settings.use_AD)

        if( settings.use_MAD)
            problem = clsAssign(f, [], [], constraints.x_L, constraints.x_H, settings.name, x_0(1,:), constraints.y, [], [] , [], [], [], constraints.A, constraints.b_L, constraints.b_H, [], [], [], [], [], constraints.x_L, constraints.x_H);
            problem.ADCons = 1; %use MAD
            problem.ADObj = 1;
        else
            %For the ADImat, calls AD wrappers call Prob.f for the evaluation...
            problem = clsAssign('cls_rJ', 'cls_Jr', [],constraints.x_L, constraints.x_H, settings.name, x_0(1,:), constraints.y, [], [] , [], [], [], constraints.A, constraints.b_L, constraints.b_H, [], [], [], [], [], constraints.x_L, constraints.x_H);
            problem.USER.SimrJ = 'ad_wrapper_J'; %This in turn calls the 'problem.f' below
            problem.f = f;
            problem.ADCons = 0; %Will do manually
            problem.ADObj = 0;  
        end        
    else
            %For the ADImat, calls AD wrappers call Prob.f for the evaluation...
            problem = clsAssign(f, [], [],constraints.x_L, constraints.x_H, settings.name, x_0(1,:), constraints.y, [], [] , [], [], [], constraints.A, constraints.b_L, constraints.b_H, [], [], [], [], [], constraints.x_L, constraints.x_H);
            problem.f = f;
            problem.ADCons = 0; %Using finite differences
            problem.ADObj = 0;             
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
    if(isfield(settings, 'algorithm')) %These are algorithm dependent.
        if(strcmp(method, 'clsSolve'))
            problem.Solver.Alg = 5;
        end 
    end
    problem.PriLev = settings.print_level;
    problem.PriLevOpt = settings.print_level;
    
    %Try all initial conditions (if required)
    for i=1:size(x_0,1) %rows of initial conditions
        problem.x_0 = x_0(i,:);
        result = tomRun(method, problem, []);
        all_results.results{i} = result;
        all_results.x_sols(i,:) = result.x_k';
        all_results.r_sols(i,:) = result.r_k'; %Residuals
        all_results.f_sols(i) = result.f_k'; %Norm of residuals, i.e. objective.
        all_results.success(i) = (result.ExitFlag == 0); %i.e., successful or not?
    end
    %Pick the best among the sucessful result
    all_successful_f = all_results.f_sols;
    all_successful_f(all_results.success ~= true) = NaN;
    
    success = max(~isnan(all_successful_f)); %Success 
    if(success)
        [~, min_i] = min(all_successful_f);
        %Change the problem initial condition back to the best, as well.    
        problem.x_0 = x_0(min_i, :);
        result = all_results.results{min_i};
    else
        result = NaN;
    end
end
