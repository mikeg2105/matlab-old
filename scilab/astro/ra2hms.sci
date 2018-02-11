function [h,m,s]=ra2hms(ra)
//http://mathworld.wolfram.com/ArcSecond.htm
// Convert ra 2 hours minutes seconds 2 ra
h=int(ra/15);
m=60*int((ra-(h*15)))/15;
s=3600*(ra-(h*15)-(m*60*15))/15

return;

endfunction

function [ra]=hms2ra(h,m,s)

// Convert ra 2 hours minutes seconds 2 ra
//http://en.wikipedia.org/wiki/Right_ascension
//
ra=h*15+((15*m)/60)+((15*s)/3600);
return;

endfunction

function [deg]=ams2deg(a,m,s)

//angle minutes and seconds to degrees

deg=a+(m/60)+(s/3600);
return;

endfunction

function [a,m,s]=deg2ams(deg)
//degrees to angle minutes and seconds

a=int(deg);
m=60*int((deg-a));
s=3600*(deg-h-(m*60));

return;
endfunction
