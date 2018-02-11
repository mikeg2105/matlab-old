// Zimmermann's problem
// min  f    :     f(x)= 9 - x(1) - x(2)
// subject to
// C1: (x(1)-3)^2 + (x(2)-2)^2 - 16 <= 0
// C2:  x(1)*x(2)-14 <= 0
// C3:  x >= 0


if ~ isdef('DiffEvol'), getf('DiffEvol.sci'), end

function f= Zi( x, data)
// data is not used here
  x1= x(1); x2= x(2);
  
  f= 9 - x1 - x2;

  // L1-penalty for constraint C1
  
  P1= max(0,(x1-3)^2 + (x2-2)^2 - 16);
  
  // L1-penalty for constraint C2
  
  P2= max(0,x1*x2-14);
  
  // L1-penalty for constraints C3
  
  P3= max(0,-x1) + max(0,-x2)
  
  // the factor nu (below) must be so small that
  // | nu * lambda_i | <= 1  where  lambda_i is the Lagrange
  // multiplier corresponding to the constraint C_i at the solution
  // Too small a nu slows down convergence.
  // see, e.g., Fletcher 'Practical Methods of Optimization'

  // To approximate the Lagrange multipliers, let  C=[C1;C2;C3;C4]
  // and  obtain C\star by deleting all rows of C if the corresponding
  // constraint is not active. Let grad C\star be the transposed Jacobian of
  // C\star (at an approximate solution), then
  // lambda= - pinv(C\star) * grad f  where
  // pinv denotes the pseudo inverse and grad f is evaluated at the
  // same approximate solution as C\star.
  
  // Here at  x=[7;2] ; grad f = [-1;-1]  and C\star = -[8,2;0,7]
  // which gives  lambda= [5/56;1/7], so nu < 7 should do

  nu= 6;
  f= nu*f + P1 + P2 + P3;
endfunction

Dim= 2;

// Here, we known that  x=[7;2] is a minimum with the
// the minimum value of 0 (a rare case), therefore
VTR= 0.005;  // value to reach  (i.e. stop if res <= VTR)

// from C1   |x1-3| <= 4    |x2-2| <= 4
Xlow = [-1;-2];
Xhigh= [7;6];

Npop = 10*Dim;
maxiter= Npop*Dim;
Crossover= 1;
Meth=2;
select Meth
  case 1 then strategy=1; stepsize= 0.8;
  case 2 then strategy=3; stepsize= [1,0.6];
end

refresh=Dim;

[x,res_opt,nfeval] = DiffEvol(Zi,VTR,Dim,Xlow,Xhigh,0,Npop,...
                                 maxiter,stepsize,Crossover,...
                                 strategy,refresh)


// The following can be used to 'restart' DiffEvol 'around'
//   the approximation solution just found
// Select 'delta' carefully.
// In this example (where we know the minimum value of the cost function)
//   DiffEvol is most likely terminated by the VTR test
// If that's not the case select a moderate value of 'maxiter'
//   and refine if necessary
// Perhaps it's better to switch to a fast local minimizer like 'optim'.
//   But it doesn't like non-differentiable penalty terms like L1-penalty terms
 
refine= %F;

if refine
  // restart around best x found so far
  disp('restart to refine the solution found so far')

  delta= 0.01;  //  assuming, the exact solution is within this distance
  Xlow= x-delta*ones(x);  Xhigh= x+delta*ones(x);

  [x,res_opt,nfeval] = DiffEvol(Zi,VTR,Dim,Xlow,Xhigh,0,Npop,...
                                   maxiter,stepsize,Crossover,...
                                   strategy,refresh)
end
