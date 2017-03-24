% $Rev: 1 $
% $Date: 2015-01-29 15:42:05 -0800 (Thu, 29 Jan 2015) $
% $LastChangedBy: jlperla $

% Author: Jesse Perla (c) 2014
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)


function out = pad_right(str, n, pad_char) %path is not implemented yet, but is easy.
    if ~exist('n','var'), n = 3; end %Defaults to n=3
    if ~exist('padchar','var'), pad_char = 1; end %Defaults to char(1) in ascii
    out = [ str repmat(pad_char,1,n)];
end