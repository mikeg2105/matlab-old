
exec('waveguide.sce');
curFig             = scf(100001);
clf(curFig,"reset");





// set a new colormap
//-------------------
cmap= curFig.color_map; //preserve old setting
curFig.color_map = jetcolormap(64);

x=0.01:0.2:10;
y=0.01:0.2:10;

n1=size(x);
n2=size(y);

subplot(2,2,1);
z=zeros(n1(1,2),n2(1,2));
for i=1:n1(1,2)
  for j=1:n2(1,2)
  
     z(i,j)=ez(0,0,6,x(i),y(j),1);


  end
end
plot3d1(x,y,z);
s=gce(); //the handle on the surface
s.color_flag=1 ; //assign facet color according to Z value
subplot(2,2,2);
z=zeros(n1(1,2),n2(1,2));
for i=1:n1(1,2)
  for j=1:n2(1,2)
  
     z(i,j)=ez(1,0,6,x(i),y(j),1);


  end
end
plot3d1(x,y,z);
s=gce(); //the handle on the surface
s.color_flag=1 ; //assign facet color according to Z value
subplot(2,2,3);
z=zeros(n1(1,2),n2(1,2));
for i=1:n1(1,2)
  for j=1:n2(1,2)
  
     z(i,j)=ez(2,1,6,x(i),y(j),1);


  end
end
plot3d1(x,y,z);

subplot(2,2,4);
z=zeros(n1(1,2),n2(1,2));
for i=1:n1(1,2)
  for j=1:n2(1,2)
  
     z(i,j)=ez(3,1,6,x(i),y(j),1);


  end
end
plot3d1(x,y,z);


