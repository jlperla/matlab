% $Rev: 41 $
% $Date: 2015-11-20 21:56:40 -0800 (Fri, 20 Nov 2015) $
% $LastChangedBy: jlperla $

% Author: Jesse Perla (c) 2015
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

function out = output_part_cached(i, n_out, f, x) %Only supports one argument for now...  Ugly, but nargout doesn't work for anonymous functions.
    persistent x_val all_out f_handle;
    
    if(isempty(x_val)|| any(x ~= x_val) || (~isequal(f_handle, f)))
        
        %Trouble with matlab 2015a with the generic code, doing temporary specialization        
        %[all_out{1:n_out}] = f(x);
        assert(n_out == 2);
        [all_out{1} all_out{2}] = f(x);
        
        x_val = x; %Store the value
        f_handle = f; %Store the handle
    end
    out = all_out{i}; %Return the appropriate one.
end
