

          for i=1:n-1
              aomsz(i)=omsz(params,rval(i),params.m,params.k,params.om,params.p);
              aomfz(i)=omfz(params,rval(i),params.m,params.k,params.om,params.p);
              aomalf(i)=F(params,rval(i),params.m,params.k)^2/rho(params,rval(i));
              aomslow(i)=((params.gamma*params.p)/((params.b)^2+(params.gamma*params.p)))*F(params,rval(i),params.m,params.k)^2/rho(params,rval(i));
          end