% $Rev: 19 $
% $Date: 2015-07-15 16:22:07 -0700 (Wed, 15 Jul 2015) $
% $LastChangedBy: jlperla $

% Author: Jesse Perla (c) 2015
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

function out = part(A, i, j) %only works with matrices and vectors for now.
if nargin == 3
    out = A(i, j);
else
    out = A(i);
end