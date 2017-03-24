% $Rev: 22 $
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
% Author: Jesse Perla (c) 2015

function integrator = expectation_exponential_laguerre(delta, N_nodes, array_valued) %delta is the exponential parameter.
    if nargin < 3
        array_valued = true;
    end
	[x, w] = laguerre_quadrature(N_nodes, 0);
    if(array_valued)
        integrator = @(f) (delta.* exp((1-delta)*x).* f(x))' * w;
    else
        integrator = @(f) arrayfun(@(z) delta * exp((1-delta)*z)* f(z), x)' * w;
    end
end