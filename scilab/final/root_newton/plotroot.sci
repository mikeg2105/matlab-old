
// Display mode
mode(0);

// Display warning for floating point exception
ieee(1);

// This is an example use of the plot function 
// used in association with the finding of a root
// problem solved earlier.
// % a is the lower value of the range
// b is the upper value of the range

a = 0;fa = -%inf;
x = 3;fb = %inf;
delta = (b-a)/100;
xx = a:delta:b;
plot(xx,xx .^3-2*xx-5);
set(gca(),"auto_clear","off");
// !! L.13: Matlab function line not yet converted, original calling sequence used.
//hax = line([a,b],[0,0]);
// !! L.14: Matlab function set not yet converted, original calling sequence used.
// L.14: (Warning name conflict: function name changed from set to %set).
//%set(hax,"Color","red");
while (sqrt((x-a)^2))>0.0001

  a=x;
  //fx = x^3-2*x-5;
  //dfx= 3*x^2-2;
  
  fx = 0.5*sin(2*(x-(%pi/4)))+0.5*sin(x);
  dfx= cos(2*(x-(%pi/4)))+0.5*cos(x);
  x=a-(fx/dfx);
  halt;
   
  plot(x,fx,"o")
  
  disp(x-a);
end;

disp(" The root is :");
disp(x);
set(gca(),"auto_clear","on");
