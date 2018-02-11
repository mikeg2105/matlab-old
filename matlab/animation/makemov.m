% makemovie script

z=peaks;
h=surf(z,'FaceColor','interp' , 'LineStyle' , 'none' );
grid off;
v = axis;
axis off;
[az,el] = view;


for frameno = 1:50
     view(az,el);
     axis(v)
    if frameno < 10  
       el = el + 2.0
    else
        el = el - 2.0
    end
    az = az + 3.0
%    pause
    M(frameno) = getframe;
end    