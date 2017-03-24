% $Rev: 1 $
% $Date: 2015-01-29 15:42:05 -0800 (Thu, 29 Jan 2015) $
% $LastChangedBy: jlperla $

% Author: Jesse Perla (c) 2012, 2013
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)


%Creates an interpolator function from a grid of nodes and values
%Currently only supports 1D interpolation.
%With later versions of matlab, griddedInterpolator should be used instead.


function f = interpolate(nodes, values, method)
    if(exist('method', 'var')) %Check settings
    else % Otherwise, set to defaults.
        method = 'linear'; %Defaults to linear.
    end;
    
    %Tests to ensure the nodes and value are kosher
    assert(is_finite_vector(nodes));
    assert(is_finite_vector(values));
    assert(isreal(nodes));
    assert(isreal(values));
    
    f = @(x) interp1(nodes, values, x, method, 'extrap'); %Returns a lambda with the nodes, values, and method bound.  This will extrapolate as well.
end