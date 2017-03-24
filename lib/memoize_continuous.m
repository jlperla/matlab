% $Rev: 19 $
% Author: Jesse Perla (c) 2012
% Use, modification and distribution are subject to the 
% Boost Software License, Version 1.0. (See accompanying file 
% LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

function [fmem cache] = memoize_continuous(f, epsilon, array_valued)
nin = nargin(f); %See uf there is a unary specialization
if(nin==1)
    if nargin == 3 %Check if array valued.
        value_type_text = ifthenelse(array_valued, 'any', 'double');    
    else
        value_type_text = 'double';
    end
    store = containers.Map('KeyType', 'int64', 'ValueType', value_type_text);
    fmem = @memo_unary;
    cache = store;
elseif(nin==2)
   store = MapN('uniformvalues', true);    
    fmem = @memo_binary;
    cache = store;
else
    store = MapN('uniformvalues', true);    
    fmem = @memo1;
    cache = store;
end

    function v = memo1(varargin)
        %varargin = floor(real_varargin / epsilon); %Rounds down. Later, put in different epsilon per parameter
        %The above doesn't work as cells cannot be divided.  The following converts from cell to vector, does operation, then converts back.  It is likely not very efficient, but works.
        int_varargin = mat2cell(floor(cell2mat(varargin)./epsilon), [1],ones(length(varargin),1));        
        
        % One result returned, so can be stored as is
        if isKey(store, int_varargin{:})
            v = store(int_varargin{:});
        else
            v = f(varargin{:});
            store(int_varargin{:}) = v;
        end
    end

    function out = memo_unary(real_arg)
        arg = floor(real_arg / epsilon);
        if store.isKey(arg)
            out = store(arg);
        else
            out = f(real_arg);
            store(arg) = out;
        end
    end

    function v = memo_binary(x1, x2)
        int_varargin = {floor(x1/epsilon), floor(x2/epsilon)}; %To a cell
        if isKey(store, int_varargin{:})
            v = store(int_varargin{:});
        else
            v = f(x1,x2);
            store(int_varargin{:}) = v;
        end
    end


end