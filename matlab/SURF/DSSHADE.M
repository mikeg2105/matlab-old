% colour map  control for interactive surface plotting.

 dstmp = get(dsh5,'value');
 figure(h0);
 if dstmp == 1
     shading interp 
 elseif dstmp == 2 
     shading flat 
 elseif dstmp == 3
     shading faceted
 end;
 return
 
