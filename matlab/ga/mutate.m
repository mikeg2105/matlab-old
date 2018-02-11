function xoff=mutate(xpar,ngen,Ngen,xmin,xmax) % non uniform mutation
[np,n]=size(xpar);n=n-1;
b=5;
xoff=xpar;
for i=1:n
  u1=rand();u2=rand();
  if (u1<1/2) 
    xoff(1,i)=xpar(1,i)+(xmax(i)-xpar(i))*u2*(1-(ngen-1)/Ngen)^b;
   else
    xoff(1,i)=xpar(1,i)-(xpar(i)-xmin(i))*u2*(1-(ngen-1)/Ngen)^b;
   end;
end;
%endfunction