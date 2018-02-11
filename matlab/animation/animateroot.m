% This is an example use of the plot function 
% used in association with the finding of a root
% problem solved earlier.
% % a is the lower value of the range
% b is the upper value of the range

  a= 0  ; fa = -5;
  b =3  ; fb = b.^3 - 2*b - 5 ;
  delta = (b-a)/100.;
% plot the line ....  
  xx = a:delta:b ;
  plot( xx , xx.^3 - 2*xx -5 );
  hold on;
  hax = line([a b] ,[0 0] );
  set( hax , 'Color' ,'red' );
  
% plot the starting points at each end:  
  plot( a , fa ,'o','MarkerFaceColor','g','MarkerSize',10,'EraseMode','xor') 
  plot( b , fb ,'s','MarkerFaceColor','r','MarkerSize',10,'EraseMode','xor') 
  
  while b-a > 1.0e-3
     
     x = ( a + b ) / 2;
     fx = x^3 - 2*x - 5 ;
     pause(0.5);
     if  sign(fx) == sign(fa)
% erase the previous marker ...         
        plot( a , fa ,'o','MarkerFaceColor','g','MarkerSize',10,'EraseMode','xor') 
        a=x;
        fa = fx ;
        plot( a , fa ,'o','MarkerFaceColor','g','MarkerSize',10,'EraseMode','xor') 
    else
% erase the previous marker ...         
        plot( b , fb ,'s','MarkerFaceColor','r','MarkerSize',10,'EraseMode','xor') 
        b = x ;
        fb = fx;
        plot( x , fx , 's', 'MarkerFaceColor','r','MarkerSize',10,'EraseMode','xor' )
     end

  end

  disp ( ' The root is :'  );
  disp (x) ;
  hold off;
