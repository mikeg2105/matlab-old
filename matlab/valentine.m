% example script using plotting primitives
%
close % close any existing figures.
axis([-4  ,4, -4, 4 , -4 , 4]);
axis equal;  % this ensures that the view aspect ration is the same as 
%              physical aspect ratio.
hold on
% generate one semi circle of the heart.
t = 0.0:0.1:pi ;
X1 = cos(t)-1.0; Y1=sin(t) ;
% generate tail end.
t = pi:0.1:2*pi ;
X2 =cos(t)-1.0; Y2 =sin(t)+0.9.*(pi-t); 
% tag points along.
X = [X1 X2 ];
Y = [Y1 Y2 ];
Z = zeros( size(X) ) ;
hidden on;
fill3( X, Y, Z , 'red', 'LineStyle' , 'none') ;
% mirror image of first half.
fill3(-X ,Y, Z , 'red' ,'LineStyle' , 'none') ;
%  the arrow
XA = [0.0 -0.1  -0.1 0.0] ; YA = [ -0.4 -0.4 -0.6 -0.6 ] ;
ZA = [ 1.5 0  0  1.5 ] ;
fill3( XA , YA , ZA, 'yellow' );
XA = [-0.1 -0.2  -0.2 -0.1] ; YA = [ -0.4 -0.6 -0.8 -0.6 ] ;
ZA = [ 0 -1.5 -1.5 0 ] ;
fill3( XA , YA , ZA, 'yellow' );
XB= [ 0 0 0 ] ; YB = [ -0.2 -0.4 -0.8 ] ; ZB = [ 1.5 1.9 1.5 ];
fill3( XB , YB , ZB, 'yellow' );
 