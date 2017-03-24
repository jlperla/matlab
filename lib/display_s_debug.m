% $Rev: 1 $
% Author: Jesse Perla (c) 2012
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

function display_s_debug(is_debug, varargin)
	if(is_debug == true)
		display_s(varargin{:});
	end
end %