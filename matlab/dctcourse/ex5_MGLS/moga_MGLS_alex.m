% function [GAM, overshoot, max_aileron, max_rudder,...
%     muncertainty, omega, polo] = moga_MGLS(W1, W2)

function [GAM, overshoot, max_aileron, max_rudder, muncertainty, omega, polo, Tr, Ts] = ...
    moga_MGLS_alex(W1, W2);

%This program is used to run moga and test the best value for W1 and W2
%tic
%Load the initial values of the state space
[u,A,B,C,D,F]=initialize_state_space40();

%also the transfer function is scaled
s=tf('s');
G=ss(A,B,C,D);
dy=[.04 0 ;0 .018];
du=[.0349 0;0 .052];
G_scale=inv(dy)*G*du;

%--------------------------------------------------------------------------
%W1=[tf((s+4)/s) 0; 0 tf((s+3)/s)]*[1 0;0 1];
%W2=tf([5 0;0 90]);
%[W1,W2]=forming_weighting_functions()
%--------------------------------------------------------------------------

%Obtain the controller
gamrel=.1;
[S,T,Ks,K,gammin]=usemgls(G_scale,W1,W2,gamrel);
GAM=(1+gamrel)*gammin;

if (GAM<10 & GAM>.2)

    %Closed loop relation
    K=W1*Ks*W2;
    L=G*K;
    I=eye(size(L));
    S=(I+L)\I;
    T=eye(size(S))-S;
    Tr=S*G*W1*real(evalfr(Ks*W2,0)); %y/r
    Tu=feedback(eye(size(W1*Ks*W2*G)),W1*Ks*W2*G)*  W1*real(evalfr(Ks*W2,0)); %u/r

    %--------------------------------------------------------------------------
    %--------------------------------------------------------------------------
    %toc
    %tic
    %Simulate the response to a step change
    time=0:.0001:20;      %row vector
    [row,column]=size(time);
    input(1,(1:column))=0.1;
    input(2,(1:column))=0;
    [resp_y,time_y]=lsim(Tr,input,time); %the outputs are column vectors
    [resp_u,time_u]=lsim(Tu,input,time); 
    %toc
    %tic
    %--------------------------------------------------------------------------
    %--------------------------------------------------------------------------

    %Compute the overshoot of the roll angle response.
%     max_value=max(resp_y(:,1));
%     if max_value > 0.1
%         overshoot=(max_value-0.1)/.1*100;
%     else
%         overshoot=0;
%     end

    %Calculate the maximum magnitude of the control signals. This magnitude
    %should be greather than 0.3491 for the aileron and 0.5236 for the rudder
    max_aileron=max(resp_u(:,1));
    max_rudder=max(resp_u(:,2));

    %Calculates the multiplicative uncertainty
    ww=logspace(-1,1.5,500);
    [singval,frec]=sigma(T,ww);  %singval is a row vector and frec a column vector
    muncertainty=100/max( max(singval(1,:)),max(singval(2,:)));

    %Calculates the frequency crossover of the lowest singular value
    ww=logspace(-1,1.5,500);
    [singval,frec]=sigma(W2*G*W1*Ks,ww);  %singval is a row vector and frec a column vector
    [roww,col]=find(singval(2,:)<1,1,'first');
    omega=frec(col);

    %obtain the poles of the system
    polos=pole(minreal(T));
    polo=min(abs(real(polos)));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ALEX'S OBJECTIVES
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % set the parameters for getting the objectives
    final_value = 0.1;              % because this is a step input
    rise_time_limits = [0.1 0.9];   % because we are calculating the rise time
                                    % between 10% and 90%
    acc = 0.02;                     % the system is settled when it is within
                                    % 2% of the final value
                                    
    overshoot = getOvershoot(resp_y(:,1), time, final_value) * 100;
    Tr = getRiseTime(resp_y(:,1), time, final_value, rise_time_limits);
    Ts = getSettlingTime(resp_y(:,1), time, final_value, acc);
    

else
    max_aileron=10;
    max_rudder=10;
    overshoot=30;
    GAM=20;
    muncertainty=0;
    omega=.5;
    polo=0;
    Tr = Inf;
    Ts = Inf;
end
%toc