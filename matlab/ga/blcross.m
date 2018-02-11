function xoff=blcross(xpar)    % blend crossover
[np,n]=size(xpar);n=n-1;
xoff=xpar;
for i=1:n
   u=rand();
   xoff(1,:)=u*xpar(1,:)+(1-u)*xpar(2,:);
   xoff(2,:)=u*xpar(2,:)+(1-u)*xpar(1,:);
end
%endfunction
%









