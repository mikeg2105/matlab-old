function [u,A,B,C,D,F]=initialize_state_space40();

%Calculates the value of the matrix A,B,C,D,F and send them back for
%a 40,000 ft altitude level.

W = 636600;     %lb
g = 32.174;     %ft/seg^2
m = W/g;        %slug
Ix = 18.2e6;    %slug*ft^2
Iz =49.7e6;     %slug*ft^2
Iy =33.1e6;     %slug*ft^2
Izx = .97e6;    %slug*ft^2
h = 40000;      %ft
M = .9;         %Mach number
aa = 968.08;    %ft/s
u =M*aa;        %ft/s airplane velocity
S = 5500;       %ft^2  wing area
b= 195.68;      %ft wingspan
c_media= 27.31; %ft  wing mean aerodynamic chord
roo = 5.8727e-4;    %slug/ft^3
AR = b^2/S;     %aspect ratio of the wing
Q = .5*roo*u^2; %dynamic pressure
teta=0;


%Lateral stability coeficients
Cyb=-.85;
Cyp=0;
Cyr=0;
Clb=-.1;
Clp=-.3;
Clr=.2;
Cnb=.2;
Cnp=.2;
Cnr=-.325;
Cysa=0;
Cysr=.075;
Clsa=.014;
Clsr=.005;
Cnsa=.003;
Cnsr=-.09;


%Lateral directional derivatives
Yb = Q*S*Cyb/(m);           %ft/s^2
Yp = Q*S*b*Cyp/(2*m*u);     %ft/s
Yr = Q*S*b*Cyr/(2*m*u);     %ft/s
Nb = Q*S*b*Cnb/(Iz);        %1/s^2
Np = Q*S*b^2*Cnp/(2*Iz*u);  %1/s
Nr = Q*S*b^2*Cnr/(2*Iz*u);  %1/s
Lb = Q*S*b*Clb/(Ix);        %1/s^2
Lp = Q*S*b^2*Clp/(2*Ix*u);  %1/s
Lr = Q*S*b^2*Clr/(2*Ix*u);  %1/s
Ysa = Q*S*Cysa/m;           %ft/s^2
Ysr = Q*S*Cysr/m;           %ft/s^2
Nsa = Q*S*b*Cnsa/Iz;        %1/s^2
Nsr = Q*S*b*Cnsr/Iz;        %1/s^2
Lsa = Q*S*b*Clsa/Ix;        %1/s^2
Lsr = Q*S*b*Clsr/Ix;        %1/s^2


%Formacion de matrices
A = [Yb/u Yp/u -(u-Yr)/u g*cos(teta)/u; Lb Lp Lr 0; Nb Np Nr 0; 0 1 0 0]; 
B = [Ysa/u Ysr/u; Lsa Lsr; Nsa Nsr; 0 0];
C=[0 0 0 1;1 0 0 0];  %I change the order to the aileron control the roll angle and the rudder the sideslip angle
D=[0 0; 0 0];
F= [-Yb/u -Yp/u -Yr/u; -Lb -Lp -Lr; -Nb -Np -Nr; 0 0 0];