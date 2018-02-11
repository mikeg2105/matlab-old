function c = gcd2(a, b)
% Greatest common divisor  by a recursive algorithm
% This function is used for the Matlab benchmark
% Use gcd(a, b) instead for other uses
%
% by Ph. Grosjean, 2001 (phgrosjean@sciviews.org)

if b <= 1.0E-4
  c = a;
else
  b(b == 0) = a(b == 0);
  c = gcd2(b, rem(a, b));
end

