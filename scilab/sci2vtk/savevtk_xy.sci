function [fd,err]=savevtk_xy(x,y,VarName)

// Save Sci variables in VTK format
// x is a list of points
// y is a list of values in the x points
// VarName is the Variable Name
//
// Example:
//
// x=[0:0.1:2*%pi];
// y=sin(x);
// plot(x,y);
// savevtk_xy(x,y,'sin(x)');
//
// Coded by Sebastian Jardi Estadella
// http://www.tinet.org/~sje/index_en.htm
//

nx=length(x);
ny=length(y);
if nx<>ny then 
  disp('X and Y have to be of the same length');
  abort;
end

filename=sprintf('%s.vtk',VarName);

mputl('# vtk DataFile Version 2.0',filename);   // Delete previous content in filename

[fd,err]=mopen(filename, 'a');     // Opens the file to Append.

mfprintf(fd,'Structured Grid\n');
mfprintf(fd,'ASCII\n');
mfprintf(fd,'\n');
mfprintf(fd,'DATASET RECTILINEAR_GRID\n');
mfprintf(fd,'DIMENSIONS %d %d %d\n',nx,1,1);    //??

mfprintf(fd,'X_COORDINATES %d double\n',nx);
for i=1:nx
  mfprintf(fd,'%e\n',x(i));  
end
mfprintf(fd,'\n');

mfprintf(fd,'Y_COORDINATES 1 double\n');
mfprintf(fd,'0 \n');

mfprintf(fd,'Z_COORDINATES 1 double\n');
mfprintf(fd,'0 \n');

mfprintf(fd,'\n');
mfprintf(fd,'POINT_DATA %d\n',nx);
mfprintf(fd,'SCALARS ');
mfprintf(fd,VarName);
mfprintf(fd,' double 1\n');
mfprintf(fd,'LOOKUP_TABLE TableName\n');
for i=1:length(y)
  mfprintf(fd,'%e\n',y(i));  
end
mfprintf(fd,'\n');

err=mclose(fd);

endfunction

