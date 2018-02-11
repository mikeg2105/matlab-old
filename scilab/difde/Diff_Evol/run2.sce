
// Initialization and run of differential evolution optimizer
// a more complex version with more explicit parameters is in run.m
//
getf('DiffEvol.sci')    // Differential Evolution function [adapt PATH]
getf('rosen.sci')       // Function to minimize            [adapt PATH]

// Here for Rosenbrock's function
// Change relevant entries to adapt to your personal applications
//

// VTR		"Value To Reach" (stop when function value < VTR)
		VTR = 1.e-6; 

// D		number of parameters of the objective function 
		D = 2; 

// XVmin,XVmax  column vector of lower and upper bounds of an initial population
//    		the algorithm seems to work well only if [XVmin,XVmax] 
//    		covers the region where the global minimum is expected
//               *** note: these are no bound constraints!! ***
		XVmin = [-2;-2]; 
		XVmax = [2;2];

[x,f,nf] = DiffEvol(rosen,VTR,D,XVmin,XVmax)

