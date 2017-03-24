% $Rev: 59 $
% $Date: 2016-05-05 12:48:11 -0700 (Thu, 05 May 2016) $
% $LastChangedBy: jlperla $

% Author: Jesse Perla (c) 2016
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

function [calibrated_parameters, f_val, exitflag] = calibrate_with_structure( function_name, param_names, output_order, targets, calibrated_parameter_iv, params, varargin)
    [calibrated_parameters, f_val, exitflag] = fsolve(@(x) residual_with_structure(x, function_name, param_names, output_order, targets, params, varargin{:}), calibrated_parameter_iv );
end