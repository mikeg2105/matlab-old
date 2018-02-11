//save matrix
function [smat]=savemat(filename,nr,nc, mat)

 	fd=mopen(filename, 'w');
  mfprintf(fd, '%f %f\n', nr, nc);
	for i=1:nr
		for j=1:nc-1
	 		mfprintf(fd, '%f ', mat(i,j));
	 	end
	 	  mfprintf(fd, '%f \n', mat(i,nc));
	end
   
  smat=mat;
endfunction	
