% This is an example use of the plot function 
% used in association with the finding of a root
% problem solved earlier.
% % a is the lower value of the range
% b is the upper value of the range

  a= 0; fa = -Inf;
  b =3  ; fb = Inf ;
  delta = (b-a)/100.;
  xx = a:delta:b ;
  plot( xx , xx.^3 - 2*xx -5 );
  hold on;
  hax = line([a b] ,[0 0] );
  set( hax , 'Color' ,'red' );
  while b-a > 1.0e-4

     x = ( a + b ) / 2;
     fx = x^3 - 2*x - 5 ;
     pause;
     if  sign(fx) == sign(fa)
        a=x;
        fa = fx ;
        plot( x , fx ,'o' )
     else
        b = x ;
        fb = fx;
        plot( x , fx , '+' )
     end

  end

  disp ( ' The root is :'  );
  disp (x) ;
  hold off;
