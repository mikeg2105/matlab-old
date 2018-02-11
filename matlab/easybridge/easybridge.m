%Job to calculate stresses on a bridge
%http://mvhs1.mbhs.edu/mvhsproj/bridge_model/bridge2.html

%For further information about this
%see readme.txt
%see diagram bridgediagram.jpg


%nlayers
%nsegments
%angle1
%angle2

nlayers=2;
npoints=4;
angle1=45;
angle2=45;

loads=readloads('loadfile.dat');
nloads=size(loads,1);

%Stresses on beams are calculated
% and output to file results%

 
 stress=bridgestress('results.dat', nlayers, npoints, angle1, angle2, loads, nloads);
 
