% $Rev: 1 $
% $Date: 2015-01-29 15:42:05 -0800 (Thu, 29 Jan 2015) $
% $LastChangedBy: jlperla $

% Authors: Cecilia Parlatore Siritto and Jesse Perla (c) 2009

function test_dynare_pp
    clc;
    clear variables;
    close all;
    
    %Setup the parameters.  It will replace placeholders in the template
    %file with these
    params.psi = 0; %e.g. replaces %%psi%% in the template with '0' when generating mod
    params.rho = 0.950001;
    
    %Dynare++ settings.  Can use any of the settings in the dynare docs
    settings.steps = 0;
    settings.order = 2;
    settings.threads = 8;
    settings.per = 300;    
    settings.sim = 150;    

    %Run dynare++.  It returns the matrix results file name.
    %params and settings are optional
    mat_file = dynare_pp('example1.mod.template', settings, params);

    %Load ther results.
    load(mat_file);
    
    %See some results
    plot(100*dyn_irfp_EPS_mean(dyn_i_K,:));

    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    %To run dynare++ without a template, just use the name of the module
    %without without any %% %% in it.
    %Can pass in the settings as well, but it is optional.
    mat_file_2 = dynare_pp('example2.mod', settings);
    load(mat_file_2); %Replaces the data from the previous one.
    plot(100*dyn_irfp_EPS_mean(dyn_i_K,:));
    
end