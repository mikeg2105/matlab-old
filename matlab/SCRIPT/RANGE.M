function [ xmin ,xmax ,range]= range(x)
% MEAN : Calculate the range limits + interval.
% For vectors: returns three values minimum, maximum and interval.
% For matrices: returns three vectors containing the minimum,
% maximum and range for each column respectively.
 [ m , n ] = size ( x );
if m == 1
   m = n ;
end
xmin = min(x);
xmax = max(x);
range = max(x)-min(x);


