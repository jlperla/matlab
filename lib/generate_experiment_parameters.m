%See for genericity: http://stackoverflow.com/questions/19991279/permutations-of-parameters-i-e-cartesian-product-into-a-multi-dimensional-arr/
function [parameter_names, parameter_arrays, parameter_permutations, parameter_index] = generate_experiment_parameters(experiments)
    num_experiment_parameters = length(experiments);

    %Extracts the names of parameters
    for(i = 1:num_experiment_parameters)
        parameter_names{i} = experiments{i}{1};
    end

    %Extracts the list of parameter values for each parameter, stores in a cell.
    for(i = 1:num_experiment_parameters)
        parameter_arrays{i} = experiments{i}{2};
    end

    %Fancy generic code to generate the permutations for any N
    if(numel(parameter_arrays) == 1)
        parameter_permutations = parameter_arrays{1};
    else
        vecs = cell(numel(parameter_arrays),1);
        [vecs{:}] = ndgrid(parameter_arrays{:});
        parameter_permutations = reshape(cat(numel(vecs)+1,vecs{:}),[],numel(vecs));
    end
    
    %Creates and index structure with the names in order.
    parameter_index.num_experiment_parameters = num_experiment_parameters;
    for(i = 1:num_experiment_parameters)
        parameter_index = setfield(parameter_index, parameter_names{i}, i);
    end

end