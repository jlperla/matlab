% $Rev: 1 $
% $Date: 2015-01-29 15:42:05 -0800 (Thu, 29 Jan 2015) $
% $LastChangedBy: jlperla $

% Author: Jesse Perla (c) 2014
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)


function [f_val, J] = eval_AD(f, x, varargin)
    setup_AD(); %If already setup, does nothing
    [J, f_val] = admDiffFor(f, 1, x, varargin{:}, admOptions('i', 1));
    
    %This is for testing of the underlying function
    %f_val = f(x, varargin{:});J = 0;
end