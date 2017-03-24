% $Rev: 59 $
% $Date: 2016-05-05 12:48:11 -0700 (Thu, 05 May 2016) $
% $LastChangedBy: jlperla $

% Author: Jesse Perla (c) 2016
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
function resid = residual_with_structure(new_values, function_name, param_names, output_order, targets, params, varargin)
    for i=1:length(param_names)
        params = setfield(params, param_names{i}, new_values(i));
    end
    [out_struct{1:nargout(function_name)}] = function_name(params, varargin{:});
    for i=1:length(targets)
        resid(i) = out_struct{output_order(i)} - targets(i);
    end
end
