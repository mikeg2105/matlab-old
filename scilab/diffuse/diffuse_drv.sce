

//may be require a component to
//generate a random model



function [plotmodel]=plotmodel()

  n1=4;
  n2=4;
  n3=1;

	in(1)=0.015  //d
  in(2)=n1   //n1
  in(3)=n2    //n2
  in(4)=n3  //n3
  in(5)=0.05    //h
  
  //For each species
  //create
  //1. Initial concentration
  //2. Sources
  //3. Sinkss
  //4. species
  concsin=rand(n1,n2,n3);
  sources=zeros(n1,n2,n3);
  sources(n1/2,n2/2,1)=rand();
  sources(1,1,1)=0.01;
  sinks=zeros(n1,n2,n3);
  sinks(n1,n2,n3)=0.01;
  //read initial configuration from an old one
  
	sirout=mydiffuse(10,10,0.0001, in,concsin,sources,sinks);
	
	//t=(1:1:2000);
	//X=[sirout(4, :);sirout(4, :);sirout(4, :)];
	//Y=[sirout(1, :);sirout(2, :);sirout(3, :)];
	//plot2d(X',Y',style=[-1 -2 -3]',leg="x@y@y")
	plotmodel=sirout

endfunction

function updatefilelist(ii,filename,n1,n2,n3,concs,h)

  		  //save the matrix for this step
      sfilename=sprintf('%s_%d.dat', filename,ii);
      sx3dfilename=sprintf('%s_%d.x3d', filename,ii);
      mprintf('%s %s',sfilename, sx3dfilename);
      saveconcs(sfilename,n1,n2,n3,concs);
    //save config to config filelist
      if ii==1
         fd=mopen('diffuse_datlist.lis', 'w');
         mfprintf(fd, '%s\n',sfilename);
      else
             appendfilelist('diffuse_datlist.lis',sfilename);
      end
           
          
      //x3d list 
      if ii==1
             fd=mopen('%s_x3dlist.lis','w');
             mfprintf(fd, '%s_x3d\n',sx3dfilename);
      else
             appendfilelist('diffuse_x3dlist.lis',sx3dfilename);
      end
          
      //maxmin(1) is maximum concentration
      //maxmin(2) is minimum concentration
      maxmin=getmaxminconc(concs,n1,n2,n3);
      
       mprintf('max=%f min=%f\n',maxmin(1),maxmin(2));
       maxmin(1)=2;
      maxmin(2)=0;
      //save config to x3d format
      //diffuse_x3d(sx3dfilename, n1,n2,n3,concs,h,maxmin(1),maxmin(2));

endfunction


//separate filelist for each species
function updatemfilelist(ii,filename,n1,n2,n3,nspecies, concsm,h)

  		  //save the matrix for this step
  		  
  		  for i=1:nspecies
  		    concs=concsm(:,:,:,i);
  		    sdatlistfile=sprintf('diffuse_datlist_%d.lis',i);
        sfilename=sprintf('%s_%d_%d.dat', filename,i,ii);
        sx3dfilename=sprintf('%s_%d.x3d', filename,ii);
        mprintf('%s %s',sfilename, sx3dfilename);
        saveconcs(sfilename,n1,n2,n3,concs);
        //save config to config filelist
        if ii==1
           fd=mopen(sdatlistfile, 'w');
           mfprintf(fd, '%s\n',sfilename);
        else
           appendfilelist(sdatlistfile,sfilename);
        end
           
          
        //x3d list 
        if ii==1
               fd=mopen('%s_x3dlist.lis','w');
               mfprintf(fd, '%s_x3d\n',sx3dfilename);
        else
               appendfilelist('diffuse_x3dlist.lis',sx3dfilename);
        end
          
        //maxmin(1) is maximum concentration
        //maxmin(2) is minimum concentration
        maxmin=getmaxminconc(concs,n1,n2,n3);
      
         mprintf('max=%f min=%f\n',maxmin(1),maxmin(2));
         maxmin(1)=2;
        maxmin(2)=0;
        //save config to x3d format
        diffuse_x3d(sx3dfilename, n1,n2,n3,concs,h,maxmin(1),maxmin(2));
      //end count over species
      end

endfunction






