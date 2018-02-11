%parfortest
%monte carlo pi approximation

m=100;
parfor p =1:numlabs
    z= rand(m,1)+i*rand(m,1);
    c = sum(abs(z)<1)
end

k = gplus(c)
p = 4*k/(m*numlabs);

