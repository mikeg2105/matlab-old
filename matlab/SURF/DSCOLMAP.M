% colour map  control for interactive surface plotting.

 dstmp = get(dsh4,'value');
 figure(h0);
 if dstmp == 1
     colormap(hsv)
 elseif dstmp == 2 
     colormap(hsv)
 elseif dstmp == 3
     colormap(hot)
 elseif dstmp == 4
     colormap(cool)
 elseif dstmp == 5
     colormap(gray)
 end;
 return
 
