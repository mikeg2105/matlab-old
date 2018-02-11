% example script using plotting primitives
%
close
axis([-2  ,2, -2, 2]);
axis equal;  % this ensures that the view aspect ration is the same as 
%              physical aspect ratio.
hold on
X = [ 1 0.3  0  -0.3 -1  -0.3   0  0.3  1 ];
Y = [ 0 0.3  1   0.3  0  -0.3  -1 -0.3  0 ];
line (X , Y );
pause( 2) ;
XX = [ -0.3 0.3 0.3  -0.3 ] ;
YY = [ 0.3 0.3 0.0 0.0 ]
fill ( XX , YY ,'r' )
pause( 2) ;
YY = YY -0.3 ;
C = [ 0 ;1 ;2 ;0 ];
patch ( XX , YY ,C ) % fill3 can also be used with same arguments here.
pause( 2) ;
% note below that almost all graphics object creation function can be called 
% in the following manner to return a graphics handle (h), which can then be
% used for setting the properties of that object
h=rectangle('Position',[ 1.0 ,-0.3 , 1.0 , 0.5] );
pause(2);
set( h,'Curvature', [ 1 1 ]  );
set ( h, 'FaceColor','green' ) ;
hold off