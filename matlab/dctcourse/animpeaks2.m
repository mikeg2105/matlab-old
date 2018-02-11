%animpeaks2
% Example script to animate the peaks function
%animpeaks2.m  compare this with animpeaks1.m using the profiler
%animpeaks2 uses element wise matrix operations for the computations

%initialisation
n=-20:20;
t=1;
omega=2*pi*0.04;    %oscillation frequency for peaks function
kx=pi*0.15;         %wavenumber component for x direction
ky=pi*0.03;         %wavenumber component for y direction

nsz=size(n);
nsize=nsz(2);

%initialise the x and y matrices
for i=1:nsize
    for j=1:nsize
        x(i,j)=0.1*n(i);
        y(i,j)=0.1*n(j);
    end
end

z=zeros(nsize,nsize);
z=peaks(x,y).*cos(omega*t+kx*x+ky*y);
h=surf(z);                              %Create initial surface return a handle for this graphic
axis([0 50 0 50 -10 10]);               %define axis and keep fixed 
hold on;                                %hold the graphics

for t=0:1000
    z=peaks(x,y).*cos(omega*t+kx*x+ky*y);
    pause(0.15);
    set(h,'ZData',z)                    %reset the z data for the grahics window with grahics handle h
    drawnow
end
hold off;