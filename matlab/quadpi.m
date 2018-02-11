function piApprox = quadpi
% QUADPI   Approximate pi via parallel numerical quadrature.

%   Copyright 2005 The MathWorks, Inc.

% Approximate pi by the numerical integral 
% of F = 4/(1 + x^2) from 0 to 1.
F = @(x)4./(1 + x.^2);
% Each lab calculates the integral of F over a 
% subinterval [a, b] of [0, 1].
a = (labindex - 1)/numlabs;
b = labindex/numlabs;
% Use a built-in MATLAB quadrature method to approximate 
% the integral.
myIntegral = quadl(F,a,b);

% The labs have now all calculated their portions of the 
% integral of F, and will all send their results to lab 1, which
% will add them together to form the entire integral over [0, 1].
if (labindex == 1)
    % Receive the integral contribution from all the other labs.
    piApprox = myIntegral;
    for otherLab = 2:numlabs
        piApprox = piApprox + labReceive(otherLab);
    end
else
    % Send the integral contribution to lab 1.
    piApprox = [];
    labSend(myIntegral, 1);
end
