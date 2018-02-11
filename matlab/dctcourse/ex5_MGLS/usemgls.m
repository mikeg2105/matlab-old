function [S,T,Ks,K,gammin]=usemgls(G,W1,W2,gamrel)
% Computes CLTFs for SDOF McFarlane-Glover Loop shaping procedure
% [S,T,KS,K,TR]=usemgls(G,W1,W2,gamrel) returns the
% sensitivity function, S,
% complementary sesitivity function, T,
% the compensator, Ks,
% the (de-weighted) compensator, K = W1KW2,
% the closed-loop transfer function, TR=SGW1(s).KW2(0)
% the minimum value of gamma, gammin, achieved in the design
% for a MGLS design with
% plant, G,
% input weighting, W1,
% output weighting, W2,
% and suboptimality parameter, gamrel.
% [S,T,KS,K,TR]=usemgls(G,W1,W2) uses default gamrel of 0.1.
% [S,T,KS,K,TR]=usemgls(G,W1) uses default gamrel of 0.1 and W2=I.
% [S,T,KS,K,TR]=usemgls(G) uses default gamrel of 0.1 and W1=W2=I. This raises a query with the user.
% S,T,KS,K,TR,G,W1,W2 are square LTI objects of compatible dimension.
% gamrel is a real number 0<gamrel<1.0 (default, gamrel=0.1, e.g. 10% suboptimal)
%
% (c) 2000, The University of Sheffield.
% Robert F Harrison
%
if nargin==4
   if gamrel<=0 | gamrel>=1.0;
      error('gamrel must satisfy 0<gamrel<1')
   end
elseif nargin ==3
   gamrel=0.1;
elseif nargin ==2
   gamrel=0.1;
   W2=tf(eye(size(G)));
elseif nargin ==1
   gamrel=0.1;
   W2=tf(eye(size(G)));
   W1=tf(eye(size(G)));
   rep=input('Are you sure you do not wish to use any weighting? (y/n) ','s');
   if lower(rep)~='y';
      return;
   end
else
   error('Not enough input arguments!');
end

[Ks,gammin]=mgls(W2*G*W1,1+gamrel);
disp(['Maximum epsilon = ' num2str(1/gammin) '   Achieved epsilon = ' num2str(1/(1+gamrel)/gammin)]);
if gammin>4;disp(['Warning: Possibly Incompatible Loop-Shape Requested (epsilon < 0.25: Check achieved loop-shape)']);end 
K=W1*Ks*W2;L=G*K;
I=eye(size(L));
S=(I+L)\I;T=S*L;KS=K*S;
%TR=S*G*W1*evalfr(Ks*W2,0);