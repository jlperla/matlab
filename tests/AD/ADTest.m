%ADI Test
clear all
clc
% Comment this in to test out the matrix product.  Not working.
% val = [1 0];
% A = [1 0; 0 1];
% x = initVariablesADI(val);
% y = A * x;
% y.val
% full(y.jac{1})

val = [1; 2; 3];
x = initVariablesADI(val);
y = x.*[4; 5; 6];
y.val
full(y.jac{1})

z = sum(x.*x);
z.val
full(z.jac{1})

q = sum(x .* [4; 5; 6;]);
q.val
full(q.jac{1})

disp 'new operations'

q = x * x;
q.val
full(q.jac{1})

q = x * [4; 5; 6];
q.val
full(q.jac{1})

q = [4; 5; 6] * x;
q.val
full(q.jac{1})

