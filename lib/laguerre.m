%This program is a direct conversion of the corresponding Fortran program in
%S. Zhang & J. Jin "Computation of Special Functions" (Wiley, 1996).
%online: http://iris-lee3.ece.uiuc.edu/~jjin/routines/routines.html
%
%Converted by f2matlab open source project:
%online: https://sourceforge.net/projects/f2matlab/
% written by Ben Barrowes (barrowes@alum.mit.edu)

function [n,x,w]=laguerre(n,x,w,varargin);
%       =========================================================
%       Purpose : Compute the zeros of Laguerre polynomial Ln(x)
%                 in the interval[0,ì], and the corresponding
%                 weighting coefficients for Gauss-Laguerre
%                 integration
%       Input :   n    --- Order of the Laguerre polynomial
%                 X(n)--- Zeros of the Laguerre polynomial
%                 W(n)--- Corresponding weighting coefficients
%       =========================================================
hn=1.0d0./fix(n);
for  nr=1:n;
if(nr == 1)z=hn; end;
if(nr > 1)z=x(nr-1)+hn.*nr.^1.27; end;
it=0;
while (1);
it=it+1;
z0=z;
p=1.0d0;
for  i=1:nr-1;
p=p.*(z-x(i));
end;  i=nr-1+1;
f0=1.0d0;
f1=1.0d0-z;
for  k=2:n;
pf=((2.0d0.*k-1.0d0-z).*f1-(k-1.0d0).*f0)./k;
pd=k./z.*(pf-f1);
f0=f1;
f1=pf;
end;  k=fix(n)+1;
fd=pf./p;
q=0.0d0;
for  i=1:nr-1;
wp=1.0d0;
for  j=1:nr-1;
if(~(j == i))wp=wp.*(z-x(j)); end;
end;  j=nr-1+1;
q=q+wp;
end;  i=nr-1+1;
gd=(pd-q.*fd)./p;
z=z-fd./gd;
if(~(it <= 40&abs((z-z0)./z)> 1.0d-15))break; end;
end;
x(nr)=z;
w(nr)=1.0d0./(z.*pd.*pd);
end;