%The following example is useful if you wish to 
%plot figures without actually displaying any graphics
%(i.e. you wish your job to produce some graphical output for you)

x=rand(10)*4-2; y=rand(10)*4-2; z=x.*exp( -x.^2-y.^2);
t=-2:0.1:2;
[xx,yy]=meshgrid(t,t);
zz=griddata(x,y,z,xx,yy);


h1=figure('Visible','off','IntegerHandle','Off');

hold on;

%Need to alter the camer position so
%hget the child property of the figure which are the axes
hax=get(h1,'Children');
set(hax,'CameraPosition',[-24 -11 5]);

mesh(xx,yy,zz);
plot3(x,y,z,'o');




%print the most recent figure to a file
print -djpeg 'test3.jpg'
hold off;

%load the image from the file
%imdata=imread('test.jpg','jpeg');

%display the imported image
%h2=figure('Visible','On);
%image(imdata);