% $Rev: 1 $
% $Date: 2015-01-29 15:42:05 -0800 (Thu, 29 Jan 2015) $
% $LastChangedBy: jlperla $

% Author: Jesse Perla (c) 2014
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)


function h_legend = pad_legend(legend_text, n_pad) %path is not implemented yet, but is easy.
    if ~exist('n_pad','var'), n_pad = 3; end %Defaults to n=3
    [~,h_legend,~,~] = legend(repmat('!',1,n_pad));  % display a legend of 10 characters
    set(h_legend(1), 'String', legend_text);          % change its String to 1 character
end