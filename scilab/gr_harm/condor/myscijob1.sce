//function myscijob()

	a=rand(10,10);
	b=rand(10,1);
	A=sparse(a);
	
	[h,rk]=lufact(A);
	x=lusolve(h,b);
	
	res=a*x-b
	
	fprintfMat('myscitest1.dat',x);
	
	exit();

//endfunction
