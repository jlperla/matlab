% $Rev: 1 $
% $Date: 2015-01-29 15:42:05 -0800 (Thu, 29 Jan 2015) $
% $LastChangedBy: jlperla $

% Author: Jesse Perla (c) 2012
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

init_lib();
clear variables;

f = @(x) x^2;
f2 = @(x) x^2 + 1;

%First function
[f_mem f_cache] = memoize(f);
assert(test_close(f_mem(1), 1));
assert(test_close(f_mem(1), 1));
assert(test_close(f_mem(2), 4));
assert(test_close(f_mem(2), 4));
assert(length(f_cache) == 2);

%Second function
[f2_mem f2_cache] = memoize(f2);
assert(length(f_cache) == 2);
assert(length(f2_cache) == 0);
assert(test_close(f2_mem(1), 2));
assert(test_close(f_mem(1), 1));
assert(length(f_cache) == 2);
assert(length(f2_cache) == 1);
assert(test_close(f2_mem(2), 5));
assert(test_close(f2_mem(2), 5));

%Temporary function, not returning cache
f3_mem = memoize(@(x) x^2);
assert(test_close(f3_mem(1), 1));
assert(test_close(f3_mem(1), 1));
assert(test_close(f3_mem(2), 4));
assert(test_close(f3_mem(2), 4));

%Temporary function, not returning cache
f4_mem = memoize(@(x,y) x + y);
assert(test_close(f4_mem(1,1), 2));
assert(test_close(f4_mem(1,1), 2));
assert(test_close(f4_mem(1,2), 3));
assert(test_close(f4_mem(2,4), 6));
assert(test_close(f4_mem(2,4), 6));