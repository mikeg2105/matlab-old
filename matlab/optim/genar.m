tic
xv=-1:0.1:1;
for i=1:21
    for j=1:21
    x(1)=xv(i);
    x(2)=xv(j);
    res(i,j)=mynewfun(x);
    end
end
toc
t=toc
surf(res);