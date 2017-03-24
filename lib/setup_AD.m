% $Rev: 40 $
% $Date: 2015-11-18 12:28:58 -0800 (Wed, 18 Nov 2015) $
% $LastChangedBy: jlperla $

% Author: Jesse Perla (c) 2014
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)


function out = setup_AD() %path is not implemented yet, but is easy.
	if(length(getenv('ADIMAT_HOME')) == 0)
		addpath('C:/working/libraries/etk_matlab/adimat/runtime');
        addpath('C:/working/libraries/etk_matlab/adimat');
		setenv('ADIMAT_HOME', 'C:/working/libraries/etk_matlab/adimat');
        setenv('PATH', [getenv('PATH') pathsep 'C:\working\libraries\etk_matlab']);
		ADiMat_startup
        out = true;
    else
        out = false; %already setup
        
    end
end