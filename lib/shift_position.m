%Use with legends, etc.  For example,
function shift_position(obj,shift)
    obj.Units = 'normalized'; %Need to have normalized units or trick.
    obj.Position = obj.Position + shift;
end

