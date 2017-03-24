% $Rev: 36 $
% $Date: 2015-11-09 17:02:25 -0800 (Mon, 09 Nov 2015) $
% $LastChangedBy: jlperla $

% Author: Jesse Perla (c) 2015
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

function out = output_part(i, f, varargin)
    [all_out{1:nargout(f)}] = f(varargin{:});
    out = all_out{i};
end