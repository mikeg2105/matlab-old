function [out,out1,out2]=basic_elt_test(varargin);

// ELEMENT TESTS
//
//// eig, load, mat for all elements => comparisons with SDT5.1
// basic_elt_test('compare')
//
//// test of basic commands (integinfo, call, etc.) for all elements
// basic_elt_test('integinfo')
//
//// testmat for all elements, 
//// the optional output argument is a cell array containing basic matrices
// out = basic_elt_test('mat')
//
//// testeig for all elements, 
//// the optional output argument is a cell array containing frequencies
// out = basic_elt_test('eig')
//
//// testload for all elements, 
//// the optional output argument is a cell array containing RHS norms
// out = basic_elt_test('load')
//
//// test mat,eig,surf,... for element
////    st=q4p,t3p,...
////   st1=mat,eig,sur,vol
// basic_elt_test(st,st1) or basic_elt_test (all the tests)
//
//   example
//   basic_elt_test('penta15','mat') // check anisotropic material for 2D

//	Etienne Balmes, J.M. Leclere
//       Copyright (c) 2001-2003 by INRIA and SDTools,All Rights Reserved.
//       Use under OpenFEM trademark.html license and LGPL.txt library license
//       $Revision: 1.7 $  $Date: 2004/07/28 07:19:10 $

global withoutplot

[nargout,nargin] = argn(0);
carg=1;
out = []; out1 = []; out2 = [];

//-----------------------------------------------------------------------
// To do the matrix, rhs, stress test for a specified element
if carg<=nargin-1

 st=varargin(carg); st1=varargin(carg+1);carg=carg+2;

else

 // list of elements to check
//st=makecell([1 1],'tria6');
 st=makecell([1 20],'q4p','q8p','t3p','t6p',...
     'hexa8','hexa20','penta6','penta15',...
     'tetra4','tetra10','tria3','tria6',...
     'quad4','quadb','quad9','bar1','flui4',...
     'flui6','flui8','beam1');
 // missing: mitc4, , beam3, , celas , q5p, q9a ,'dktp',
 if carg<=nargin; st1=varargin(carg);carg=carg+1;
 else; st1='';
 end
end


//-----------------------------------------------------------------------
// testmat for all elements
if isempty(st1)|comstr(st1,'mat')

 st1='testmat';

 ierr2 = execstr('host(''rm basic_elt_test.txt'');','errcatch');
 filename = 'basic_elt_test.txt';
 [fd,err] = mopen(filename,'a');


 out=cell();
 for j1=1:prod(size(st))
   st3=['k='+st(j1).entries+'('''+st1+''');'];
    ierr = zeros(1,3);
    if any(strcmp(st(j1).entries,makecell([1 6],'q4p','q5p','q8p','t3p','t6p','q9a')))

      st3=['k='+st(j1).entries+'('''+st1+'_0'+''');'];
      ierr(1) = execstr(st3,'errcatch');
      if ierr(1)==0; out(size(out,1)+1,1:2)=makecell([1 2],st3,k); end
      st3=['k='+st(j1).entries+'('''+st1+'_1'+''');'];
      ierr(2) = execstr(st3,'errcatch');
      if ierr(2)==0; out(size(out,1)+1,1:2)=makecell([1 2],st3,k); end
      st3=['k='+st(j1).entries+'('''+st1+'_2'+''');'];
      ierr(3) = execstr(st3,'errcatch');
      if ierr(3)==0; out(size(out,1)+1,1:2)=makecell([1 2],st3,k); end
    else
      ierr(1) = execstr(st3,'errcatch');
      if ierr(1)==0; out(size(out,1)+1,1:2)=makecell([1 2],st3,k); ierr = zeros(1,3); end
    end    
    if any(ierr)
	    disp(lasterror());
	    fprintf(fd,'------------------------------- error in %s %s\n',st(j1).entries,st1)
	    out(size(out,1)+1,1:3)=makecell([1 3],st3,'error',lasterror());
    elseif iscell(k)
	 if isempty(find(isfinite(k(1).entries))) | isempty(find(k(1).entries)) 
        	error('Infinite or zeros matrix'); 
     	end
    end

 end //j1

 mclose(fd);
// diary off
 return;

//-----------------------------------------------------------------------
// testeig for all elements
elseif comstr(st1,'eig')
 withoutplot = 1;
 st1='testeigstress';

 ierr2 = execstr('host(''rm basic_elt_test.txt'');','errcatch');
 filename = 'basic_elt_test.txt';
 [fd,err] = mopen(filename,'a');

 out=cell();
 for j1=1:prod(size(st))
   st3=['[model,def]='+st(j1).entries+'('''+st1+''');'];
   ierr = zeros(1,3);
    if any(strcmp(st(j1).entries,makecell([1 6],'q4p','q5p','q8p','t3p','t6p','q9a')))
      st3=['[model,def]='+st(j1).entries+'('''+st1+'_0'+''');'];
      ierr(1) = execstr(st3,'errcatch');
      if ierr(1)==0; out(size(out,1)+1,1:3)=makecell([1 3],st3,def,def.data(1:5)); end
      st3=['[model,def]='+st(j1).entries+'('''+st1+'_1'+''');'];
      ierr(2) = execstr(st3,'errcatch');
      if ierr(2)==0; out(size(out,1)+1,1:3)=makecell([1 3],st3,def,def.data(1:5)); end
      st3=['[model,def]='+st(j1).entries+'('''+st1+'_2'+''');'];
      ierr(3) = execstr(st3,'errcatch');
      if ierr(3)==0; out(size(out,1)+1,1:3)=makecell([1 3],st3,def,def.data(1:5)); end
    else
      ierr(1) = execstr(st3,'errcatch');
      if ierr(1)==0 & isfield(def,'def')
	      out(size(out,1)+1,1:3)=makecell([1 3],st3,def,def.data(1:5));
      else
		out(size(out,1)+1,1:3)=makecell([1 3],st3,'error',lasterror()); ierr = zeros(1,3);
      end
    end   

   if any(ierr)
	disp(lasterror());
	fprintf('------------------------------- error in %s %s\n',st(j1).entries,st3);
	out(size(out,1)+1,1:3)=makecell([1 3],st3,'error',lasterror());
   end
 end //j1

 mclose(fd);
 withoutplot = 0;
// diary off
 return;

//-----------------------------------------------------------------------
// testload for all elements
elseif comstr(st1,'load')

 withoutplot = 1;
 st1='testload';

 ierr2 = execstr('host(''rm basic_elt_test.txt'');','errcatch');
 filename = 'basic_elt_test.txt';
 [fd,err] = mopen(filename,'a');

 out=cell();
 for j1=1:prod(size(st))
   st3=['[model,def]='+st(j1).entries+'('''+st1+''');'];
   ierr = zeros(1,3);
    if any(strcmp(st(j1).entries,makecell([1 6],'q4p','q5p','q8p','t3p','t6p','q9a')))
      st3=['[model,def]='+st(j1).entries+'('''+st1+'_0'+''');'];
      ierr(1) = execstr(st3,'errcatch');
      if ierr(1)==0; out(size(out,1)+1,1:3)=makecell([1 3],st3,def,norm(full(def.def),2)); end
      st3=['[model,def]='+st(j1).entries+'('''+st1+'_1'+''');'];
      ierr(2) = execstr(st3,'errcatch');
      if ierr(2)==0; out(size(out,1)+1,1:3)=makecell([1 3],st3,def,norm(full(def.def),2)); end
      st3=['[model,def]='+st(j1).entries+'('''+st1+'_2'+''');'];
      ierr(3) = execstr(st3,'errcatch');
      if ierr(3)==0; out(size(out,1)+1,1:3)=makecell([1 3],st3,def,norm(full(def.def),2)); end
    else
      ierr2 = execstr(st3,'errcatch');
      if ierr(1)==0 & isfield(def,'def')
	      out(size(out,1)+1,1:3)=makecell([1 3],st3,def,norm(full(def.def),2));
      elseif ierr(1)~=0
	      out(size(out,1)+1,1:3)=makecell([1 3],st3,'error',lasterror()); ierr = zeros(1,3);
      else
	      out(size(out,1)+1,1:3)=makecell([1 3],st3,'error','attempt to reference field of non-structure array ''def''.'); ierr = zeros(1,3);
      end
    end   

   if any(ierr)
   	disp(lasterror());
   	fprintf(fd,'------------------------------- error in %s %s\n',st(j1).entries,st1)
   	out(size(out,1)+1,1:3)=makecell([1 3],st3,'error',lasterror());
   end
 end //j1

 mclose(fd);
 withoutplot = 0;
 //diary off
 return;

//-----------------------------------------------------------------------
// 
elseif comstr(st1,'compare')
 withoutplot = 1;
 st0=st;

 filename = 'basic_elt_test.txt';
 [fd,err] = mopen(filename,'a');

 [Eig_ref,Load_ref,Mat_ref] = ref_elt_test();
 [st0,i1]=%ce_intersect_ce(st,st0);
 
 // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - Matrices
 Mat  = basic_elt_test('mat'); result_Mat=Mat;
 for j1=1:size(Mat,1)
  i1=find(strcmp(Mat_ref,Mat(j1,1).entries));
  if ~isempty(i1) 
   if  ~isstr(Mat_ref(i1,2).entries) & ~isstr(Mat(j1,2).entries) & iscell(Mat(j1,2).entries)
    result_Mat(j1,2).entries=[(Mat_ref(i1,2).entries(1)-max(svd(Mat(j1,2).entries(1).entries)))/Mat_ref(i1,2).entries(1)
                  (Mat_ref(i1,2).entries(2)-max(svd(Mat(j1,2).entries(2).entries)))/Mat_ref(i1,2).entries(1)  ];
   else
    result_Mat(j1,2).entries='error';
   end
  else
    result_Mat(j1,2).entries='not compared';
  end
 end // j1
 // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - EIG
 Eig  = basic_elt_test('eig');result_Eig=Eig;
 for j1=1:size(Eig,1)
  i1=find(strcmp(Eig_ref,Eig(j1,1).entries));
  if ~isempty(i1) 
   if  ~isstr(Eig_ref(j1,2).entries) & ~isstr(Eig(j1,2).entries) 
    result_Eig(j1,2).entries=Eig_ref(i1,2).entries(:)'-Eig(i1,3).entries(:)';
   else
    result_Eig(j1,2).entries='error';
   end
  else
    result_Eig(j1,2).entries='not compared';
  end
 end // j1
 // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - LOAD
 Load = basic_elt_test('load');result_Load=Load;
 for j1=1:size(Load,1)
  i1=find(strcmp(Load_ref,Load(j1,1).entries));
  if ~isempty(i1) 
   if  ~isstr(Load_ref(j1,2).entries) & ~isstr(Load(j1,2).entries)
    result_Load(j1,2).entries=Load_ref(i1,2).entries-Load(i1,3).entries;
   else
    result_Load(j1,2).entries='error';
   end
  else
    result_Load(j1,2).entries='not compared';
  end
 end // j1

 out=makecell([1 3],result_Mat,result_Eig,result_Load);

 // - - - - - - - - - - - - - - - - - - - - - - - - - - -  Comparisons output
 for j1=1:size(out(1).entries,1) // Mat
  if ~isstr(out(1).entries(j1,2).entries) & ~isempty(find(out(1).entries(j1,2).entries>sdtdef('epsl')))
    fprintf(fd,'%s : ',out(1).entries(j1,1).entries);
    fprintf(fd,'%f ',out(1).entries(j1,2).entries);
    fprintf(fd,'\n');
  elseif ~isstr(out(1).entries(j1,2).entries) & isempty(find(out(1).entries(j1,2).entries>sdtdef('epsl')))
    fprintf(fd,'%s : comparison OK\n',out(1).entries(j1,1).entries);
  else fprintf(fd,'%s : error\n',out(1).entries(j1,1).entries);
  end
 end

 for j1=1:size(out(2).entries,1) // Eig
  if ~isstr(out(2).entries(j1,2).entries) & ~isempty(find(out(2).entries(j1,2).entries>sdtdef('epsl')))
    fprintf(fd,'%s : ',out(2).entries(j1,1).entries);
    fprintf(fd,'%f ',out(2).entries(j1,2).entries);
    fprintf(fd,'\n');
  elseif ~isstr(out(2).entries(j1,2).entries) & isempty(find(out(2).entries(j1,2).entries>sdtdef('epsl')))
    fprintf(fd,'%s : comparison OK\n',out(2).entries(j1,1).entries);
  else fprintf(fd,'%s : error\n',out(2).entries(j1,1).entries);
  end
 end

 for j1=1:size(out(3).entries,1) // Load
  if ~isstr(out(3).entries(j1,2).entries) & ~isempty(find(out(3).entries(j1,2).entries>sdtdef('epsl')))
    fprintf(fd,'%s : ',out(3).entries(j1,1).entries);
    fprintf(fd,'%f ',out(3).entries(j1,2).entries);
    fprintf(fd,'\n');
  elseif ~isstr(out(3).entries(j1,2).entries) & isempty(find(out(3).entries(j1,2).entries>sdtdef('epsl')))
    fprintf(fd,'%s : comparison OK\n',out(3).entries(j1,1).entries);
  else fprintf(fd,'%s : error\n',out(3).entries(j1,1).entries);
  end
 end

 withoutplot = 0;
 return;

//-----------------------------------------------------------------------
// test each basic command of elements
elseif comstr(st1,'integinfo')

 st1=makecell([1 8],'call','rhscall','node','patch',...
      'dof','line','face','parent');

 ierr2 = execstr('host(''rm basic_elt_test.txt'');','errcatch');
 filename = 'basic_elt_test.txt';
 [fd,err] = mopen(filename,'a');

 for j1=1:length(st)
  for j2=1:length(st1)
    st3=['r1='+st(j1).entries+'('''+st1(j2).entries+''');'];
    ierr = 0;
     ierr = execstr(st3,'errcatch');
     if ierr==0 & isempty(r1); error('Empty return'); end
    if ierr~=0
    	disp(lasterror());
    	fprintf('------------------------------- error in %s\n',st3)
    end
  end //j2
 end //j1

 // test 'integinfo' (based on femesh test elt call)
 st1='integinfo';

 for j1=1:length(st)
  st3=['i1='+st(j1).entries+'('''+st1+''',[100;110],model.pl,model.il);'];
  st4=['model=femesh(''test'+st(j1).entries+''');' ];
  ierr = zeros(1,2);
   ierr(1) = execstr(st4,'errcatch'); ierr(2) = execstr(st3,'errcatch');
   if ~any(ierr) & isempty(find(i1)); error('Empty constit'); end
  if any(ierr)
    	disp(lasterror());
    	fprintf('------------------------------- error in %s\n',st3)
  end
 end //j1

 mclose(fd);
 //diary off
 return;

//-----------------------------------------------------------------------
// no input argument => test all
elseif nargin==0 

 st1=makecell([1 4],'mat','eig','loadStressMises','load');

 ierr2 = execstr('host(''rm basic_elt_test.txt'');','errcatch');
 filename = 'basic_elt_test.txt';
 [fd,err] = mopen(filename,'a');

 for j1=1:length(st)
  for j2=1:length(st1)
   basic_elt_test(st(j1).entries,st1(j2).entries);
  end //j2
 end //j1
 mclose(fd);
// diary off
 return;

else error('Not a valid test')
end

//-----------------------------------------------------------------------
// Actually do the test for one specified element
filename = 'basic_elt_test.txt';
[fd,err] = mopen(filename,'a');

st2=sprintf('%s test%s;',st,st1);

ierr = execstr(st2,'errcatch');
if ierr~=0
    disp(lasterror());
    fprintf(fd,' ------------------ error in %s test\n%s\n', st2)
end

if any(strcmp(st,makecell([1 6],'q4p','q5p','q8p','t3p','t6p','q9a')))
 st2=sprintf('%s test%s_0;',st,st1);
 ierr = execstr(st2,'errcatch');
 if ierr~=0
    disp(lasterror());
    fprintf(fd,' ------------------ error in %s test\n%s\n',st2)
 end
 st2=sprintf('%s test%s_1;',st,st1);
 ierr = execstr(st2,'errcatch');
 if ierr~=0
    disp(lasterror());
    fprintf(fd,' ------------------ error in %s test\n%s\n',st2)
 end
 st2=sprintf('%s test%s_2;',st,st1);
 ierr = execstr(st2,'errcatch');
 if ierr~=0
    disp(lasterror());
    fprintf(fd,' ------------------ error in %s test\n%s\n',st2)
 end

 // test anisotropic material
 // plane stress
 E=2.1e11;nu=.285;C=E/(1.-nu*nu);
 e=[C C*nu C 0. 0. C*(1-nu)/2];
 pl=[100 fe_mat('m_elastic','SI',4) e 7800 0 0 0 0 .1];
 st2=sprintf('k=%s (''test%s_0'');',st,st1)
 execstr(st2);
 st2=sprintf('k1=%s (''test%s_0'',pl);',st,st1)
 execstr(st2);
 if iscell(k1)
   if norm(k(1).entries-k1(1).entries); error(['anisotropic element '+st2]); end
 end

 // plane strain
 unmnu=1.-nu;
 C=E*unmnu/(1+nu)/(1-2*nu);
 e=[C nu*C/unmnu C 0. 0. C*(1-2*nu)/(2*unmnu)];
 pl=[100 fe_mat('m_elastic','SI',4) e 7800 0 0 0 0 .1];
 st2=sprintf('k=%s (''test%s_1'');',st,st1);
 execstr(st2,'errcatch');
 st2=sprintf('k1=%s (''test%s_1'',pl);',st,st1);
 execstr(st2);
 if iscell(k1)
   if norm(k(1).entries-k1(1).entries); error(['anisotropic element '+st2]); end
 end



end
mclose(fd);
return;

//-----------------------------------------------------------------------
if 1==2
 // anisotropic
  model=femesh('testq4p');
  model.il(3)=0;

  E=2.1e11;nu=.285;C=E/(1.-nu*nu);
  e=[C C*nu C 0. 0. C*(1-nu)/2];
  model.pl=[100 fe_mat('m_elastic','SI',4) e 7800 0 0 0 0 .1];

  [constit,iopt,elmap]=q4p('integinfo',[100;110],model.pl,model.il);
  [k,m]=q4p(model.Node,model.Elt(2,:),[36 36 0 0 0 0 0 0 0],int32(iopt),constit,elmap);


     unmnu=1.-nu;
     C=E*unmnu/(1+nu)/(1-2*nu);
     e=[C nu*C/unmnu C 0. 0. C*(1-2*nu)/(2*unmnu)];
pl=[100 fe_mat('m_elastic','SI',4) e 7800 0 0 0 0 .1];
end





//--------------------------------------------------------- RHS
if 1==2
// st={'q4p','q5p','q8p','t3p','t6p',...
//      'hexa8','hexa20','penta6',...
//     'tetra4','tetra10'};

// st={'quad4','tria3','quadb'};

//st={'bar1','beam1'};
//st={'flui4','flui6','flui8'};

 st=makecell([1 5],'q4p','q5p','q8p','t3p','t6p');
 
errors=cell(); 

for j2=1:4

 for j1=1:length(st)

    st1=['[model,def1]=femesh(''teststruct'+st(j1).entries+'load'');' ];
    st2=['[model,def2]=femesh(''teststruct'+st(j1).entries+'load'');' ];
    st3=['[model,def3]=femesh(''teststruct'+st(j1).entries+'load'');' ];

    execstr(st1);execstr(st2);execstr(st3);

    if ~isequal(def1.def,def2.def) | ~isequal(def1.def,def3.def)
     errors(size(errors,1)+1,1).entries=st1;
     if ~isequal(def1.def(:,1:2),def2.def(:,1:2)) |...
                            ~isequal(def1.def(:,1:2),def3.def(:,1:2))
       errors(size(errors,1),2).entries='gravity and/or surf';
     else
       errors(size(errors,1),2)='pressure only';
     end
    end 
 end //j1
end //j2



end

//------------------------------------------ compare basic matrices
if 1==2
out=basic_elt_test('mat')
loadmatfile 'basic_elt_test_matrices'
result=out;

for j1=1:size(out,1)
  i1=find(strcmp(k,out(j1,1).entries));

  if ~isempty(i1) 
   if  ~isstr(out(j1,2).entries);
    result(j1,2).entries=norm(out(j1,2).entries(1).entries-k(i1,2).entries(1).entries);
    result(j1,3).entries=norm(out(j1,2).entries(2).entries-k(i1,2).entries(2).entries);
   else
    result(j1,2).entries='error';
    result(j1,3).entries='error';
   end
  else
    result(j1,2).entries='not compared';
  end
end

end
//--------------------------------------------------------- RHS
if 1==2
out=basic_elt_test('load')
loadmatfile 'basic_elt_test_load'
result=out;

for j1=1:size(out,1)
  i1=find(strcmp(k,out(j1,1).entries));

  if ~isempty(i1) 
   if  ~isstr(out(j1,2).entries);
    result(j1,2).entries=norm(out(j1,3).entries-k(i1,3).entries);
   else
    result(j1,2).entries='error';
   end
  else
    result(j1,2).entries='not compared';
  end
end

end
//--------------------------------------------------------- EIG
if 1==2
out=basic_elt_test('eig')
loadmatfile basic_elt_test_load
result=out;

for j1=1:size(out,1)
  i1=find(strcmp(k,out(j1,1).entries));

  if ~isempty(i1) 
   if  ~isstr(out(j1,2).entries);
    result(j1,2).entries=norm(out(j1,3).entries-k(i1,3).entries);
   else
    result(j1,2).entries='error';
   end
  else
    result(j1,2).entries='not compared';
  end
end

end
//---------------------------------------------------------
