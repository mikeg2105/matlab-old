%
% Scilab ( http:%www.scilab.org/ ) - This file is part of Scilab
% Copyright (C) INRIA
%
% This file is distributed under the same license as the Scilab package.
%

% =============================================================================
% Demonstrate animation based on the evolution of a 3D surface
% ============================================================================
%http:%www.astrophysik.uni-kiel.de/~hhaertel/PUB/membrane.pdf
curFig             = scf(100001);
clf(curFig,"reset");
demo_viewCode("membrane.sce");

drawlater();

xselect(); %raise the graphic window


% set a new colormap
%-------------------
cmap= curFig.color_map; %preserve old setting
curFig.color_map = jetcolormap(64);

%The initial surface definition 
%----------------------
x=linspace(-pi,pi,50);
y=x;
Z=sin(x)'*cos(y);

%Creates and set graphical entities which represent the surface
%--------------------------------------------------------------
plot3d1(x,y,Z,35,45,' ');
s=gce(); %the handle on the surface
s.color_flag=1 ; %assign facet color according to Z value
title('evolution of a 3d surface','fontsize',3)

I=20:-0.1:1;
realtimeinit(0.1);;%set time step (0.1 seconds)  and date reference

phasex=6;
shiftx=pi/2;
phasey=6;
shifty=0;

drawnow();

for i=1:max(size(I))
  realtime(i); %wait till date 0.1*i seconds
  %s.data.z = (sin((I(i)/10)*x)'*cos((I(i)/10)*y))';
  
  s.data.z = sin(6*pi*i/max(size(I)))*(sin((((phasex)*x+(shiftx))))'*cos(((phasey)*y)+shifty))';
end
