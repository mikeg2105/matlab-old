//function myscijob()

	a=rand(15,15);
	b=rand(15,1);
	A=sparse(a);
	
	[h,rk]=lufact(A);
	x=lusolve(h,b);
	
	res=a*x-b
	
	fprintfMat('myscitest2.dat',x);
	
	exit();

//endfunction
