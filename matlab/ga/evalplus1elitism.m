function [Xpar,bestpar,bestnewpop]=evalplus1elitism(Xpar,Xoldpar,Npop,gen,n) % evaluation plus 1-elitism
val=evaluation(Xpar);    
Xpar(:,n+1)=val;
[minval,index]=min(Xoldpar(:,n+1));  
bestpar=Xoldpar(index(1),:);
[minval,index]=min(val);
bestnewpop=Xpar(index(1),:);
if (bestnewpop(numel(bestnewpop))>bestpar(numel(bestnewpop)))&(gen>1)
    nrand=int32(Npop*rand())+1;
    Xpar(nrand,:)=bestpar;
else 
    bestpar=bestnewpop;
end
%endfunction
%
