getf('DiffEvol.sci')    // Differential Evolution function [adapt PATH]
getf('rosen.sci')       // Function to minimize            [adapt PATH]

// Initialization and run of differential evolution optimizer.
// A simpler version with fewer explicit parameters is in run0.m
//
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

// y		problem data vector (will be passed to the user's function
//                                   transparently)
		y=[]; 

// NP           number of population members
		NP = 15; 

// itermax      maximum number of iterations (generations)
		itermax = 200; 

// F            DE-stepsize F ex [0, 2]
//              this has 2 components for stragies 3 and 8
		F = 0.8;

// CR           crossover probabililty constant ex [0, 1]
		CR = 0.8; 

// strategy       1 --> DE/best/1/exp           6 --> DE/best/1/bin
//                2 --> DE/rand/1/exp           7 --> DE/rand/1/bin
//                3 --> DE/rand-to-best/1/exp   8 --> DE/rand-to-best/1/bin
//                4 --> DE/best/2/exp           9 --> DE/best/2/bin
//                5 --> DE/rand/2/exp           else  DE/rand/2/bin

		strategy = 7

// report       intermediate output will be produced after "report"
//              iterations. No intermediate output will be produced
//              if report is < 1
		report = 10; 

[x,f,nf] = DiffEvol(rosen,VTR,D,XVmin,XVmax,y,NP,itermax,F,CR,strategy,report)

