% $Rev: 1 $
% $Date: 2015-01-29 15:42:05 -0800 (Thu, 29 Jan 2015) $
% $LastChangedBy: jlperla $

% Author: Jesse Perla (c) 2014
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

function unpack_fields_to_variables(params) %This unpacks parameters into a list of variables of the same name.  THIS IS GENERALLY DANGEROUS AND A BAD IDEA!
    fields = fieldnames(params);
    for i = 1:numel(fields)
      assignin('caller', fields{i}, params.(fields{i}))
    end
end