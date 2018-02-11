%DATEDISP  Displays date
% This is an Matlab Script example which can be called
% to display the current date in an easier to understand
% format.
months =[ 'January ' ; 'February';'March   ';'April   '; 'May     ' ;'June    ';...
      'July    ';'August  ';'Septembr';'October ';'November';'December' ];
% [year month day hour minute second]  = clock
a = clock;
syear = num2str( a(1));
sday  = num2str( a(3) );
month = a(2);

string = [ 'Todays date:' sday ',' months(month,:) ',' syear ];

disp(string) ;
