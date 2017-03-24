% $Rev: 1 $
% Author: Jesse Perla (c) 2010
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

%Takes in a vector and returns a copy without any NaN values
function ret = var_remove_nan(mat)
	[rows columns] = size(mat);
    %Emulates the normal mean, which is column-wise
    ret = zeros(columns,1);
    for i=1:columns
        ret(i) = var(remove_nan(mat(:, i)));
    end
    ret = ret';
end
