% $Rev: 1 $
% Author: Jesse Perla (c) 2012
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

init_lib();

f = @(x) x;
assert( test_close(bisect_and_snap(f, -1, 1), 0.0)); %Should find the root
assert( test_close(bisect_and_snap(f, -1, -.5), -.5)); %Should pick the right bound
assert( test_close(bisect_and_snap(f, .5, 1), .5)); %Should pick the left bound
assert( test_close(bisect_and_snap(f, 1, 1), 1)); %Null interval, just returns the value directly.

f = @(x) -x;
assert( test_close(bisect_and_snap(f, -1, 1), 0.0)); %Should find the root
assert( test_close(bisect_and_snap(f, -1, -.5), -.5)); %Should pick the right bound
assert( test_close(bisect_and_snap(f, .5, 1), .5)); %Should pick the left bound
assert( test_close(bisect_and_snap(f, 1, 1), 1)); %Null interval, just returns the value directly.

