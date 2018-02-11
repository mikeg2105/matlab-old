
// Display mode
mode(0);

// Display warning for floating point exception
ieee(1);

// here is an example use of the while statement
// which is used for finding the root of a polynomial 
// which is known to lie within a certain interval.
// a is the lower value of the range
// b is the upper value of the range

a = 0;fa = -%inf;
b = 3;fb = %inf;

while abs(b-a)>(%eps*b)

  x = (a+b)/2;
  fx = x^3-2*x-5;
  if sign(fx)==sign(fa) then
    a = x;
    fa = fx;
  else
    b = x;
    fb = fx;
  end;

end;

disp(" The root is :");
disp(x);
