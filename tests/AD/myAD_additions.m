
init_lib();

%Create a variable
x_val = [.5; .2];
x = myAD(x_val);
c = [1 2];

%Do it the normal way
outAD = sum(c'.* x); %x_val are always column?
val_sum = getvalue(outAD)
deriv_sum = getderivs(outAD)

%Use the new dot product
outAD = c * x;
assert(val_sum == getvalue(outAD))
assert(max(deriv_sum - getderivs(outAD)) == 0)

%Doing x with itself.  No problem
outAD = sum(x'.* x); %x_val are always column?
val_sum = getvalue(outAD)
deriv_sum = getderivs(outAD)

outAD = x' * x;
assert(val_sum == getvalue(outAD))
assert(max(deriv_sum - getderivs(outAD)) == 0)

%Matrix multiplication is not working
% A = [1 2; 2 1];
% outAD = x * A
% getvalue(outAD);