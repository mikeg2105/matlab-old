
nseeds=5;
probfil=0.5;
dprobfil=0.245;
wx=0.5;
m = 102;




nosteps=10;
nsteps=200;
step=0;
ostep=0;
length=int16(m/8);
nwalls=50;

dprobfilx=dprobfil*wx;
dprobfily=dprobfil*(1-wx);



while ostep<nosteps
        X = zeros(m,m);
     xs=1+int16(m*rand(nseeds));
    ys=1+int16(m*rand(nseeds));

     xw=1+int16(m*rand(nwalls));
    yw=1+int16(m*rand(nwalls));
    for ic=1:nwalls    
     X(xw(ic),yw(ic))=2;
     for jc=1:length
        if (xw(ic)+jc)<m
           X(xw(ic)+jc,yw(ic))=2; 
        end
     end
    end
 for ic=1:nwalls    
     X(xw(ic),yw(ic))=2;
     for jc=1:length
        if (yw(ic)+jc)<m
           X(xw(ic),yw(ic)+jc)=2; 
        end
     end
 end 

    
    

    for ic=1:nseeds    
     X(xs(ic),ys(ic))=1;   
    end
    
    [i,j] = find((X>0) .* (X<2));
       figure(gcf);
      plothandle = plot(i,j,'.', ...
      'Color','blue', ...
      'MarkerSize',12);
   axis([0 m+1 0 m+1]);
  
   
while step<nsteps
    
      %update role
      num=size(i);
      for is=1:num
         
         sx=i(is);
         sy=j(is);
         
         
         
         %neighbours in x direction
         nnx=0;
         if (((sx+1)<=m) && (X(sx+1,sy)==1))
                      nnx=nnx+1; 
         end;
         if (((sx-1)>0)   && (X(sx-1,sy)==1))
                      nnx=nnx+1; 
         end;

         %neighbours in y direction
         nny=0;
         if (((sy+1)<=m) && (X(sx,sy+1)==1))
                      nny=nny+1; 
         end;
         if (((sy-1)>0)   && (X(sx,sy-1)==1))
                      nny=nny+1; 
         end;
         probx=probfil-dprobfilx*nny;
         proby=probfil-dprobfily*nnx;
         
         if rand(1)<probx
            %fill x direction
            if rand(1)>0.5
            %fill +x direction
              if ((sx+1)<=m && X(sx+1,sy)~=2)
                  X(sx+1,sy)=1;
              end;
            else
            %fill -x direction
               if(sx-1)>0 && X(sx-1,sy)~=2
                  X(sx-1,sy)=1;
               end;
            end;
         elseif rand(1)<proby
            %fill y direction
            if rand(1)>0.5
            %fill +y direction
                if (sy+1)<=m && X(sx,sy+1)~=2
                  X(sx,sy+1)=1;
                end;
            else
            %fill -y direction
                if(sy-1)>0 && X(sx,sy-1)~=2
                  X(sx,sy-1)=1;
                end;
            end;            
         end
         

         
      end
      
      
% Update plot.

      [i,j] = find((X>0) .* (X<2));
      set(plothandle,'xdata',i,'ydata',j)
      drawnow
      
      step=step+1;
      
      
end
     pause(1.);
     %reset(plothandle);
     %cla;
     step=0;
     
    ostep=ostep+1;
end