//function myscijob()

	a=rand(5,5);
	b=rand(5,1);
	A=sparse(a);
	
	[h,rk]=lufact(A);
	x=lusolve(h,b);
	
	res=a*x-b
	
	fprintfMat('myscitest.dat',x);
	
	exit();

//endfunction