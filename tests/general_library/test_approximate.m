% $Rev: 1 $
% Author: Jesse Perla (c) 2012
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

init_lib();

f = @(x) 2.0 * x;
nodes = 0:.1:1;
values = arrayfun(f, nodes);
f_approx = approximate(f, values);

assert(test_close(f_approx(0.0), f(0.0)));
assert(test_close(f_approx(0.1), f(0.1)));
assert(test_close(f_approx(0.212), f(0.212)));
assert(test_close(f_approx(1.0), f(1.0)));

%Check extrapolation as well. Will work OK linear...
assert(test_close(f_approx(1.1), f(1.1)));

display('test complete');