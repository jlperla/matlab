% $Rev: 1 $
% $Date: 2015-01-29 15:42:05 -0800 (Thu, 29 Jan 2015) $
% $LastChangedBy: jlperla $

% Author: Jesse Perla (c) 2014
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

function val = min_value_below_threshold_argument(f, args, threshold) %Assumes sorted.
    f_vals = arrayfun(f, args);
    index = find(f_vals < threshold, 1, 'first');
    if(isempty(index))
        val = NaN;
    else
        val = args(index); %Note that this is passing back the value of the argument, not the value of the function!
    end
end