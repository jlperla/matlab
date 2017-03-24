% $Rev: 1 $
% Author: Jesse Perla (c) 2012
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

clear; init_lib();
cache_epsilon = 0.1;

f = @(x) x^2;

%First function
[f_mem f_cache] = memoize_continuous(f, cache_epsilon);
assert(test_close(f_mem(1), 1));
assert(test_close(f_mem(1), 1));
assert(test_close(f_mem(2), 4));
assert(test_close(f_mem(2), 4));
assert(length(f_cache) == 2);
assert(test_close(f_mem(2.5), 6.25));
assert(length(f_cache) == 3);
assert(test_close(f_mem(2.55), 6.25));
assert(length(f_cache) == 3);
assert(test_close(f_mem(2.61),  6.8121));
assert(test_close(f_mem(2.605),  6.8121));
assert(test_close(f_mem(2.615),  6.8121));
assert(length(f_cache) == 4);

%A binary function
[f2_mem f2_cache] = memoize_continuous(@(x,y) x + y, cache_epsilon);

assert(test_close(f2_mem(1,1.1), 2.1));
assert(test_close(f2_mem(1,1.1), 2.1));
assert(test_close(f2_mem(2,1.1), 3.1));
assert(test_close(f2_mem(2,1.1), 3.1));
assert(length(f2_cache) == 2);
assert(test_close(f2_mem(2.5,1.1), 3.6));
assert(length(f2_cache) == 3);
assert(test_close(f2_mem(2.55,1.1), 3.6));
assert(length(f2_cache) == 3);
assert(test_close(f2_mem(2.61,1.1),  3.71));
assert(test_close(f2_mem(2.605,1.1),  3.71));
assert(test_close(f2_mem(2.615,1.1),  3.71));
assert(length(f2_cache) == 4);
assert(test_close(f2_mem(1.05,1.1), 2.1));
assert(length(f2_cache) == 4);
assert(test_close(f2_mem(1.4,1.1), 2.5));
assert(length(f2_cache) == 5);
assert(test_close(f2_mem(1.8,2.1), 3.9));
assert(length(f2_cache) == 6);

%Trinary
f3 = memoize_continuous(@(x,y,z) x + y + z, cache_epsilon);
assert(test_close(f3(1,2,3.11),1 + 2 + 3.11));
assert(test_close(f3(1,2,3.111),1 + 2 + 3.11));
assert(test_close(f3(2,2,3.11),2 + 2 + 3.11));
