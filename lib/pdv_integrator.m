% $Rev: 23 $
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
% Author: Jesse Perla (c) 2015

function integrator = pdv_integrator(r, N_nodes, array_valued) %delta is the exponential parameter.
    if nargin < 3
        array_valued = true;
    end
	[x, w] = laguerre_quadrature(N_nodes, 0);
    if(array_valued)
        integrator = @(f) (exp((1-r)*x).* f(x))' * w;
    else
        integrator = @(f) arrayfun(@(z) exp((1-r)*z)* f(z), x)' * w;
    end
end