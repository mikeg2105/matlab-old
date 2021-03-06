//Script to model influence of uniform e and b field
//on charged particle motion


exec('lorentz.sce');

m=1.6*(10^(-27));
q=1.6*(10^(-19));
dt=5.0*(10^(-9));
it=1:1:1000;
//plotid=evstr(x_dialog('plotid ?','1'));;
//text=x_dialog('Title?','current');
r=zeros(3,1);
v=zeros(3,1);

//v(1,1)=1.0*(10^6);
v(2,1)=1.0*(10^6);



b=zeros(3,1);
e=zeros(3,1);

//bfield in z direction
b(3,1)=0.1;

//efield in y direction
e(2,1)=0.2*100000;
//e(2,1)=10*(10^4);
ns=200;



v(2,1)=evstr(x_dialog('value of velocity ?','1.0*(10^6)'));
//x_dialog(['Method';'enter velocity'],'1')
//m=evstr(x_dialog('enter a  3x1 matrix ',['[0 ';'0 ';'0 ]']))

labels=["b(1)";"b(2)";"b(3)    "];
[ok,b(1,1),b(2,1),b(3,1)]=getvalue("define b field values",labels,...
     list("vec",1,"vec",1,"vec",1),["0.0";"0.0";"0.1"]);


//xset('pixmap',1);

//xselect(); //raise graphic window
//np=10;
//t=0:0.1:np*%pi;
//realtimeinit(0.03);
//if driver()=='Pos' then
//  st=1.5;
//else
//  st=0.5;
//end
ar=zeros(ns,3);

   
//plot(r(1),r(2))
for it=2:1:ns
 
  dv=lorentzf(q,m,v,e,b);
  newv=v+dv*dt;
  newr=r+v*dt;
  
  
  //ar(:,1)=r(1:3,1);
  //ar(:,2)=newr(1:3,1);
  //a.user_data=ar;
  v=newv;
  r=newr;

  //realtime(it)
  //xset('wwpc');
  
  //plot2d(r(1),r(2));
  
  ar(it,:)=r(1:3,1)';
  //xsegs(ar(1:2,1),ar(1:2,2));
  //param3d(ar(1,:),ar(2,:),ar(3,:),35,45,'X@Y@Z',[2,4]);
  //xset('wshow');
  
end

//da=gda(); // get the handle on axes model to view and edit the fields
   // title by default
//pictitle=sprintf("pic %s %d",text,plotid);
//da.title.text=pictitle;

//if plotid==1 then
//  xsetech([0,0,0.5,0.5]);
//elseif plotid==2 then
//  xsetech([0.5,0.5,0.5,0.5]);
//elseif plotid==3 then
//  xsetech([0.0,0.5,0.5,0.5]);
//elseif plotid==4 then
//  xsetech([0.5,0.0,0.5,0.5]);
//end

param3d(ar(:,1),ar(:,2),ar(:,3));
da=gda(); // get the handle on axes model to view and edit the fields
   // title by default
pictitle=sprintf("pic %s ",text);
da.title.text=pictitle;
