function [mydiffuse]=mydiffuse(jobname,nsteps, nsubsteps, dt, in, concs, sources, sinks)

  //diffusion system initial values
  d=in(1);
  n1=in(2);
  n2=in(3);
  n3=in(4);
  h=in(5);
  t0=0; 
  t=t0;
  
  ddt=dt/nsubsteps
  printf('sub steps: %d \n', nsubsteps);
  //smat=zeros(4,nsteps)

	for ii=1:nsteps
	    printf('step= %d \n', ii);	    
      //newconc=diffuse(nsubsteps, t,t0,dt, in, concs, sources, sinks);	
      concn=newtempconc(nsubsteps, t,t0,dt, in, concs, sources, sinks);	
      //printf('conc=%f\n',concn(2,2,1));
	  	 t0=t;
	  	 t=t0+dt;
      concs=concn;
      //printf()
  		  //save the matrix for this step
      //sfilename=sprintf('diffuse_%d.dat', ii);
      sfilename=sprintf('%s.dat',jobname);
      sx3dfilename=sprintf('%s_%d.x3d', jobname,ii);
      saveconcs(sfilename,n1,n2,n3,nsteps,concs);
      //updatefilelist(ii,'diffuse',n1,n2,n3,concs);
 end               
      //save config to config filelist
      //if ii==1
      //   fd=mfopen('diffuse_datlist.lis', 'w');
      //   mfprintf(fd, '%s\n',sfilename);
      //else
      //       appendfilelist('diffuse_datlist.lis',sfilename);
      //end
           
          
      //x3d list 
      //if ii==1
      //       fd=mfopen('diffuse_x3dlist.lis', 'w');
      //       mfprintf(fd, '%s_x3d\n',sx3dfilename);
      //else
      //       appendfilelist('diffuse_x3dlist.lis',sx3dfilename);
      //end
          
      //maxmin(1) is maximum concentration
      //maxmin(2) is minimum concentration
      //maxmin=getmaxminconc(concs,n1,n2,n3);
          
      //save config to x3d format
      //diffuse_x3d(sx3dfilename, n1,n2,n3,concs,h,maxmin(1),maxmin(2));
	//end

	
  diffuse=newconc
 
endfunction

function [diffuse]=diffuse(nsubsteps,t,t0, dt, in, concs, sources, sinks)

  //diffusion system initial values
  d=in(1);
  n1=in(2);
  n2=in(3);
  n3=in(4);
  h=in(5);
  sources=zeros(n1,n2,n3);
  sinks=zeros(n1,n2,n3);
  concs=rand(n1,n2,n3);
  //concs(1,1,1)=1;
  ddt=dt/nsubsteps;
  newc=zeros(n1,n2,n3);
	for kk=1:nsubsteps
	    mprintf('substep=%d\n', kk);
	    //if kk==1
	     // printf('%f %d %d %d %f\n',in(1),in(2),in(3),in(4),in(5));
	     // mprintf('%f %f %d %d %d\n', concs(4,4,1),concs(1,4,1),n1,n2,n3);
	    //end
	    t=t0+ddt;
	    //susceptible 
  	  	concs=newconc(concs,t0,t,n1,n2,n3,h,d,sources,sinks);
  	  	//concs=newc;
  	  	//newc=rand(n1,n2,n3);
	  	 t0=t;
  end

  diffuse=concs
 
endfunction

function [newtempconc]=newtempconc(nsubsteps, t,t0,dt, in, concs, sources, sinks)

  //cycle over each element of the array
  //update concentration
  dif=in(1);
  n1=in(2);
  n2=in(3);
  n3=in(4);
  h=in(5);
  nconc=zeros(n1,n2,n3);
  ddt=dt/nsubsteps;
  
	for kk=1:nsubsteps
	t=t0+ddt;
	for i1=1:n1
	      for i2=1:n2
	      			for i3=1:n3
	      			   nconc(i1,i2,i3)=concupdate(concs, i1,i2,i3,n1,n2,n3,t0,t,h,dif,sources,sinks);
	      			end
	      end
	end
	concs=nconc;
	t0=t
	end

	newtempconc=nconc;

endfunction

function [newconc]=newconc(conc,t0,t, n1, n2, n3,h,dif,sources,sinks)

  //cycle over each element of the array
  //update concentration
  nconc=zeros(n1,n2,n3);
	for i1=1:n1
	      for i2=1:n2
	      			for i3=1:n3
	      			   nconc(i1,i2,i3)=concupdate(conc, i1,i2,i3,n1,n2,n3,t0,t,h,dif,sources,sinks);
	      			end
	      end
	end

	newconc=nconc;

endfunction

function [concupdate]=concupdate(conc, i1,i2,i3,n1,n2,n3,t0,t,h,dif,msources,msinks)
	      			   //get submatrix
	      						//concsub=zeros(3,3,3)
	      						concsub=getconcsub(conc,i1,i2,i3,n1,n2,n3);
	
	      						//got sub matrix
	      						//calculate laplacian
	      						lap=lap3d(concsub,h);
	
	      						sink=msinks(i1,i2,i3);
	      						source=msources(i1,i2,i3);
	      						c=conc(i1,i2,i3);
	      						//use laplacian to update
               //scilab
               //mprintf('in concupdate: %f %f\n', t0,t);
               //mprintf('in concupdate: %f %f\n',source,sink);
               //sink=0;
               //source=0;
               cdash=dif*lap-sink+source;
               
               //mprintf('cdash: %d %d %d %f\n',i1,i2,i3,cdash);
               //newc=ode(cdash,t0,t,cdott);
               //newc=c+cdash*(t-t0);
	      						newc=ode(c,t0,t,list(cdott,lap,dif,sink,source));
               //matlab
               // cdash=-dif*lap-sink+source
	      						//newconc=ode45(@cdydt,[t0,t],cdash)
	      						
	      						if newc<0
	      						  newc=0;
	      						end
	      						
	      						concupdate=newc;;

endfunction










//-->x=ode(x0,t0,t,list(sdotx,p,yold))
function [cdott]=cdott(t,c,lap3d,dif,sink,source)
//function [cdott]=cdott(t,c)
  //mprintf('cdott %f',c);
	//cdott=c;
	cdott=dif*lap3d-sink+source;
endfunction


//Calculates 3x3x£ matrix of nearest neighbour elements for a value
function [getconcsub]=getconcsub(conc, i1,i2,i3, n1, n2, n3)
                                                
                                                if n3<2
						  nsub3=1;
						else
					          nsub3=3;
						end;

      						testconcsub=zeros(3,3,3);
	      						for j1=-1:1
	      							for j2=-1:1
	      								for j3=-1:1
	      									si1=i1+j1
	      									si2=i2+j2
	      									si3=i3+j3
	      									
	      									if si1>0 
	      										if si1<=n1
	      									  		if si2>0
	      									  			if si2<=n2
                                                            if si3>0
                                                                if si3<=n3
	      																		testconcsub(j1+2, j2+2, j3+2)=conc(si1,si2,si3);
	      									        			end
                                                            end
                                                        end
	      											end
	      										end		
	      									end
	      									//finished checking bcs
	      											
	      								end
	      							end
                                end
                                getconcsub=testconcsub;
endfunction



//Calculate laplacian in 3d
//n1xn2xn3 conc array
//size n1xn2xn3
//
//Will always be a 3x3x3 piece of the complete 
//array at this point there is no boundary condition check
function [lap3d]=lap3d(conc,h)

   t1=conc(3,2,2)-2*conc(2,2,2)+conc(1,2,2);
   t2=conc(2,3,2)-2*conc(2,2,2)+conc(2,1,2);
   t3=conc(2,2,3)-2*conc(2,2,2)+conc(2,2,1);
   lap3d=(t1+t2+t3)/(h*h);
endfunction






