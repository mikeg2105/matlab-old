function [fd,err]=savevtk_xym(x,y,m,VarName)

// Save Sci variables in VTK format
// x is a list of points
// y is a list of values in the x points
// VarName is the Variable Name

//  Example:
//
//  mtst=[11 12 13 14; 21 22 23 24];
//  [f,c]=size(mtst);
//  savevtk_xym(1:c,1:f,mtst,'2DMatrix');
//
// Coded by Sebastian Jardi Estadella
// http://www.tinet.org/~sje/index_en.htm
//


// rotates the matrix -90 º.

xaux=x;
x=y;
y=xaux;
m=m';

nx=length(x);
ny=length(y);
[nf,nc]=size(m);

if nx<>nc then 
  disp('length(nx) and length(nc) have to be equals.');
  disp(nx);
  disp(nc);
  abort;
end

if ny<>nf then 
  disp('length(ny) and kength(nf) have to be equals.');
  disp(ny);
  disp(nf);
  abort;
end

filename=sprintf('%s.vtk',VarName);

mputl('# vtk DataFile Version 2.0',filename);   // Delete previous content in filename

[fd,err]=mopen(filename, 'a');     // Opens the file to Append.

mfprintf(fd,'Structured Grid\n');
mfprintf(fd,'ASCII\n');
mfprintf(fd,'\n');
mfprintf(fd,'DATASET RECTILINEAR_GRID\n');
mfprintf(fd,'DIMENSIONS %d %d %d\n',nx,ny,1);    //??

mfprintf(fd,'X_COORDINATES %d double\n',nx);
for i=1:nx
  mfprintf(fd,'%e\n',x(i));  
end
mfprintf(fd,'\n');

mfprintf(fd,'Y_COORDINATES %d double\n',ny);
for i=1:ny
  mfprintf(fd,'%e\n',y(i));  
end
mfprintf(fd,'\n');

mfprintf(fd,'Z_COORDINATES 1 double\n');
mfprintf(fd,'0 \n');

mfprintf(fd,'\n');
mfprintf(fd,'POINT_DATA %d\n',nx*ny);
mfprintf(fd,'SCALARS ');
mfprintf(fd,VarName);
mfprintf(fd,' double 1\n');
mfprintf(fd,'LOOKUP_TABLE TableName\n');
for i_f=1:nf
  for i_c=1:nc
    mfprintf(fd,'%e ',m(i_f,i_c));  
  end
  mfprintf(fd,'\n');
end
mfprintf(fd,'\n');

err=mclose(fd);


endfunction

