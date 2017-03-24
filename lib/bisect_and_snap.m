% $Rev: 1 $
% $Date: 2015-01-29 15:42:05 -0800 (Thu, 29 Jan 2015) $
% $LastChangedBy: jlperla $

% Author: Jesse Perla (c) 2012
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

%Calls compecon bisection routine, but snaps the arguments to the boundaries.
%NOTE: THE SNAPPING ASSUMES STRICT MONOTONICITY IN CHOOSING WHICH CORNER

function result = bisect_and_snap(f, a, b)
    assert(b >= a); %Requires the interval to be ordered
    
    %Get the function values at the corners
    f_a = f(a);
    f_b = f(b);
    is_increasing = (f(b) > f(a)); %True if an increasing function.  Monotonicity is assumed in this routine.
    
    %Checking cases for whether snapping should occur or else bisection.
    if(test_close(a,b)) %If a=b, then don't call bisection and return the shared value
        result = a;
    elseif(f_a > 0 && f_b > 0) %Both positive
        if(is_increasing)
            result = a; %choose left since assuming monotonically increasing
        else
            result = b; %Decreasing
        end        
    elseif(f_a < 0 && f_b < 0) 
        if(is_increasing)
            result = b; %Choose right since negative and increasing
        else
            result = a; %Choose left since decreasing
        end        
    else %The root is bracketed, use compecon bisection.
        %Note: compecon will scale the tolerance by (a-b)/2.  So if b is large, then the precision becomes very small.
        %To fix this, we will descale the tolerance first then reset it
        tol_temp = optget('bisect','tol',1e-4);
        optset('bisect','tol',tol_temp / abs(a-b)); %Make it much smaller
        result = bisect(f, a, b); %Right bracket on the root finder is the maximum possible kink location.  Using CompEcon bisection routine.
        optset('bisect','tol',tol_temp); %Saves it back again
    end

end