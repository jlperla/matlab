% $Rev: 1 $
% $Date: 2015-01-29 15:42:05 -0800 (Thu, 29 Jan 2015) $
% $LastChangedBy: jlperla $

% Author: Jesse Perla (c) 2014
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

function out_matrix = array_fun_matrix(f, vals) %Arrayfun doesn't work with R -> R^M functions.
%Vals needs to be a row vector or matrix
    for i=1:size(vals,1)
        f_val = f(vals(i,:));
        if(size(f_val,1) > 1) %Need to stack up rows, so convert as required.
            f_val = f_val';
        end
        out_matrix(i,:) = f_val;
    end
end