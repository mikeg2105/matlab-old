%parfortest
%monte carlo pi approximation
tic
m=25000000;
parfor p =1:numlabs
    z= rand(m,1)+i*rand(m,1);
    c = sum(abs(z)<1)
end

%k = gplus(c)
%p = 4*k/(m*numlabs);
toc
