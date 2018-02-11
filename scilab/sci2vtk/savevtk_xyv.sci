function [fd,err]=savevtk_xyv(x,y,vx,vy,VarName)

// Save Sci variables in VTK format
// x is a list of points
// y is a list of values in the x points
// VarName is the Variable Name

//  Example:
//
//  mtst=[11 12 13 14; 21 22 23 24];
//  [sy,sx]=size(mtst);
//  savevtk_xyv(1:sx,1:sy,mtst,mtst,'2DVectors');
//
// Coded by Sebastian Jardi Estadella
// http://www.tinet.org/~sje/index_en.htm
//



// rotates the matrix -90 º.

vx=vx';
vy=vy';

nx=length(x);
ny=length(y);
[nfvx,ncvx]=size(vx); // number for rows and columns
[nfvy,ncvy]=size(vy);

if nx<>ncvx then 
  disp('length(x) and ncvx have to be equals.');
  disp(nx);
  disp(ncvx);
  abort;
end

if nx<>ncvy then 
  disp('length(x) and ncvy have to be equals.');
  disp(nx);
  disp(ncvy);
  abort;
end

if ny<>nfvx then 
  disp('length(x) and nfvx have to be equals.');
  disp(ny);
  disp(nfvx);
  abort;
end

if ny<>nfvy then 
  disp('length(x) and nfvy have to be equals.');
  disp(ny);
  disp(nfvy);
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
  mfprintf(fd,'%f\n',x(i));  
end
mfprintf(fd,'\n');

mfprintf(fd,'Y_COORDINATES %d double\n',ny);
for i=1:ny
  mfprintf(fd,'%f\n',y(i));  
end
mfprintf(fd,'\n');

mfprintf(fd,'Z_COORDINATES 1 double\n');
mfprintf(fd,'0 \n');

mfprintf(fd,'\n');
mfprintf(fd,'POINT_DATA %d\n',nx*ny);
mfprintf(fd,'VECTORS ');
mfprintf(fd,VarName);
mfprintf(fd,' double\n');
for i_f=1:nfvx
  for i_c=1:ncvx
    mfprintf(fd,'%f %f 0.0\n',vx(i_f,i_c),vy(i_f,i_c));  
  end
end
mfprintf(fd,'\n');

err=mclose(fd);


endfunction

