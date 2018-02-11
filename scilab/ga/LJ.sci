clear
//
//   RESOLUTION OF THE LJn PROBLEM BY SIMULATED ANNEALING AND STEEPEST DESCENT
//
//--------------------LJ functions (lj and ljgrad computation)-----------------------------------------
//
function f = lj(x)                         // lj function
n = max (size (x))/ 3;
f = 0;
for i = 1 : n
   for j = i+1 : n
      i1 = 3*(i-1) + 1; i2 = i1 + 1; i3 = i2 + 1;
      j1 = 3*(j-1) + 1; j2 = j1 + 1; j3 = j2 + 1;
      r1 = x(i1)-x(j1); r2 = x(i2)-x(j2); r3 = x(i3)-x(j3);
      rr = r1 * r1 + r2 * r2 + r3 * r3;
      r6 = 1 / rr / rr / rr;
      f = f + (r6 - 2) * r6;
   end
end
endfunction
//
function g = ljgrad(x)                     // gradient of lj function
n = max (size (x)) / 3;
g = zeros(1,3*n);
for i = 1 : n
   for j = i+1 : n
      i1 = 3*(i-1) + 1; i2 = i1 + 1; i3 = i2 + 1;
      j1 = 3*(j-1) + 1; j2 = j1 + 1; j3 = j2 + 1;
      r1 = x(i1)-x(j1); r2 = x(i2)-x(j2); r3 = x(i3)-x(j3);
      rr = r1 * r1 + r2 * r2 + r3 * r3;
      r = sqrt (rr);
      r6 = 1 / rr / rr / rr;
      dr = - 12 * (r6 - 1) * r6 / r;
      g(i1) = g(i1) + dr * r1 / r;
      g(i2) = g(i2) + dr * r2 / r;
      g(i3) = g(i3) + dr * r3 / r;
      g(j1) = g(j1) - dr * r1 / r;
      g(j2) = g(j2) - dr * r2 / r;
      g(j3) = g(j3) - dr * r3 / r;
   end
end
endfunction
///
//--------------------simulated annealing function  ----------------------------------------
///
function [x, y,Neval,Fbest] = annealing (f, x0)
//
y0 = f(x0);
x = x0; y = y0; alpha = 0.9; T = 1; s = 0.2;icount=1;
disp('gevaluation number and current best value, SA:');
disp([icount,y]);
Neval=[];
Fbest=[];
for k = 1 : 20
   T = alpha * T; 
   for j = 1 : 10
   accept = 0;
   for l = 1 : 100
      x1 = x0 + s*(0.5*ones(x0) - rand (x0));
      y1 = f(x1);
      icount=icount+1;
      dy = y1 - y0;
      if rand() < exp (- dy / T) then
         x0 = x1; y0 = y1; accept = accept + 1;
         if y0 < y then x = x0; y = y0; end
      end
   end
   if accept < 25 then s = s / 2; end
   if accept > 75 then s = 2 * s; end
   x0 = x; y0 = y;
   end
   disp([icount,y]);
   Neval=[Neval;icount];
   Fbest=[Fbest;y];
end
endfunction
//
//--------------------steepest descent functions  ----------------------------------------
//
function [xnew,fnew,itback]=backtracking(f,x,fx,gx,d,alphainit);// line search by backtracking until Armijo condition
tau=0.3
bet=0.0001;
d=-gx;
alpha=alphainit;xnew=x+alpha*d
fnew=f(xnew)
itback=1;
while(fnew>fx+bet*alpha*sum(gx.*d))
  alpha=tau*alpha;
  xnew=x+alpha*d;
  fnew=f(xnew);
  itback=itback+1;
end
endfunction
//
//---------------------------------------------------------------------------------
//---------main program ------------------------------------------------------------
//
maxit=evstr(x_dialog('maximum number of iterations of steepest descent','150')); 
N=evstr(x_dialog('number of atoms','13')); 
n=3*N;
//
//  search domain
//
xmax=ones(1,n);
xmin=zeros(1,n);
//
timer(); 
u=rand(1,n);
x0=xmin+(xmax-xmin).*u;              // random initialisation 
Neval=[];Fbest=[];
[x,fx,Neval,Fbest]=annealing(lj,x0); // annealing part

//
gx=ljgrad(x);
disp('minimum obtained after SA:');disp(x);
disp('corresponding value by f:');disp(fx);
disp('norm of the gradient');disp(norm(gx));
disp('function evaluation number by SA:');disp(Neval($));
//
//
itgrad=1;                             //steepest descent part
itfct=1;
alphainit=10/norm(gx);
epsilon=1E-6;
//
disp('generation number and current best value, steepest descent:');
disp([itgrad,fx]);
//
while (norm(gx)>epsilon)&(itgrad<maxit)
  alphainit=1/norm(gx);
  [x,fx,itback]=backtracking(lj,x,fx,gx,alphainit);
  Fbest=[Fbest;fx];
  gx=ljgrad(x);
  itgrad=itgrad+1;
  itfct=itfct+itback;
  Neval=[Neval;Neval($)+n+itback];
//  disp([itgrad,fx]);
end
//
//----------- results displays --------------
//
//
disp('function evaluation number by steepest descent:');disp(itfct);
disp('gradient evaluation number by steepest descent:');disp(itgrad);
//
//disp('final minimum obtained:');disp(x);
disp('final corresponding value by f:');disp(fx);
//disp('final norm of the gradient:');disp(norm(gx));
disp('computational time:');disp(timer());
//
xset('window',1);
xbasc();
plot2d(Neval,Fbest);
xtitle('convergence history','Neval','fmin');
//
xset('window',2);
xbasc();
for j=1:(N-1)
    for k=j+1:N
plot3d([x(3*j-2);x(3*k-2)],[x(3*j-1);x(3*k-1)],[x(3*j);x(3*k)])
plot3d([x(3*j-2);x(3*k-2)],[x(3*j-1);x(3*k-1)],[x(3*j);x(3*k)],-1)
    end
end


























 
     

