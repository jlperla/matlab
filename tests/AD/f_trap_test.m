function f = f_trap_test(x, trap_nodes)
    vals = trap_nodes.^(1/2);
    f = x * cumtrapz(trap_nodes, vals);
    %f = x * cumsimps(trap_nodes, vals);
    %f = x * vals;
end