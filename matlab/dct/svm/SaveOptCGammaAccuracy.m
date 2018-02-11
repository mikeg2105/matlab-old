function SaveOptCGammaAccuracy(t,cvalue,gammavalue,accurate)

    fid = fopen('saveOptCGammaaccuracy.txt','a');
   
    if (fid <0) 
        error('could not open file "saveOptCGammaaccuracy.txt"');
    end
      
    fprintf(fid,'%s \t %f %f %f \n',t,cvalue,gammavalue,accurate); 
    disp('save optimal CG File Writing...[Done]')
    fclose(fid);
  
	
