% $Rev: 1 $
% $Date: 2015-01-29 15:42:05 -0800 (Thu, 29 Jan 2015) $
% $LastChangedBy: jlperla $

% Author: Jesse Perla (c) 2012, 2013
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

%Numerically integrates a function given a set of intervals.
%Converted to use matlab's new 'integral' after extracting options

function result = integrate(f, min_val, max_val, intervals) %intervals is optional set of waypoints
    %See matlab's 'integral'
	AbsTol = optget('integrate','AbsTol', 1e-10);
    RelTol = optget('integrate','RelTol', 1e-6);

    if(exist('intervals', 'var'))
        Waypoints = intervals;
    else
        Waypoints = [];
    end

    %Call matlab's integral directly.
    result = integral(f, min_val, max_val, 'AbsTol',AbsTol, 'RelTol', RelTol, 'Waypoints', Waypoints);
end