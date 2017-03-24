% $Rev: 1 $
% $Date: 2015-01-29 15:42:05 -0800 (Thu, 29 Jan 2015) $
% $LastChangedBy: jlperla $

% Author: Jesse Perla (c) 2013
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

function results = reshape_experiment_results(experiments, raw_results)
    num_experiment_parameters = length(experiments);

    %Extracts the extents of each parameter
    for(i = 1:num_experiment_parameters)
        extents(i) = length(experiments{i}{2});
    end
    if(num_experiment_parameters > 1)
        results = reshape(raw_results,extents); %Uses the extents to turn things back into a multi-dimensional grid
    else
        results = raw_results; %Otherwise, it is already in 1 dimension
    end
end