% $Rev: 1 $
% $Date: 2015-01-29 15:42:05 -0800 (Thu, 29 Jan 2015) $
% $LastChangedBy: jlperla $

% Author: Jesse Perla (c) 2013
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

function param = set_parameters_by_name(parameter_names, parameter_values, default_param)
assert(length(parameter_names) == length(parameter_values)); %Need to be the same length.
param = default_param; %Start at the default
for i = 1:length(parameter_names)
    param = setfield(param, parameter_names{i}, parameter_values(i)); %Sequentially go through to set the values.
end
end