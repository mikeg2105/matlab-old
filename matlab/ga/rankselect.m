function Xsel=rankselect(X)    % ranking selection
Xsel=X;
[Npop,n]=size(X);n=n-1;
[Fsort,ind]=sort(X(:,n+1));
X=X(ind,:);
p=1:Npop;roulette=cumsum(p)/sum(p);
for i=1:Npop;
  
    u=rand();
  while ((roulette<u)==0) 
   u=rand();
  end
  index=find(roulette<u);Nselect=max(index);
  Xsel(i,:)=X(Nselect,:);
end
%endfunction
%










 
     


