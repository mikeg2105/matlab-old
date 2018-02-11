function evalpop=evaluation(X);  % evaluation of the whole population
[Npop,n]=size(X);n=n-1;
evalpop=zeros(Npop,1);
for i=1:Npop;
  evalpop(i)=rastrigin(X(i,1:n),n);
end
%endfunction
%