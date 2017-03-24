mathematica_for_matlab('quit')

pause(1)

mathematica_for_matlab('$Version')

mathematica_for_matlab('N[EulerGamma,40]')

mathematica_for_matlab('Integrate[Log[x]^(3/2),x]')

mathematica_for_matlab('InputForm[Integrate[Log[x]^(3/2),x]]')

mathematica_for_matlab('matlab2math', 'hilbert',hilb(20))

mathematica_for_matlab('{Dimensions[hilbert],Det[hilbert]}')

mathematica_for_matlab('exactHilbert = Table[1/(i+j-1),{i,20},{j,20}];')

mathematica_for_matlab('Det[exactHilbert]')

mathematica_for_matlab('N[Det[exactHilbert], 40]')

mathematica_for_matlab('invHilbert = Inverse[hilbert];')

hilbert=mathematica_for_matlab('math2matlab', 'invHilbert');
diag(hilbert)

disp('Passing and retrieving a scalar')
mathematica_for_matlab('a=2')
b=3;
mathematica_for_matlab('matlab2math','b',b)
mathematica_for_matlab('b')
mathematica_for_matlab('b[[1,1]]')
aa=mathematica_for_matlab('math2matlab','{{a}}')


mathematica_for_matlab('quit')