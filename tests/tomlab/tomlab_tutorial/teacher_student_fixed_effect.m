%% Sparse linear least squares example, from Florian's data on schooling
clc;
clear;

%% Rearranging data two-way fixed effect panel data.
generate_sparse_data = false; %toggles whether to load the  data from a file or generate it.  Can be slow to generate for large N

if(generate_sparse_data)
    load('student_teacher_raw.mat');  %Raw anonymized data, will convert it to a sparse matrix here.
    
    N_students = max(id1);
    N_teachers = max(id2);
    N_observations = length(id1); %The number of observable
    N_observables = 1; %just age.  gender is collinear with the student number?

    %Preallocate a sparse matrix
    X = sparse(N_observations, N_observables + N_students + N_teachers); %Total number of observables with indicators for the two types.

    %Filling in indicators for the matches
    for i=1:N_observations
        X(i, N_observables + id1(i)) = 1; %sets the indicator given the student id.
        X(i, N_observables + N_students + id2(i)) = 1; %sets the indicator given the instructor id.
    end
    
    %Drop 2 columns arbitrarily to ensure no collinearity
    X(:, N_observables + 1) = [];
    X(:, end) = [];

    %Observable, control
    X(:,1) = age_student;
    %left hand side
    y = grade_num;
    
    %Save all variables to a file
    save('teacher_student_data.mat');

else
    %Need to have saved off the panel prior to loading it.  Toggle with generate_sparse_data above.
    load('teacher_student_data.mat'); 
end

%% Solve linear least squares:
%min( .5 | X beta - y|_2)

Prob = llsAssign(X, y, [], [], 'LLS Example'); %linear least squares, can pass in sparse matrices or use dense ones.
Prob.optParam.MaxIter = 5000; %Increasing the number of iterations, not required in general.
Prob.PriLevOpt  = 1; %More information if higher

% This took a day to run in stata!
Result = tomRun('Tlsqr', Prob); %intended for sparse unconstrained LLS.  Very good here.

beta = Result.x_k;

disp('Estimated coefficient on age');
beta(1:length(N_observables))

%Result = tomRun('snopt', Prob); %Tlsqr works much better here.
%Result = tomRun('lssol', Prob); %Dense linear least squares.  Good but not for this sort of problem if N's are large
%Result = tomRun('nlssol', Prob); %'clsSolve' if constraint linear least squares.  Dense
