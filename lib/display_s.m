% $Rev: 1 $
% Author: Jesse Perla (c) 2012
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

%Wrapper to display using sprintf instead of just disp.
function DispQS(varargin)
	disp(sprintf(varargin{1},varargin{2:end}));
end %