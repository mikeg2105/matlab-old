function xm = mean(x)
% MEAN : Calculate the mean value.
% For vectors: returns a value.
% For matrices: returns the mean value of each column.
 [ m , n ] = size ( x );
if m == 1
   m = n ;
end
xm = sum(x)/m;

