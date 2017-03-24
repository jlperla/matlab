% $Rev: 22 $
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
% Author: Jesse Perla (c) 2015

%Creates a higher order function to integrate from x_min to infinity using laguerre quadrature
function integrator = laguerre_integrator(N_nodes, x_min, add_weight, array_valued)
    if nargin < 3
        add_weight = true; %By defaults, add the weights to the calculation
    end
    if nargin < 4
        array_valued = true;
    end
        
	[x, w] = laguerre_quadrature(N_nodes, x_min);
    if(add_weight && array_valued)
        integrator = @(f) (exp(x) .* f(x))' * w; %Note the exp(x).  This is the weighting of laguerre quadrature.  More stable if can factor into f and use the add_weight.
    elseif(~add_weight && array_valued)
        integrator = @(f) f(x)' * w; %Otherwise, let the user add the weights to f(x)
    elseif(add_weight && ~array_valued)
        integrator = @(f) (exp(x) .* arrayfun(@(z) f(z),x))' * w; %Note the exp(x).  This is the weighting of laguerre quadrature.  More stable if can factor into f and use the add_weight.
    else 
        integrator = @(f) arrayfun(@(z) f(z),x)' * w; %Otherwise, let the user add the weights to f(x)
    end
    
end