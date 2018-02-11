% mgls.m
% Calls the Objective Function

function objective = objfun(x)

Wb1=real(x(1)) ;
Wb2=real(x(2)) ;
const1 =real(x(3)) ;
const2= real(x(4));

s=tf('s');
W111=(s+Wb1)/(s);
W122=(s+Wb2)/(s);

W1=[W111 0;0 W122 ];
W2=tf([const1 0;0 const2]);

[GAM, overshoot, max_aileron, max_rudder, muncertainty, omega, polo, Tr, Ts] = ...
    moga_MGLS_alex(W1,W2);

objective = Inf * ones(1,9);

objective(1) = GAM;
objective(2) = overshoot;
objective(3) = max_aileron;
objective(4) = max_rudder;
objective(5) = -muncertainty;
objective(6) = -omega;
objective(7) = -polo;
objective(8) = Tr;
objective(9) = Ts;