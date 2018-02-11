function [optarg,optval,nfeval] = DiffEvol(fct,VTR,D,XVmin,XVmax,USERDATA,NP,...
                                               itermax,F,CR,strategy,report);
// minimization of a user-supplied function with respect to x(1:D),
// using the differential evolution (DE) algorithm of Rainer Storn
// (http://www.icsi.berkeley.edu/~storn/code.html)
// 
// Special thanks go to Ken Price (kprice@solano.community.net) and
// Arnold Neumaier (http://solon.cma.univie.ac.at/~neum/) for their
// valuable contributions to improve the code.
// 
// Strategies with exponential crossover, further input variable
// tests, and arbitrary function name implemented by Jim Van Zandt 
// <jrv@vanzandt.mv.com>, 12/97.
//
// Scilab version by Walter Di Carlo <walter.dicarlo@jrc.it> 03/04/99
// modified by Helmut Jarausch <jarausch@igpm.rwth-aachen.de> 2006/03/01
//
// See also http://www.icsi.berkeley.edu/~storn/deshort1.ps
//
// Output arguments:
// ----------------
// optarg         parameter vector with best solution
// optval         best objective function value
// nfeval         number of function evaluations
//
// Input arguments:  
// ---------------
//
// fct            cost function fct(x,USERDATA) to minimize
// VTR            "Value To Reach". DiffEvol will stop its minimization
//                if either the maximum number of iterations "itermax"
//                is reached or the best parameter vector "optarg" 
//                has found a value f(optarg,y) <= VTR.
// D              number of parameters of the objective function 
// XVmin          vector of lower bounds XVmin(1) ... XVmin(D)
//                of initial population
//                *** note: these are not bound constraints!! ***
// XVmax          vector of upper bounds XVmax(1) ... XVmax(D)
//                of initial population
// USERDATA	  problem data vector which is passed transparently to
//                the cost function fct
// NP             number of population members
// itermax        maximum number of iterations (generations)
// F              DE-stepsize F from interval [0, 2]
//                for strategies 3 and 8 this has 2 components
// CR             crossover probability constant from interval [0, 1]
// strategy       1 --> DE/best/1/exp           6 --> DE/best/1/bin
//                2 --> DE/rand/1/exp           7 --> DE/rand/1/bin
//                3 --> DE/rand-to-best/1/exp   8 --> DE/rand-to-best/1/bin
//                4 --> DE/best/2/exp           9 --> DE/best/2/bin
//                5 --> DE/rand/2/exp           else  DE/rand/2/bin
//                Experiments suggest that /bin likes to have a slightly
//                larger CR than /exp.
// report         intermediate output will be produced after "report"
//                iterations. No intermediate output will be produced
//                if report is < 1
//
//       The first four arguments are essential (though they have
//       default values, too). In particular, the algorithm seems to
//       work well only if [XVmin,XVmax] covers the region where the
//       global minimum is expected. DE is also somewhat sensitive to
//       the choice of the stepsize F. A good initial guess is to
//       choose F from interval [0.5, 1], e.g. 0.8. CR, the crossover
//       probability constant from interval [0, 1] helps to maintain
//       the diversity of the population and is rather uncritical. The
//       number of population members NP is also not very critical. A
//       good initial guess is 10*D. Depending on the difficulty of the
//       problem NP can be lower than 10*D or must be higher than 10*D
//       to achieve convergence.
//       If the parameters are correlated, high values of CR work better.
//       The reverse is true for no correlation.
//
// default values in case of missing input arguments:
// 	VTR = 1.e-6;
// 	D = 2; 
// 	XVmin = [-2 -2]'; 
// 	XVmax = [2 2]'; 
//	y=[];
// 	NP = 10*D; 
// 	itermax = 200; 
// 	F = [0.8;0.6]; 
// 	CR = 0.5; 
// 	strategy = 7;
// 	report = 10; 
//
// Cost function:  	function result = f(x,y);
//                      	has to be defined by the user and is minimized
//			w.r. to  x(1:D).
//
// Example to find the minimum of the Rosenbrock saddle:
// ----------------------------------------------------
// Define f.m as:
//                    function result = f(x,y);
//                    result = 100*(x(2)-x(1)^2)^2+(1-x(1))^2;
//                    end
// Then type:
//
// 	VTR = 1.e-6;
// 	D = 2; 
// 	XVmin = [-2 -2]; 
// 	XVmax = [2 2]; 
// 	[optarg,optval,nfeval] = DiffEvol(f,VTR,D,XVmin,XVmax);
//
// The same example with a more complete argument list is handled in 
// run1.m
//
// Constraints can be added by an L1 penalty function
//
// About DiffEvol.m
// --------------
// Differential Evolution for MATLAB
// Copyright (C) 1996, 1997 R. Storn
// International Computer Science Institute (ICSI)
// 1947 Center Street, Suite 600
// Berkeley, CA 94704
// E-mail: storn@icsi.berkeley.edu
// WWW:    http://http.icsi.berkeley.edu/~storn
//
// devec is a vectorized variant of DE which, however, has a
// propertiy which differs from the original version of DE:
// 1) The random selection of vectors is performed by shuffling the
//    population array. Hence a certain vector can't be chosen twice
//    in the same term of the perturbation expression.
//
// Due to the vectorized expressions DiffEvol executes fairly fast
// in MATLAB's interpreter environment.
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 1, or (at your option)
// any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details. A copy of the GNU 
// General Public License can be obtained from the 
// Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.


mode(0);

//Check input variables---------------------------------------------
err=[];
nargin = argn(2);
if nargin<1, error('DiffEvol 1st argument must be function name'); else 
  if type(fct) ~= 13; err(1,length(err)+1)=1; end; end;
if nargin<2, VTR = 1.e-6; else 
  if length(VTR)~=1; err(1,length(err)+1)=2; end; end;
if nargin<3, D = 2; else
  if length(D)~=1; err(1,length(err)+1)=3; end; end; 
if nargin<4, XVmin = [-2 -2]';else
  if size(XVmin,1)~=D; err(1,length(err)+1)=4; end; end; 
if nargin<5, XVmax = [2 2]'; else
  if size(XVmax,1)~=D; err(1,length(err)+1)=5; end; end; 
if nargin<6, y=[]; end; 
if nargin<7, NP = 10*D; else
  if length(NP)~=1; err(1,length(err)+1)=7; end; end; 
if nargin<8, itermax = 200; else
  if length(itermax)~=1; err(1,length(err)+1)=8; end; end; 
if nargin<11, strategy = 7; else
  if length(strategy)~=1; err(1,length(err)+1)=11; end; end;
if nargin<9, F = [0.8;0.6]; else
  if modulo(strategy,5) == 3
    if length(F)~=2; err(1,length(err)+1)=9; end;
    Lam= F(2);
  else
    if length(F)~=1; err(1,length(err)+1)=9; end;
  end
end;
F= F(1);
if nargin<10, CR = 0.5; else
  if length(CR)~=1; err(1,length(err)+1)=10; end; end; 
if nargin<12, report = 10; else
  if length(report)~=1; err(1,length(err)+1)=12; end; end; 


if length(err)>0
  printf('error in parameter %d\n', err);
  x_message('DiffEvol (function,scalar,scalar,vector,vector,any,integer,integer,scalar,scalar,integer,integer)');    	
end;

if (NP < 5)
   NP=5;
   printf(' NP increased to minimal value 5\n');
end;
if ((CR < 0) | (CR > 1))
   CR=0.5;
   printf('CR should be from interval [0,1]; set to default value 0.5\n');
end;
if (itermax <= 0)
   itermax = 200;
   printf('itermax should be > 0; set to default value 200\n');
end;
report = floor(report);

//-----Initialize population and some arrays-------------------------------

pop = zeros(D,NP); //initialize pop to gain speed

//----pop is a matrix of size NPxD. It will be initialized-------------
//----with random values between the min and max values of the---------
//----parameters-------------------------------------------------------

for i=1:NP
   pop(:,i) = XVmin + rand(D,1).*(XVmax - XVmin);
end;

popold    = zeros(pop);           // toggle population
val       = zeros(NP,1);          // create and reset the "cost array"
optarg   = zeros(D,1);           // best population member ever
optargit = zeros(D,1);           // best population member in iteration
nfeval    = 0;                    // number of function evaluations

//------Evaluate the best member after initialization----------------------

ibest   = 1;                      // start with first population member
  val(1) = fct(pop(:,ibest),y);

optval = val(1);                 // best objective function value so far
nfeval  = nfeval + 1;
for i=2:NP                        // check the remaining members
  val(i) = fct(pop(:,i),y);
  nfeval  = nfeval + 1;
  if (val(i) < optval)           // if member is better
     ibest   = i;                 // save its location
     optval = val(i);
  end;
end;
optargit = pop(:,ibest);         // best member of current iteration
optvalit = optval;              // best value of current iteration

optarg = optargit;              // best member ever

//------DE-Minimization---------------------------------------------
//------popold is the population which has to compete. It is--------
//------static through one iteration. pop is the newly--------------
//------emerging population.----------------------------------------

pm1 = zeros(D,NP);              // initialize population matrix 1
pm2 = zeros(D,NP);              // initialize population matrix 2
pm3 = zeros(D,NP);              // initialize population matrix 3
pm4 = zeros(D,NP);              // initialize population matrix 4
pm5 = zeros(D,NP);              // initialize population matrix 5
bm  = zeros(D,NP);              // initialize optargber  matrix
ui  = zeros(D,NP);              // intermediate population of perturbed vectors
mui = zeros(D,NP);              // mask for intermediate population
mpo = zeros(D,NP);              // mask for old population
rot = (0:1:NP-1)';              // rotating index array (size NP)
rotd= (0:1:D-1)';               // rotating index array (size D)
rt  = zeros(NP,1);              // another rotating index array
rtd = zeros(D,1);               // rotating index array for exponential crossover
a1  = zeros(NP,1);              // index array
a2  = zeros(NP,1);              // index array
a3  = zeros(NP,1);              // index array
a4  = zeros(NP,1);              // index array
a5  = zeros(NP,1);              // index array
ind = zeros(4,1);

iter = 1;
while ((iter < itermax) & (optval > VTR))
  popold = pop;                   // save the old population

  ind = grand(1,'prm',(1:4)');    // index pointer array

  a1  = grand(1,'prm',(1:NP)');   // shuffle locations of vectors
  rt = modulo(rot+ind(1),NP);     // rotate indices by ind(1) positions
  a2  = a1(rt+1);                 // rotate vector locations
  rt = modulo(rot+ind(2),NP);
  a3  = a2(rt+1);                
  rt = modulo(rot+ind(3),NP);
  a4  = a3(rt+1);               
  rt = modulo(rot+ind(4),NP);
  a5  = a4(rt+1);                

  pm1 = popold(:,a1);             // shuffled population 1
  pm2 = popold(:,a2);             // shuffled population 2
  pm3 = popold(:,a3);             // shuffled population 3
  pm4 = popold(:,a4);             // shuffled population 4
  pm5 = popold(:,a5);             // shuffled population 5

// population filled with the best member
  bm= optargit*ones(1,NP);        // of the last iteration
  
//  for i=1:NP                      
//    bm(:,i) = optargit;          // of the last iteration
//  end;

  mui = (rand(D,NP) < CR) * 1;          // all random numbers < CR are 1, 0 otherwise

  if (strategy > 5)
    st = strategy-5;		  // binomial crossover
  else
    st = strategy;		  // exponential crossover
    mui=sort(mui);	          // transpose, collect 1's in each column
    for i=1:NP
      n=floor(rand()*D);
      if n > 0
         rtd = modulo(rotd+n,D);
         mui(:,i) = mui(rtd+1,i); //rotate column i by n
      end;
    end;
  end;
  mpo = (mui < 0.5) * 1;                // inverse mask to mui

  select  st
  case 1                                  // DE/best/1
    ui = bm + F*(pm1 - pm2);              // differential variation
    ui = popold.*mpo + ui.*mui;           // crossover
  case 2                                  // DE/rand/1
    ui = pm3 + F*(pm1 - pm2);             // differential variation
    ui = popold.*mpo + ui.*mui;           // crossover
  case 3                                  // DE/rand-to-best/1
    ui = popold + Lam*(bm-popold) + F*(pm1 - pm2);        
    ui = popold.*mpo + ui.*mui;           // crossover
  case 4                                  // DE/best/2
    ui = bm + F*(pm1 - pm2 + pm3 - pm4);  // differential variation
    ui = popold.*mpo + ui.*mui;           // crossover
  else                                    // DE/rand/2
    ui = pm5 + F*(pm1 - pm2 + pm3 - pm4); // differential variation
    ui = popold.*mpo + ui.*mui;           // crossover
  end;

//-----Select which vectors are allowed to enter the new population------------
  for i=1:NP
    tempval = fct(ui(:,i),y);   // check cost of competitor
    nfeval  = nfeval + 1;
    if (tempval <= val(i))  // if competitor is better than value in "cost array"
       pop(:,i) = ui(:,i);  // replace old vector with new one (for new iteration)
       val(i)   = tempval;  // save value in "cost array"

       //----we update optval only in case of success to save time-----------
       if (tempval < optval)     // if competitor better than the best one ever
          optval = tempval;      // new best value
          optarg = ui(:,i);      // new best parameter vector ever
       end;
    end;
  end; //---end for imember=1:NP

  optargit = optarg;       // freeze the best member of this iteration for the coming 
                             // iteration. This is needed for some of the strategies.

//----Output section----------------------------------------------------------

  if (report > 0)
    if (modulo(iter,report) == 0)
       printf('Iteration: %d,  Best: %f,  F: %f,  CR: %f,  NP: %d\n',iter,optval,F,CR,NP);
       for n=1:D
         printf('best(%d) = %f\n',n,optarg(n));
       end;
    end;
  end;

  iter = iter + 1;
end; //---end while ((iter < itermax) ...
endfunction

