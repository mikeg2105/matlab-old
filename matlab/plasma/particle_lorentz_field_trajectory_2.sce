//Script to model influence of uniform e and b field
//on charged particle motion

clear();
exec('lorentz.sce');

m=1.6*(10^(-27));
q=1.6*(10^(-19));
dt=5.0*(10^(-9));
it=1:1:1000;

r=zeros(3,1);
v=zeros(3,1);


v(2,1)=1.0*(10^6);
b=zeros(3,1);
e=zeros(3,1);

//bfield in z direction
b(3,1)=0.1;

//efield in y direction
//e(2,1)=0.2;
//e(3,1)=10*(10^4);
ns=200;




  labels=["v(1)";"v(2)";"v(3)    "];
  [ok,v(1,1),v(2,1),v(3,1)]=getvalue("define velocity values",labels,...
       list("vec",1,"vec",1,"vec",1),["0.0";"1.0*(10^6)";"0.0"]);
  iv=v;

  labels=["b(1)";"b(2)";"b(3)    "];
  [ok,b(1,1),b(2,1),b(3,1)]=getvalue("define b field values",labels,...
       list("vec",1,"vec",1,"vec",1),["0.0";"0.0";"0.1"]);

  labels=["e(1)";"e(2)";"e(3)    "];
  [ok,e(1,1),e(2,1),e(3,1)]=getvalue("define e field values",labels,...
       list("vec",1,"vec",1,"vec",1),["0.0";"0.0";"0.0"]);


  ar=zeros(ns,3);  
  //  xsetech([0,0,0.5,0.5]);
  //elseif plotid==2 then
  //  xsetech([0.5,0.5,0.5,0.5]);
  //elseif plotid==3 then
  //  xsetech([0.0,0.5,0.5,0.5]);
    

  for it=2:1:ns
   
    dv=lorentzf(q,m,v,e,b);
    newv=v+dv*dt;
    newr=r+v*dt;
    v=newv;
    r=newr;  
    ar(it,:)=r(1:3,1)';

end;


// title by default
   text=x_dialog('Plot Title?','');
  pictitle=sprintf("%s velocity %f %f %f  bfield %f %f %f efield %f %f %f ",text,iv(1,1),iv(2,1),iv(3,1),b(1,1),b(2,1),b(3,1),e(1,1),e(2,1),e(3,1));
   //pictitle=sprintf("%s ",text);
  clf();
  da=gda(); // get the handle on axes model to view and edit the fields
   
  //da.title.text=pictitle;
  da.title.text=pictitle;
  param3d(ar(:,1),ar(:,2),ar(:,3),35,45,"X@Y@Z");
 
  
  
  
  l1=list('Save plot?',2,['yes','no']);
  saverep=x_choices('Save plot?',list(l1))
  
  if saverep==1 then
    graphicsfile=xgetfile("*.scg", title="Choose a graphics file name");
    xsave(graphicsfile);
  end;








