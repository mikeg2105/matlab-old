//save xyz values
function diffuse_x3d(filename, n1,n2,n3,concs,h,maxconc,minconc)

  sDescription='Simple X3D example';
  sCreated='30 October 2000';
  sRevised='6 March 2003';
  sURL='http://www.shef.ac.uk/personal/m/mikeg/x3d/diffuse_out.x3d';
  sAuthor='Mike Griffiths';
 	fd=writex3d(filename ,sDescription, sCreated, sRevised, sURL, sAuthor);
	
  openxml(fd, 'Group');

  viewp=zeros(3);
  viewrot=zeros(4);
  viewp(1)=6;
  viewp(2)=-1;
  viewp(3)=0;
  viewrot(1)=0;
  viewrot(2)=1;
  viewrot(3)=0;
  viewrot(4)=1.57
  
  writex3dviewpoint(fd, 'diffuse', viewrot, viewp);
	writex3dnavinfo(fd)
	
	//writex3ddefobject(fd)
	for i=1:n1
        for j=1:n2
            for k=1:n3
	 		        writex3dobject(fd, concs, n1,n2,n3,i,j,k,h,maxconc,minconc)
            end
        end
    end
	

  closexmlelement(fd, 'Group');
  closex3d(fd);

endfunction

function diffuse_elevgrid_x3d(filename, n1,n2,n3,concs,maxconc,minconc,p1,p2,p3,layer)

  sDescription='Simple X3D example';
  sCreated='30 October 2000';
  sRevised='6 March 2003';
  sURL='http://www.shef.ac.uk/personal/m/mikeg/x3d/diffuse_out.x3d';
  sAuthor='Mike Griffiths';
  fd=writex3d(filename ,sDescription, sCreated, sRevised, sURL, sAuthor);
	
  openxml(fd, 'Group');

  viewp=zeros(3);
  viewrot=zeros(4);
  viewp(1)=6;
  viewp(2)=-1;
  viewp(3)=0;
  viewrot(1)=0;
  viewrot(2)=1;
  viewrot(3)=0;
  viewrot(4)=1.57
  
  writex3dviewpoint(fd, 'diffuse', viewrot, viewp);
	writex3dnavinfo(fd);
	
	//p1=1;
	//p2=2;
	//p3=3;
	
	np(1)=n1;
	np(2)=n2;
	np(3)=n3;
	
	
	selevmat=zeros(np(1),np(2));
	selevvec=zeros(np(1)*np(2));
	printf('concs: %f, %f\n',concs(1,1,1), concs(n1,n2,n3));
	selevmat=difselectlayer(concs, n1,n2,n3,p1,p2,p3,layer);
	printf('selected layer %f, %f\n',selevmat(1,1), selevmat(np(1),np(2)));
	//convert layer matrix to vector
	selevvec=difmat2vec(selevmat,np(1) ,np(2));
	
	//convert vector to string
	sevecstr=difvec2str(selevvec, np(1)*np(2));
	
	printf('difmatvec completed \n');
	//open transform
	writex3delevgrid(fd,sevecstr, np(1),np(2));
	printf('x3d elev grid written\n');
	//close transform
	
	

	
  closexmlelement(fd, 'Group');
  closex3d(fd);

endfunction

function diffuse_faceset_x3d(filename, n1,n2,n3,concs,maxconc,minconc,p1,p2,p3,layer)

  sDescription='Simple X3D example';
  sCreated='30 October 2000';
  sRevised='6 March 2003';
  sURL='http://www.shef.ac.uk/personal/m/mikeg/x3d/diffuse_out.x3d';
  sAuthor='Mike Griffiths';
  fd=writex3d(filename ,sDescription, sCreated, sRevised, sURL, sAuthor);
	
  openxml(fd, 'Group');

  viewp=zeros(3);
  viewrot=zeros(4);
  viewp(1)=6;
  viewp(2)=-1;
  viewp(3)=0;
  viewrot(1)=0;
  viewrot(2)=1;
  viewrot(3)=0;
  viewrot(4)=1.57
  
  writex3dviewpoint(fd, 'diffuse', viewrot, viewp);
	writex3dnavinfo(fd);
	
	//p1=1;
	//p2=2;
	//p3=3;
	
	np(1)=n1;
	np(2)=n2;
	np(3)=n3;
	
	mprintf('n1,n2,n3,p1,p2,p3,layer %d %d %d %d %d %d %d\n', n1,n2,n3,p1,p2,p3,layer);
	selevmat=zeros(np(1),np(2));
	//selevvec=zeros(np(1)*np(2));
	printf('concs: %f, %f\n',concs(1,1,1), concs(n1,n2,n3));
	selevmat=difselectlayer(concs, n1,n2,n3,p1,p2,p3,layer);
	mprintf('Selected layer \n');
	

	maxmin(1)=maxconc;
	maxmin(2)=minconc;
	//open transform
	writex3dfaceset(fd, selevmat, np(p1), np(p2),maxmin);
	printf('x3d elev grid written\n');
	//close transform
	
	

	
  closexmlelement(fd, 'Group');
  closex3d(fd);

endfunction




function writex3dfaceset(fd, selevmat,np1, np2,maxcolvec)
      
   rotvec(1)=0;
   rotvec(2)=0;
   rotvec(3)=1;
   rotvec(4)=%pi/10;
   
   //translation is just j,j,k
   translation=zeros(3);
   translation(1)=2;
   translation(2)=2;
   translation(3)=2;
   
   colvec(1)=0;
   colvec(2)=0.6;
   colvec(3)=1;
   printf('Writing x3d elev grid.\n');
   writex3dIndexedFaceSet(fd, selevmat,np1,np2, colvec, rotvec, translation, maxcolvec)

endfunction


function writex3dobject(fd, concs, n1,n2,n3,i,j,k,h,maxconc,minconc)



   //Determine concentration gradient
   nns=zeros(3,3,3);
   nns=getconcsub(concs,n1,n2,n3,i,j,k);
   grad=grad(nns,h);
   //determine rotation vector
   rotvec=rotvec(grad);
   
   if rotvec(1)==0
     if rotvec(2)==0
       if rotvec(3)==0
          rotvec(1)=1;
       end
     end
   end
   
   //translation is just j,j,k
   translation=zeros(3);
   translation(1)=4*i;
   translation(2)=4*j;
   translation(3)=4*k;
   
   crange=zeros(2)
   cwid=(maxconc-minconc)/3;
   if cwid<=0 
     cwid=1;
   end
   crange(1)=minconc+cwid;
   crange(2)=minconc+2*cwid;
   //diffuse colour vector
   colvec=zeros(3)
   
   if concs(i,j,k)>crange(2)
       colvec(1)=(concs(i,j,k)-crange(2))/cwid;
       colvec(2)=0;
       colvec(3)=0;
   elseif concs(i,j,k)>crange(1)
       colvec(1)=0;
       colvec(2)=(concs(i,j,k)-crange(1))/cwid;
       colvec(3)=0;          
   else
       colvec(1)=0;
       colvec(2)=0;
       colvec(3)=concs(i,j,k)/cwid;           
   end
   

   
   shapeprops=zeros(2);
   writex3dColouredShape(fd, 'cone', shapeprops, colvec, rotvec, translation)
   

endfunction





