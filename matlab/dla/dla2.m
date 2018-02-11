
nseeds=80;
probfil=0.5;
dprobfil=0.245;
wx=0.999;
m = 102;




nosteps=1;
nsteps=200;
step=0;
ostep=0;
length=int16(m/8);
nwalls=50;

dprobfilx=dprobfil*wx;
dprobfily=dprobfil*(1-wx);



while ostep<nosteps
        X = zeros(m,m);
     xs=1+int16((m/4)+(m/4)*rand(nseeds));
    ys=1+int16((m/4)+(m/4)*rand(nseeds));

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
    
      notocuppied=0;
      
      pm=rand(1);
      if(pm<0.25)
            cx=int16(1);
            cy=int16(1+rand(1)*(m));
            vx=1;
            vy=0;
 
      elseif(pm>=0.25 && pm <0.5)
             cy=int16(1);
            cx=int16(1+rand(1)*(m));
            vy=1;
            vx=0;
       elseif(pm>=0.5 && pm <0.75)
             cy=int16(m);
            cx=int16(1+rand(1)*(m));
            vx=0;
            vy=1;
      elseif(pm>=0.75 && pm <=1.0)
             cy=int16(m);
            cx=int16(1+rand(1)*(m));
            vx=0;
            vy=1;
      end
      
      vx=(m/2-cx);
      vy=(m/2-cy);
      vx=1;
      vy=1;
      
      
      newcx=cx;
      newcy=cy;
     while notocuppied==0
           
         if (((cx+1)<=m) && (X(cx+1,cy)==1))
                      notocuppied=1;
                      X(cx,cy)=1;
         end;
         if (((cx-1)>0)   && (X(cx-1,cy)==1))
                      notocuppied=1; 
                      X(cx,cy)=1;
         end;

         %neighbours in y direction
         
         if (((cy+1)<=m) && (X(cx,cy+1)==1))
                      notocuppied=1; 
                      X(cx,cy)=1;
         end;
         if (((cy-1)>0)   && (X(cx,cy-1)==1))
                      notocuppied=1; 
                      X(cx,cy)=1;
         end;
 
         
         if(notocuppied==0)
            %fill y direction
            if rand(1)>0.5
            %fill +y direction
                if (cy+1)<=m 
                    newcx=cx+vx;
                    newcy=cy+vy;
                end;
            else
            %fill -y direction
                if(cy-1)>0
                  newcy=cy-vy;
                  newcx=cx+vx;
                end;
            end; 
            
            if(newcx>m)
                newcx=1;
            end
         
 
        
             X(cx,cy)=0;
             X(newcx,newcy)=1;
             cx=newcx;
             cy=newcy;
         end
         
         
         % Update plot.

           [i,j] = find((X>0) .* (X<2));

      set(plothandle,'xdata',i,'ydata',j)
      drawnow
         
         

         
      end%end of while not occuopied loop
      
      

  
      
      
      
      
     step=step+1;
end  %end of main steps loop
     pause(1.);
     %reset(plothandle);
     %cla;
     step=0;
     
    ostep=ostep+1;
end