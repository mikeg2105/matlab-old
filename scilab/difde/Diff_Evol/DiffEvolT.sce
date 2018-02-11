// This is a pure constraint satisfaction problem
// This is a difficult problem

// Find the coefficients of the polynomial p(z) of degree 8
// which solves
//   p(z) should be in [-1,1]  forall z in [-1,1]
//   p(+/- 1.2) >=  T(1.2)  where T is the Chebyshev polynomial of degree 8
// The best p is identical to the Chebyshev polynomial

if ~ isdef('DiffEvol'), getf('DiffEvol.sci'), end

function T= Chebyshef(z,d)
    TP=ones(z); T=z;  // T0, T1
    for i=2:d
      TC= T;
      T= 2*z.*TC-TP;
      TP= TC;
    end
endfunction

function y= Horner(z,a)
  D= length(a);
  y= a(1);
  for i=2:Dim
    y= z.*y + a(i)
  end

endfunction

global ChP12  FctCount
ChP12= 0;  FctCount= 0;
winId= progressionbar('I am working hard');

function res=PolyFit(a,data)
// data is not used here

  global FctCount
  FctCount= FctCount+1;        // just to keep user awake
  if  modulo(FctCount,100) == 0,  progressionbar(winId); end

  k= 4  // polynomial of degree 2k
  Dim= k+k+1;  // dimension of a

// res is a penalty term
  res= 0
// compute Chebyshev polynomial at 1.2
  global  ChP12
  if ChP12 == 0,  ChP12= Chebyshef(1.2,k+k); end

// p(z) should be in [-1,1] for z in [-1,1]
// approximate this by the discrete requirement
// p(z_i) \in [-1,1]]  for  z_i=-1 * (i-1)*dx

  M= 61; // approximate a continuos constraint
  P= Horner(linspace(-1,1,M)',a)
  
  res= res + sum( (P > 1).*(P-1) ) + sum( (P < -1).*(-P-1) )

  Pm= Horner(-1.2,a);  Pp= Horner(1.2,a);  
  
  if  Pm < ChP12,  res= res +  ChP12-Pm; end
  if  Pp < ChP12,  res= res +  ChP12-Pp; end
endfunction

Dim= 9;
VTR= 0.005;  // value to reach  (i.e. stop if res <= VTR)
Xlow =-100*ones(Dim,1);
Xhigh= 100*ones(Dim,1);
Npop = 10*Dim;
maxiter= Npop*Dim;
Crossover= 1;
// for this problem strategies  1 3 6 8        succeed with 21000 fevals (approx)
//                  strategies  2 4 5 7 9 10   fail    with 72900 fevals

Meth=3
select Meth
  case 1 then strategy=1; stepsize= 0.9;
  case 2 then strategy=2; stepsize= 0.8;
  case 3 then strategy=3; stepsize= [0.6,0.5];
end

refresh=Dim;
// refresh= 0;



[coefs,res_opt,nfeval] = DiffEvol(PolyFit,VTR,Dim,Xlow,Xhigh,0,Npop,...
                                    maxiter,stepsize,Crossover,...
                                    strategy,refresh)
z=linspace(-1,1,121)';

Tz= Chebyshef(z,8);
Sz= Horner(z,coefs);

plot(z,Tz,z,Sz)
