% $Rev: 1 $
% Author: Jesse Perla (c) 2010
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

%Takes in a vector and returns a copy without any NaN values
function ret = remove_nan(vec)
    [rows columns] = size(vec);
    
    %If this is a vector, do the vector routine
    if (rows == 1 || columns == 1)
    	ret = vec(~isnan(vec));
    else

        %Otherwise, it is a matrix so remove rows by default.
        %find the rows and columns of the isnan elements.
        [nan_rows nan_columns] = find(isnan(vec));

        %Get the rows that are not in this list
        good_rows = setdiff(1:rows, sort(unique(nan_rows)));

        %Return these rows from the vector and all columns
        ret = vec(good_rows, :);
    end
end
