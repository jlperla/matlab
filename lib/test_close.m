% $Rev: 1 $
% $Date: 2015-01-29 15:42:05 -0800 (Thu, 29 Jan 2015) $
% $LastChangedBy: jlperla $

% Author: Jesse Perla (c) 2012
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)


%Ensures abs(a,b) < tolerance, primarily used for regression testing.

function result = test_close(a, b, tolerance)
	if(exist('tolerance', 'var')) %Check settings
        tol = tolerance;
    else % Otherwise, set to defaults.
        tol = .00001;
    end;    
    result = (abs(a-b) < tol);    
end