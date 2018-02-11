tic
xv=-1:0.1:1;
[XX,YY]=meshgrid(xv,xv);
[siz1,siz2]=size(XX);
res=reshape(arrayfun(@mynewfun1,reshape(XX,siz1*siz2,1),reshape(XX,siz1*siz2,1)),siz1,siz2);
toc
t=toc
surf(res);

