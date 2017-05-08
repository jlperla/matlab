%% Sparse linear least squares

clc;

simulate_data = false; %toggles whether to load the simulated data or generate it.

%% Simulating data two-way fixed effect panel data.
if(simulate_data)

    N_i = 10000; %number of employees
    N_f = 1000; %number of firms
    N_fi_max = 10; %i.e. maximum of N_fi_max jobs  Actual number will be randomly drawn

    % Genrate fixed effect for employees and firms.  Just scaling a uniform draw between 0 and 1
    sigma_i = .2; %scales the size of employee fixed effect
    sigma_f = .1; %scales the size of firm fixed effect
    sigma_fi = 1.0; %scales size of match observable
    sigma_epsilon = .01; %scales size of normal random variable.

    %Generate random effects for employees and firms
    theta_i = sigma_i * rand(N_i,1);
    gamma_f = sigma_f * rand(N_f,1);

    %True observable coefficients
    beta = [.1];

    %Generate random employee/firm matches
    N_fi = randi(N_fi_max,2,N_i); %i.e., generates a random number of jobs between 2 and N_fi_max.

    %For each employee, generate firm matches and add to a sparse matrix
    total_matches = 0;
    C = sparse(0,length(beta) + N_i + N_f); %Total number of observables with indicators for the two types.

    %Filling in indicators for the matches
    for i=1:N_i
        matches = randi(N_f,N_fi(i),1); %Generates N_fi(i) jobs
        for fi=1:numel(matches)
           C(total_matches + 1, length(beta) + i) = 1;
           C(total_matches + 1, length(beta) + N_i + matches(fi)) = 1;
           total_matches = total_matches + 1; 
        end 
    end

    %Generate observables for all the matches
    C(:,1) = sigma_fi * rand(total_matches,1);

    %Generate random normal shocks
    epsilon = sigma_epsilon * normrnd(0,sigma_epsilon, total_matches, 1);

    %Simulate wages, use true cofficients and fixed effects
    coefficients = [beta; theta_i; gamma_f]; %Stacking

    w = sparse(C * coefficients + epsilon);
    
    %Save the files
    save('simulated_panel.mat', 'C', 'w', 'epsilon', 'coefficients');

else
    %Need to have saved off the panel prior to loading it.
    load('simulated_panel.mat'); 
end

%% Solve linear least squares:
%min( | C x - w|_2)
%could add constraints, but not doing that here.

Prob = llsAssign(C, w, [], [], "LLS Example");

Result = tomRun('Tlsqr', Prob, 1); %intended for sparse Sparse works well here.
Result = tomRun('snopt', Prob, 1); %OK, but Tlsqr works great here.
%Result = tomRun('lssol', Prob, 1); %Dense linear least squares.  Good but not for this sort of problem if N's are large
%Result = tomRun('nlssol', Prob, 1); %'clsSolve' if constraint linear least squares.  Dense
