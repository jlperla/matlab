% $Rev: 48 $
% $Date: 2016-02-07 11:04:17 -0800 (Sun, 07 Feb 2016) $
% $LastChangedBy: jlperla $

% Author: Jesse Perla (c) 2016
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

function r = simple_nlls_system(x, problem)
r(1) = x(1)^2 - problem.parameters.a_1;
r(2) = x(2)^2 - problem.parameters.a_2;
end