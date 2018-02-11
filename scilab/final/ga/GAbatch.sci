//
//------------------------------------------------------
// real valued genetic algorithm 
// for the minimization of the rastrigin function 
// (with dynamic display for the case of 2 parameters)
//
//-----------------------------------------------------
// selection: proportionate with ranking method 
// crossover: blend 
// mutation: non uniform
// 1-elitism
//
function y=rastrigin(x,n)  // the function to optimize
y=n+sum(x.^2-cos(2*%pi*x));
endfunction
// 
function evalpop=evaluation(X);  // evaluation of the whole population
[Npop,n]=size(X);n=n-1;
evalpop=zeros(Npop,1);
for i=1:Npop;
  evalpop(i)=rastrigin(X(i,1:n),n);
end
endfunction
//
function [Xpar,bestpar]=evalplus1elitism(Xpar,Xoldpar,Npop,gen) // evaluation plus 1-elitism
val=evaluation(Xpar);    
Xpar(:,n+1)=val;
[minval,index]=min(Xoldpar(:,n+1));  
bestpar=Xoldpar(index(1),:);
[minval,index]=min(val);
bestnewpop=Xpar(index(1),:);
if (bestnewpop($)>bestpar($))&(gen>1) then
    nrand=int(Npop*rand())+1;
    Xpar(nrand,:)=bestpar;
else 
    bestpar=bestnewpop;
end
endfunction
//
function Xsel=rankselect(X)    // ranking selection
Xsel=X;
[Npop,n]=size(X);n=n-1;
[Fsort,ind]=sort(X(:,n+1));
X=X(ind,:);
p=1:Npop;roulette=cumsum(p)/sum(p);
for i=1:Npop;
  u=rand();
  index=find(roulette<u);Nselect=max(index)+1;
  Xsel(i,:)=X(Nselect,:);
end
endfunction
//
function xoff=blcross(xpar)    // blend crossover
[np,n]=size(xpar);n=n-1;
xoff=xpar;
for i=1:n
   u=rand();
   xoff(1,:)=u*xpar(1,:)+(1-u)*xpar(2,:);
   xoff(2,:)=u*xpar(2,:)+(1-u)*xpar(1,:);
end
endfunction
//
function xoff=mutate(xpar,ngen,Ngen,xmin,xmax) // non uniform mutation
[np,n]=size(xpar);n=n-1;
b=5;
xoff=xpar;
for i=1:n
  u1=rand();u2=rand();
  if (u1<1/2) then
    xoff(1,i)=xpar(1,i)+(xmax(i)-xpar(i))*u2*(1-(ngen-1)/Ngen)^b;
   else
    xoff(1,i)=xpar(1,i)-(xpar(i)-xmin(i))*u2*(1-(ngen-1)/Ngen)^b;
   end;
end;
endfunction
//
//---------main program ---------------------
//
disp('real valued GA for minimizing the rastrigin function');
disp('(with dynamic display for 2 parameters)');
//
xmin=-5.12;xmax=5.12;N=300;
x=xmin:((xmax-xmin)/(N-1)):xmax;
y=x;
z=zeros(N,N);
for i=1:N
for j=1:N
z(i,j)=rastrigin([x(i),y(j)],2);
end
end
//
n=2;//evstr(x_dialog('parameter number of the rastrigin function','2')); 
Npop=30;//evstr(x_dialog('population number','30'));     
Ngen=50;//evstr(x_dialog('generation number','50')); 
pc=0.9;//evstr(x_dialog('crossover probability','0.9')); 
pm=0.6;//evstr(x_dialog('mutation probability','0.6')); 
//
xmin=-5.12*ones(1,n);
xmax=5.12*ones(1,n);
Xmin=ones(Npop,1)*xmin;
Xmax=ones(Npop,1)*xmax;
u=rand(Npop,n);
pop=Xmin+(Xmax-Xmin).*u;  // random initialisation of the population
Xpar=[pop,zeros(Npop,1)];  
Xoff=Xpar;Xoldpar=Xpar;fmin=[];mineval=0;newval=zeros(Npop,1);Traj=[];
//
 //
for gen=1:Ngen;
  Xpar=Xoff;
  [Xpar,bestpar]=evalplus1elitism(Xpar,Xoldpar,Npop,gen);  // evaluation plus 1-elitism
  Xoldpar=Xpar;
  fmin=[fmin,bestpar($)];
  //
  Xpar=rankselect(Xpar); // rank selection
  for i=1:2:(Npop-1)
    u1=int(Npop*rand())+1;u2=int(Npop*rand())+1;u3=rand();
    xpar=[Xpar(u1,:);Xpar(u2,:)];Xoff(i:(i+1),:)=xpar;
    if (u3<pc) then
     xoff=blcross(xpar);   //crossover
     Xoff(i:(i+1),:)=xoff;
    end
    for j=1:2
       u4=rand();
        if (u4<pm) then
          xoffl=mutate(xoff(j,:),gen,Ngen,xmin,xmax);  // mutation
          Xoff(i+j-1,:)=xoffl;
        end
    end
   end

//
end

driver('Pos');
//xtape('on');
f=xinit('trajectory.ps');
f.visible='off';
//xset('pixmap',1);
xbasc()
contour2d(x,y,z,[0:0.01:0.1,0.2:1,1:10],rect=[-5.12,-5.12,5.12,5.12]);
Traj=[Traj;bestpar(1),bestpar(2)];
plot2d(Xpar(:,1),Xpar(:,2),-1,rect=[-5.12,-5.12,5.12,5.12]);
plot2d(Traj(:,1),Traj(:,2),5,rect=[-5.12,-5.12,5.12,5.12]);
xtitle('trajectory display');
xend();
unix_g('convert trajectory.ps trajectory.jpg');

[Xpar,bestpar]=evalplus1elitism(Xoff,Xoldpar,Npop,gen);  // evaluation plus 1-elitism
fmin=[fmin,bestpar($)];
//
//----------- results displays --------------
//
//driver('Pos');
//xset('pixmap',1);
f=xinit('convergence.ps');

//xset('window',0);
xbasc();
plot2d(0:Npop:(Npop*Ngen),fmin);
xtitle('convergence history','Neval','fmin');
xend();
unix_g('convert trajectory.ps trajectory.jpg');
disp('minimum obtained:');disp(bestpar(1:n));
disp('corresponding value by f:');disp(bestpar($));
disp('evaluation number:');disp(Npop*Ngen);


















 
     

