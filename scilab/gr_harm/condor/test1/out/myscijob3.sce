//function myscijob()

	a=rand(20,20);
	b=rand(20,1);
	A=sparse(a);
	
	[h,rk]=lufact(A);
	x=lusolve(h,b);
	
	res=a*x-b
	
	fprintfMat('myscitest3.dat',x);
	
	exit();

//endfunction
