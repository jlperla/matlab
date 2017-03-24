% $Rev: 23 $
% Author: Jesse Perla (c) 2015
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

init_lib();

N_nodes = 100;
z_min = 0;

display_s('Present discounted value generator');
pdv = pdv_integrator(.2, N_nodes);
pdv(@(x) exp(-.3 * x))
pdv(@(x) exp(.18 * x))

integrator_pdv = laguerre_integrator(N_nodes, z_min);%Directly integrating instead.
integrator_pdv(@(x) exp(-.3 * x) .* exp(-.2 * x))
integrator_pdv(@(x) exp(.18 * x) .* exp(-.2 * x))



display_s('Function adding weights');
integrator = laguerre_integrator(N_nodes, z_min, true);
integrator(@(x) exp(- .1 * x))
integrator(@(x) exp(- x.^2))
integrator(@(x) exp(- x))

display_s('With factoring weights into integrand');
integrator2 = laguerre_integrator(N_nodes, z_min, false); %i.e. put in our own weights by factoring your function.
integrator2(@(x)exp(.9 * x))
integrator2(@(x)exp(- x.^2).*exp(x))
integrator2(@(x) 1.0 * exp(0 .* x))

display_s('Function adding weights');
integrator3 = laguerre_integrator(N_nodes, z_min, true, false);
integrator3(@(x) exp(- .1 * x))
integrator3(@(x) exp(- x^2))
integrator3(@(x) exp(- x))

display_s('With factoring weights into integrand');
integrator4 = laguerre_integrator(N_nodes, z_min, false, false); %i.e. put in our own weights by factoring your function.
integrator4(@(x)exp(.9 * x))
integrator4(@(x)exp(- x^2)*exp(x))
integrator4(@(x) 1.0 * exp(0 * x))



display_s('expectation of exponential with laguerre');
delta = .1;
%Mathematica, such as : Expectation[Exp[-.1 x], x \[Distributed] ExponentialDistribution[.1]]
integrator = expectation_exponential_laguerre(delta, N_nodes);
integrator(@(x) exp(-.1 * x))
integrator(@(x) exp(-x.^2))

delta = .3;
integrator2 = expectation_exponential_laguerre(delta, N_nodes);
integrator2(@(x) 1./(x + 1))

integrator3 = expectation_exponential_laguerre(delta, N_nodes, false); %the last argument means it doesn't accept array_valued inputs.
integrator3(@(x) 1/(x + 1))


pdv = pdv(.2, N_nodes);
pdv(@(x) exp(-.3 * x))