% $Rev: 40 $
% $Date: 2015-11-18 12:28:58 -0800 (Wed, 18 Nov 2015) $
% $LastChangedBy: jlperla $

% Author: Jesse Perla (c) 2014
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

clc

N = 1000;
A = rand(N,N);
x = rand(1,N);

tic;
setup_AD();
admLogFile();
[J, f] = admDiffFor(@f_test, 1, x, A, admOptions('i', 1));
toc;
tic;
f_test(x,A);
toc;
J;
f;

%The following stands on its own.
tic;
[f, J] =  eval_AD(@f_test, x, A);
toc;


%This is differentiating numerical integration by cumulative trapezoidal
trap_nodes = 0:.001:1;
%trap_out = cumsimps(trap_nodes, arrayfun(@(z) z.^(1/2), trap_nodes));
trap_out = cumtrapz(trap_nodes, arrayfun(@(z) z.^(1/2), trap_nodes));
analytical_out = arrayfun(@(z) 2/3 * z.^(3/2),trap_nodes);
max(abs(analytical_out - trap_out))

x_0 = 1;
f_trap_test(x_0, trap_nodes);
tic;
[f, J] =  eval_AD(@f_trap_test, x_0, trap_nodes); %Can differentiate...
toc;
%Trying trapesoidal and simpsons rules. trying something like http://www.biomecardio.com/matlab/cumsimps.m
%Tricky to differentiate code in multiple directories: https://adimat.sc.informatik.tu-darmstadt.de/doc/adimat-5.html

