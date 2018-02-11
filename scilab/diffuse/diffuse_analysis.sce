//General analysis of diffusion model output
//read a sequence of files from a list

function [status]=diffuse_analysis(filelist,nsteps)
 
    //selected element
    i1=1;
    i2=1;
    i3=1;
    stemp='filename';       
    aresults=zeros(nsteps);
    
    fd=mopen(filelist,'r');

    for itemp=1:nsteps
      sfilename=mfscanf(fd,'%s');
      mprintf('%d %s\n',itemp,sfilename);
      fp=mopen(sfilename,'r');     
      //read n1,n2,n3
      mconc=difreadconc(sfilename,i1,i2,i3);
      aresults(itemp)=mconc; 
      //mprintf('%f ',mconc);
    end
    mclose(fd);
    
    for itemp=1:nsteps
      mprintf('%f ',aresults(itemp));   
    end
    status=aresults;
	
endfunction

//General analysis of diffusion model output
//read a sequence of files from a list
//output a an elevation graph

//diffuse_analy_faceset('diffuse_datlist.LIS', 'facesett1',3, 4, 4, 1, 1, 2, 3, 1);
function diffuse_analy_faceset(filelist, outfilename, nsteps,n1,n2,n3,p1,p2,p3,layer)

   //selected element
   // p1=1;
   // p2=2;
   // p3=3;
    
    stemp='filename';       
    //aresults=zeros(nsteps);
    
    fd=mopen(filelist,'r');
    
    selevlist=sprintf('%s_list.rec', outfilename);
    sname=outfilename;
    for itemp=1:nsteps
      sfilename=mfscanf(fd,'%s');
      mprintf('%d %s\n',itemp,sfilename);
      mconc=difreadmat(sfilename);
      selevfilename=sprintf('%s_%d.x3d',sname,itemp);
      maxminconc=getmaxminconc(mconc,n1,n2,n3);
      maxminconc(1)=10
      diffuse_faceset_x3d(selevfilename, n1,n2,n3,mconc,maxminconc(1),maxminconc(2),p1,p2,p3,layer);
      printf('maxmin conc= %s %f %f\n',selevfilename, maxminconc(1), maxminconc(2));
      appendfilelist(selevlist,selevfilename);
      //aresults(itemp)=mconc; 
    end
    mclose(fd);
    
    //for itemp=1:nsteps
    //  mprintf('%f ',aresults(itemp));   
    //end
    //status=aresults;
	

endfunction




//General analysis of diffusion model output
//read a sequence of files from a list
//output a an elevation graph

//diffuse_analy_elev('diffuse_datlist.LIS', 'elevt1',10, 4, 4, 1, 1, 2, 3, 1);
function diffuse_analy_elev(filelist, outfilename, nsteps,n1,n2,n3,p1,p2,p3,layer)
 
    //selected element
   // p1=1;
   // p2=2;
   // p3=3;
    
    stemp='filename';       
    //aresults=zeros(nsteps);
    
    fd=mopen(filelist,'r');
    
    selevlist=sprintf('%s_list.rec', outfilename);
    sname=outfilename;
    for itemp=1:nsteps
      sfilename=mfscanf(fd,'%s');
      mprintf('%d %s\n',itemp,sfilename);
      mconc=difreadmat(sfilename);
      selevfilename=sprintf('%s_%d.x3d',sname,itemp);
      maxminconc=getmaxminconc(mconc,n1,n2,n3);
      diffuse_elevgrid_x3d(selevfilename, n1,n2,n3,mconc,maxminconc(1),maxminconc(2),p1,p2,p3,layer);
      printf('maxmin conc= %s %f %f\n',selevfilename, maxminconc(1), maxminconc(2));
      appendfilelist(selevlist,selevfilename);
      //aresults(itemp)=mconc; 
    end
    mclose(fd);
    
    //for itemp=1:nsteps
    //  mprintf('%f ',aresults(itemp));   
    //end
    //status=aresults;
	
endfunction


