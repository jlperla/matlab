% $Rev: 1 $
% $Date: 2015-01-29 15:42:05 -0800 (Thu, 29 Jan 2015) $
% $LastChangedBy: jlperla $

% Author: Jesse Perla (c) 2012
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)


%Equivalent to ternary operator ? in C and C++

function ret = ifthenelse(condition, truevalue, falsevalue)
    if(condition)
        ret = truevalue;
    else
        ret = falsevalue;
    end
end