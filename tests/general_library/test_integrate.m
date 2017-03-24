% $Rev: 1 $
% Author: Jesse Perla (c) 2012
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

init_lib();

%The following mathematica code generates the analytical derivatives used here to check the results here
%Integrate[1/x^2, {x, 2., \[Infinity]}]
%Integrate[1/x^2, {x, 3., \[Infinity]}]
%Integrate[E^-x, {x, 0, \[Infinity]}]
%Integrate[E^-x, {x, 1, \[Infinity]}]


%THe following function will be integrating piecewise.  e.g. [-1 0 1] does integrate([-1 0]) + integrate([0 1])
f = @(x) max(0, x); %function kinked at 0
assert( test_close(integrate(f, [-1 0]), 0.0));
assert( test_close(integrate(f, [0 1]), .5));
assert( test_close(integrate(f, [-1 0 1]), .5));
assert( test_close(integrate(f, [-1 -.2 0 .5 1]), .5));

optset('integrate','quadrature_points', 7); %Set the options for the number of quadrature points
assert( test_close(integrate(f, [-1 0]), 0.0));


%Testing the gauss-laguerre quadrature for infinite right tails in the integration.
laguerre_quadrature(7, 2.0);
laguerre_quadrature(7, 3.0);
laguerre_quadrature(8, 2.0);

f = @(x) x^(-2);
optset('integrate','quadrature_points', 31); %Generally need a fair number of quadrature points for infinite right tails.
assert(test_close(integrate(f, [2.0 Inf]), .5, 0.01));
optset('integrate','quadrature_points', 41);
assert(test_close(integrate(f, [3.0 Inf]), .33, 0.01));
assert(test_close(integrate(f, [2.0 3.0 6.0 Inf]), .5, 0.01)); %Checking that it works piecewise as well (i.e. [2,3], [3,6], [6, inf) where the last uses gaussian quadrature

f = @(x) exp(-x);
assert(test_close(integrate(f, [0.0 Inf]), 1.0, 0.01));
assert(test_close(integrate(f, [0.0 1.0 3.0 Inf]), 1.0, 0.01));
assert(test_close(integrate(f, [1.0 Inf]), 1/exp(1), 0.01));

assert(test_close(integrate(f, [1.0 1.0]),0));
assert(test_close(integrate(f, [1.0 1.0 Inf]), 1/exp(1), 0.01));
display('test complete');
