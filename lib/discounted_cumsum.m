% $Rev: 1 $
% Author: Jesse Perla (c) 2010
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

function ret = discounted_cumsum(vec, initial_discount, discount_factor)
    ret(1) = initial_discount * vec(1);
	for i=2:length(vec)
        ret(i) = ret(i-1) + discount_factor * vec(i);
    end
end
