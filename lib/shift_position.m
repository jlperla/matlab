%Use with legends, etc.  For example,
function shift_position(leg,shift)
    a = get(leg, 'position');
    new_a = a;
    new_a = new_a + shift;
    set(leg, 'position', new_a);
end

