//function myscijob()

	a=rand(25,25);
	b=rand(25,1);
	A=sparse(a);
	
	[h,rk]=lufact(A);
	x=lusolve(h,b);
	
	res=a*x-b
	
	fprintfMat('myscitest4.dat',x);
	
	exit();

//endfunction
