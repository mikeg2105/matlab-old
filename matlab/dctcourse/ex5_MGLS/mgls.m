function [k,gammin]=mgls(g,gamrel)
% Compute McFarlane-Glover weighted controller
% MGLS(G,GAMREL)
% Computes the McFarlane-Glover H-infinity 
% controller for the weighted LTI object G
% The controller is sub-optimal and approaches the minimal cost (GAMMIN)
% to within (1+GAMREL)*GAMMIN (0<GAMREL<1, usually set to 0.1, the default)
% The weighted controller is output as a state-space LTI object,
% along with the minimal value of gamma (GAMMIN).
% The implementable compensator must be de-weighted.
% NB the controller is determined for a NEGATIVE feedback
% configuration, contrary to the original derivation.
%
% (c) 2000, R.F. Harrison, The University of Sheffield.

if nargin<2;gamrel=0.1;end
gamrel=1+gamrel;
[a,b,c,d]=ssdata(g);

R=eye(size(d*d'))+d*d';
S=eye(size(d'*d))+d'*d;

A=a-b*inv(S)*d'*c;
Z=areare(A',c'*inv(R)*c,b*inv(S)*b');

X=areare(A,b*inv(S)*b',c'*inv(R)*c);
gammin=sqrt(1+max(eig(X*Z)));
gamma=gamrel*gammin;
gamma2=gamma^2;


F=-inv(S)*(d'*c+b'*X);
L=X*Z;L=(1-gamma2)*eye(size(L))+L;

Ac=a+b*F+gamma2*inv(L')*Z*c'*(c+d*F);
Bc=gamma2*inv(L')*Z*c';
% NB negative feedback configuration, unlike McF/G
Cc=-b'*X;
Dc=d';
k=ss(Ac,Bc,Cc,Dc);