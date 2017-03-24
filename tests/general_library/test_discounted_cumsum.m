% $Rev: 1 $
% Author: Jesse Perla (c) 2010
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

%Takes in a vector and returns a copy without any NaN values

A = [1 2 3 4 NaN NaN];
ret = discounted_cumsum(A, 1.0, .99)
%Should assert....
