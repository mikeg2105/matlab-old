%npb number of points in base

function [bridgestress]=bridgestress(resfilename, nlayers, npb, ang1, ang2, loads, nloads)

  %points at which forces calculated
  npoints=(nlayers-1)*(2*npb+1);
   

  
  
  %resolved force matrix
  afx=build_afx(npoints, nlayers, npb, ang1, ang2);
  afy=build_afy(npoints, nlayers, npb, ang1, ang2);
  

  %input force vector
  fx=zeros(npoints,1);
  fy=zeros(npoints,1);
  
  %output stress vectors
  bx=zeros(npoints,1);
  by=zeros(npoints,1);
  
  for i=1:nloads
    fx(i)=loads(i, 1);
    fy(i)=loads(i, 2);
  end
  invafx=inv(afx);
  invafy=inv(afy);
  
  bx=invafx*fx;
  by=invafy*fy;
  
  tempstress=zeros(npoints,2);
  for i=1:npoints
    tempstress(i,1)=bx(i);
    tempstress(i,2)=by(i);
  end


  resfile=fopen(resfilename, 'w');
  
  %Write the vector of loads to the output
  fprintf(resfile, '%d', npoints);
  for i=1:npoints
    fprintf(resfile, '%f %f\n', bx(i), by(i));	
  end
  fclose(resfile);
  
  bridgestress=tempstress;
%endfunction


%Function to build a force matrix xdirection
function [build_afx]=build_afx(np, nl,npb, ang1, ang2)


  rang1=ang1*2*pi/360;
  rang2=ang2*2*pi/360;
  
  c1=cos(rang1);
  s1=sin(rang1);
  c2=cos(rang2);
  s2=sin(rang2);
  c190m=cos((pi/2)-rang1);
  s190m=sin((pi/2)-rang1);
  c290m=cos((pi/2)-rang2);
  s290m=sin((pi/2)-rang2);
   
  fmat=zeros(np, np);
  
  %cycle through each layer in turn
  %for each layer do the start point, end point and 
  %intermediate points
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %bottom layer
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  sp=1;
  ep=npb;
  i=1; 
  %start points
  fmat(i,i+npb)=0;
  fmat(i,i+npb+1)=c1;
  fmat(i,i+1)=1;
  
  %intermediate points
  for i=sp+1:ep-1
    fmat(i,i-1)=-1;
    fmat(i,i+1)=1;
    fmat(i,i+npb)=-c2;
    fmat(i,i+npb+1)=c1;
  end
  
  i=ep;
  %end points
  fmat(i,i+npb)=-c2;
  fmat(i,i+npb+1)=0;
  fmat(i,i-1)=-1; 
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %intermediate layers
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  for i=2:nl-1 	
  	if mod(i,2)==0
	%intermediate even layer
	        sp=(i*npb/2)+((i/2)-1)*(npb+1);
		ep=sp+npb;
		j=sp
		%start points
		fmat(j,j-npb)=0;
  		fmat(j,j+npb+1)=0;
  		fmat(j,j+1)=1;		
		

		
		%intermediate points
		for j=sp+1:ep-1
  			fmat(j,j+npb)=-c2;
  			fmat(j,j-npb-1)=-c1;
			fmat(j,j-npb)=c2;
  			fmat(j,j+npb+1)=c1;
			fmat(j,j+1)=1;
			fmat(j,j-1)=-1;
  		end
		
		j=ep;
		%end points
 		fmat(j,j+npb)=0;
  		fmat(j,j-npb-1)=0;
  		fmat(j,j-1)=-1;	 
		
	else
	%intermediate odd layer
	        sp=1+(npb*(i-1)/2)+((i-1)*(npb+1)/2);
		ep=sp+npb-1;
		%start points
		j=sp
		%start points
		fmat(j,j-npb)=c2;
		fmat(j,j+npb)=0;
  		fmat(j,j+npb+1)=c1;
		fmat(j,j-npb-1)=0;
  		fmat(j,j+1)=1;
				
		%intermediate points
		for j=sp+1:ep-1
 			fmat(j,j+npb)=-c2;
  			fmat(j,j-npb-1)=-c1;
			fmat(j,j-npb)=c2;
  			fmat(j,j+npb+1)=c1;
			fmat(j,j+1)=1;
			fmat(j,j-1)=-1; 
  		end
		
		%end points
		j=ep;
		%end points
		fmat(j,j+npb)=-c2;
  		fmat(j,j-npb-1)=-c1;
		fmat(j,j-npb)=0;
  		fmat(j,j+npb+1)=0;
		fmat(j,j-1)=-1;
		
	end
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %toplayer different action depending on whether odd or even layer
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  %toplayer always has npb+1 points
  
  i=nl;
  if mod(npb,2)==0
  	    sp=1+(i*npb/2)+((i/2)-1)*(npb+1);
		ep=sp+npb;
		%start
		j=sp;
		fmat(j,j-npb)=0;
  		fmat(j,j+1)=1;		
		%intermediate
		for j=sp+1:ep-1
  			fmat(j,j-npb-1)=-c1;
			fmat(j,j-npb)=c2;
  			fmat(j,j-1)=-1;
			fmat(j,j+1)=1;  
  		end
		
		%end
  		j=ep;
		fmat(j,j-npb)=0;
  		fmat(j,j-1)=-1;
  else
  	    sp=1+(npb*(i-1)/2)+((i-1)*(npb+1)/2);
		ep=sp+npb-1;
		%start
		j=sp;
		fmat(j,j-npb)=c2;
  		fmat(j,j-npb-1)=0;
		fmat(j,j+1)=1;
				
		%intermediate
		for j=sp+1:ep-1	
  			fmat(j,j-npb-1)=-c1;
			fmat(j,j-npb)=c2;
  			fmat(j,j-1)=-1;
			fmat(j,j+1)=+1; 
  		end
		
		%end
 		j=ep;
		fmat(j,j-npb)=0;
  		fmat(j,j-npb-1)=-c1;
		fmat(j,j-1)=-1; 
  end
  
  
  build_afx=fmat;
  
%endfunction

%Function to build a force matrix ydirection
function [build_afy]=build_afy(np, nl,npb, ang1, ang2)


  rang1=ang1*2*pi/360;
  rang2=ang2*2*pi/360;
  
  c1=cos(rang1);
  s1=sin(rang1);
  c2=cos(rang2);
  s2=sin(rang2);
  c190m=cos((pi/2)-rang1);
  s190m=sin((pi/2)-rang1);
  c290m=cos((pi/2)-rang2);
  s290m=sin((pi/2)-rang2);
   
  fmat=zeros(np, np);
  
  %cycle through each layer in turn
  %for each layer do the start point, end point and 
  %intermediate points
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %bottom layer
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  sp=1;
  ep=npb;
  i=1; 
  %start points
  fmat(i,i+npb)=1;
  fmat(i,i+npb+1)=s1;
  fmat(i,i+1)=0;
  
  %intermediate points
  for i=sp+1:ep-1
    fmat(i,i-1)=0;
    fmat(i,i+1)=0;
    fmat(i,i+npb)=s2;
    fmat(i,i+npb+1)=s1;
  end
  
  i=ep;
  %end points
  fmat(i,i+npb)=s2;
  fmat(i,i+npb+1)=1;
  fmat(i,i-1)=0; 
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %intermediate layers
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  for i=2:nl-1 	
  	if mod(i,2)==0
	%intermediate even layer
	        sp=(i*npb/2)+((i/2)-1)*(npb+1);
		ep=sp+npb;
		j=sp
		%start points
		fmat(j,j-npb)=-1;
  		fmat(j,j+npb+1)=1;
  		fmat(j,j+1)=0;		
		

		
		%intermediate points
		for j=sp+1:ep-1
  			fmat(j,j+npb)=s2;
  			fmat(j,j-npb-1)=-s1;
			fmat(j,j-npb)=-s2;
  			fmat(j,j+npb+1)=s1;
			fmat(j,j+1)=0;
			fmat(j,j-1)=0;
  		end
		
		j=ep;
		%end points
 		fmat(j,j+npb)=1;
  		fmat(j,j-npb-1)=-1;
  		fmat(j,j-1)=0;	 
		
	else
	%intermediate odd layer
	        sp=1+(npb*(i-1)/2)+((i-1)*(npb+1)/2);
		ep=sp+npb-1;
		%start points
		j=sp
		%start points
		fmat(j,j-npb)=-s2;
		fmat(j,j+npb)=1;
  		fmat(j,j+npb+1)=s1;
		fmat(j,j-npb-1)=-1;
  		fmat(j,j+1)=0;
				
		%intermediate points
		for j=sp+1:ep-1
 			fmat(j,j+npb)=s2;
  			fmat(j,j-npb-1)=-s1;
			fmat(j,j-npb)=-s2;
  			fmat(j,j+npb+1)=s1;
			fmat(j,j+1)=0;
			fmat(j,j-1)=0; 
  		end
		
		%end points
		j=ep;
		%end points
		fmat(j,j+npb)=s2;
  		fmat(j,j-npb-1)=-s1;
		fmat(j,j-npb)=-1;
  		fmat(j,j+npb+1)=1;
		fmat(j,j-1)=0;
		
	end
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %toplayer different action depending on whether odd or even layer
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  i=nl;
  if mod(npb,2)==0
  	    sp=1+(i*npb/2)+((i/2)-1)*(npb+1);
		ep=sp+npb;
		%start
		j=sp;
		fmat(j,j-npb)=-1;
  		fmat(j,j+1)=0;		
		%intermediate
		for j=sp+1:ep-1
  			fmat(j,j-npb-1)=-s1;
			fmat(j,j-npb)=-s2;
  			fmat(j,j-1)=0;
			fmat(j,j+1)=0;  
  		end
		
		%end
  		j=ep;
		fmat(j,j-npb)=-1;
  		fmat(j,j-1)=0;
  else
  	        sp=1+(npb*(i-1)/2)+((i-1)*(npb+1)/2);
		ep=sp+npb-1;
		%start
		j=sp;
		fmat(j,j-npb)=-s2;
  		fmat(j,j-npb-1)=-1;
		fmat(j,j+1)=0;
				
		%intermediate
		for j=sp+1:ep-1	
  			fmat(j,j-npb-1)=-s1;
			fmat(j,j-npb)=-s2;
  			fmat(j,j-1)=0;
			fmat(j,j+1)=0; 
  		end
		
		%end
 		j=ep;
		fmat(j,j-npb)=-1;
  		fmat(j,j-npb-1)=-s1;
		fmat(j,j-1)=0; 
  end
  
  
  build_afy=fmat;
  
%endfunction
