
curFig             = scf(100001);
clf(curFig,"reset");
demo_viewCode("membrane.sce");

drawlater();

xselect(); //raise the graphic window


// set a new colormap
//-------------------
cmap= curFig.color_map; //preserve old setting
curFig.color_map = jetcolormap(64);

//The initial surface definition 
//----------------------

//Creates and set graphical entities which represent the surface
//--------------------------------------------------------------
plot3d1(x,y,u(:,:,1),35,45,' ');
s=gce(); //the handle on the surface
s.color_flag=1 ; //assign facet color according to Z value
title("evolution of a 3d surface","fontsize",3)



drawnow();

for i=2:nt
  realtime(i); //wait till date 0.1*i seconds
  //s.data.z = (sin((I(i)/10)*x)'*cos((I(i)/10)*y))';
  s.data.z = u(:,:,i);
end

