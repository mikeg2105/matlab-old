function [res,data]=myrandpar(msize)
%myrandpar test parallel
    res=rand(msize);
    data=zeros(msize);
    if labindex==1
        labSend(res,2);
    elseif labindex==2
        data=labReceive(1);
    end
   % res=zeros(msize,5);
    %data=zeros(msize,1)
    %mymat=rand(msize,5);
  %  res = zeros(1, msize, distributor());
   % data = zeros(2, msize, distributor());
  %  parfor n = 1:msize
    %   res(n) = rank(magic(n));
   %    %res(n,:) = zdt1(mymat(n,:));
     %  data(1,n)=labindex;
     %  data(2,n)=n;
  %  end
 %   res = gather();
  %  data = gather();
