%total cross section
function [sigma]=sigma(k,e)
  lupper=10;
  sumdelta=0;
  delta=0.1*(10^(-10));
  sumouter=0;
  totsum=0;
  sigma=0;
  nr=50;
  u1=zeros(nr,lupper+1);
  u2=zeros(nr,lupper+1);
  u3=zeros(nr,lupper+1);
  %outer loop integration over r
  for j=1:nr,
    
    u1=0;
    %inner loop summation over l
    sumdelta=0;
    for i=0:lupper,   
      if j == 1 then
        u1(j,i+1)=0.1;
        u2(j,i+1)=delta^(i+1);
      else
        u2(j,i+1)=u3(j-1,i+1);
        u1(j,i+1)=u2(j-1,i+1);
      end;
      
      u3(j,i+1)=numerov(u1(j,i+1),u2(j,i+1),i,j*delta,delta,e);
     end
   end
 
    
    u1=0;
    %inner loop summation over l
    sumdelta=0;
    for i=0:lupper,   
       
       res=tdl(u1(nr-1,i+1),u2(nr-1,i+1),(nr-1)*delta,(nr)*delta,i,k);
      cosecdelta2=((1/(res^2))+1);
      sumdelta=sumdelta+(2*i+1)*(1/cosecdelta2); 
    end
    sumouter=((4*%pi)/(k^2))*sumdelta;
    totsum=totsum+sumouter;
  
  
  %outer loop
  sigma=totsum;
%endfunction

