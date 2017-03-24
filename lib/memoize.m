% $Rev: 1 $
% Author: Jesse Perla (c) 2012
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

function [fmem cache] = memoize(f)
nin = nargin(f); %there is a unary specialization
if(nin > 1)
    store = MapN('uniformvalues', true);    
    fmem = @memo1;
    cache = store;
else
    store = containers.Map('KeyType', 'int64', 'ValueType', 'double');
    fmem = @memo_unary;
    cache = store;
end

    function v = memo1(varargin)
        % One result returned, so can be stored as is
        if isKey(store, varargin{:})
            v = store(varargin{:});
        else
            v = f(varargin{:});
            store(varargin{:}) = v;
        end
    end

    function out = memo_unary(arg)
        if store.isKey(arg)
            out = store(arg);
        else
            out = f(arg);
            store(arg) = out;
        end
    end

end