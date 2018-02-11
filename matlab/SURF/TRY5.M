% This command can be used for 3D surface plotting
% of data kept in a file.
% data must be presented in three   columns 
% in the order of x y and z respectively 
%
disp ' Easy 3D-surface plotting. Version 1.00'
disp ' Written by:  D.Savas@sheffield.ac.uk'
disp ' Date: October.1997'

filnam ='';
while isempty(filnam) 
      [filnam,path]=uigetfile('*.*','Get file');
       ee = exist(filnam);
       if ee ~= 2
           yes=input( 'File not specified. Do you wish to quit [y/n] [n]?','s' );
           if isempty(yes)
                yes='n'
           end 
           if yes(1,1) == 'y' | yes(1,1) == 'Y' 
               return
           end
           filnam=''
       end  

end

disp([ ' --- wait reading the data file:' filnam '---'] );
eval(['load ' filnam])
%  data=data'
file = stripname(filnam);
data=eval(file);
x=data(:,1);
y=data(:,2);
z=data(:,3);
[i,m]=size(x);


%  return
disp( ' --- wait analysing data ---');

xmax=max(x);
xmin=min(x);
istep=10;
dx=(xmax-xmin)./istep;
ti = xmin:dx:xmax;

ymax=max(y);
ymin=min(y);
jstep=10;
dy=(ymax-ymin)./jstep;
tj = ymin:dy:ymax;

[xi,yi]=meshgrid(ti,tj);
[zi] = griddata(x,y,z,xi,yi);

% graphical commands 
disp( ' --- wait plotting  data ---');
% get system default properties.
dfltsize = get(0,'DefaultFigurePosition');
cntlsize = dfltsize;
cntlsize(1,1) = 10;
cntlsize(1,2) = 10;
cntlsize(1,3) = dfltsize(1,3);
cntlsize(1,4) = dfltsize(1,4)*0.4;
% control panell window.

% hcntl = figure('name','Control Panel' ,'position',[400 107 500 300]);

hcntl = figure('name','Control Panel' ,'position',cntlsize );
axis off;

  dsbackcl = [ 0 0 0 ];
  dsforgcl = [ 0.7 0.7 0.7 ];

% azimuth control
  dsh2 = uicontrol('Style','slider','position',[10  10 80 20]); 
  set(dsh2,'max',180,'min',-180,'value',-37.5 );
  set(dsh2,'callback' , 'dsazim');

% dsbackcl = get( dsh2 ,'Backgroundcolor');
% dsforgcl = get( dsh2 ,'Foregroundcolor');
% dsforgcl = dsbackcl*0.1+dsforgcl*0.4 ;

  dsbackcl = get(hcntl,'color');
  dsforgcl = get(gca,'Xcolor');
%         text('position',[-0.1 0.2] ,'String', 'azimuth');
  uicontrol('Style','text','String','azimuth',...
       'Position',[10 30 80 20], 'BackgroundColor',dsbackcl,...
       'ForegroundColor',dsforgcl );
% elevation control.
  dsh3 = uicontrol('Style','slider','position',[110 10 80 20]); 
  set(dsh3,'max',90,'min',-90,'value',30 );
  set(dsh3,'callback' , 'dselev');
%  text('position',[0.15 0.2] ,'String', 'elevation');
  uicontrol('Style','text','String','elevation',...
       'Position',[110 30 80 20], 'BackgroundColor',dsbackcl,...
       'ForegroundColor',dsforgcl );

% colourmap as a popup button
  dsh4 = uicontrol('Style','popup','String','rbow|hsv| hot|cool|gray',...
       'Position',[10 50 80 20] );
  set(dsh4,'callback','dscolmap');
%  text('position',[-0.1 0.5] ,'String', 'palette');
  uicontrol('Style','text','String','palette',...
       'Position',[10 70 80 20], 'BackgroundColor',dsbackcl,...
       'ForegroundColor',dsforgcl );


% shading as a popup button
  dsh5 = uicontrol('Style','popup','String','interp|flat| faceted',...
       'Position',[110 50 80 20] );
  set(dsh5,'callback','dsshade');
% text('position',[0.15 0.5] ,'String', 'shading');
  uicontrol('Style','text','String','shading',...
       'Position',[110 70 80 20], 'BackgroundColor',dsbackcl,...
       'ForegroundColor',dsforgcl );


% Box around the plot as an on/off check box 
  dsh51 = uicontrol('Style','checkbox','String','ON/OFF',...
       'Position',[10 90 80 20],'value',0 );
  set(dsh51,'callback','dsbox');
  uicontrol('Style','text','String','enclose box',...
       'Position',[10 110 80 20], 'BackgroundColor',dsbackcl,...
       'ForegroundColor',dsforgcl );


% direction of ticks on the axis  as an in/out check box 
  dsh52 = uicontrol('Style','checkbox','String','IN/OUT',...
       'Position',[110 90 80 20],'value',0 );
  set(dsh52,'callback','dstick');
        uicontrol('Style','text','String','tick-marks',...
       'Position',[110 110 80 20], 'BackgroundColor',dsbackcl,...
       'ForegroundColor',dsforgcl );


% axis on or off..

  uicontrol('Style','text','String','LABELS & AXIS',...
      'Position',[240 120 160 20], 'BackgroundColor',dsbackcl,...
      'ForegroundColor',dsforgcl );
  dsh60 = uicontrol('Style','checkbox' ,'value', 1,...
         'Position' , [400 120 80 20],'string','ON/OFF' );
  set(dsh60,'callback','dstonof') ;
 
% graph title as an editable text.
  
% text('position',[0.40 0.65] ,'String', 'Graph');
  dsh61 = uicontrol('Style','edit','String','Surface Plot',...
       'Position',[280 90 180 20] );
  set(dsh61,'callback','dstitle');
  uicontrol('Style','text','String', 'Title',...
      'Position',[200 90 80 20], 'BackgroundColor',dsbackcl,...
      'ForegroundColor',dsforgcl );
 
  uicontrol('Style','text','String',...
      '   labels log/lin-scale grid ',...
      'Position',[200 70 200 20], 'BackgroundColor',dsbackcl,...
      'ForegroundColor',dsforgcl );
 
% text('position',[0.40 0.5] ,'String', 'Xlabel');
  dsh62 = uicontrol('Style','edit','String','X-axis',...
       'Position',[200 50  80 20] );
  set(dsh62,'callback','dsxtitle');

% text('position',[0.40 0.35] ,'String', 'Ylabel');
  dsh63 = uicontrol('Style','edit','String','Y-axis',...
       'Position',[200 30 80 20] );
  set(dsh63,'callback','dsytitle');

  text('position',[0.40 0.2] ,'String', 'Zlabel');
  dsh64 = uicontrol('Style','edit','String','Z-axis',...
       'Position',[200 10 80 20] );
  set(dsh64,'callback','dsztitle');

% Log or linear scaling of axis.
  dsh65 = uicontrol('Style','checkbox' ,'value', 0,...
         'Position' , [280 50 70 20] );
  set(dsh65,'callback','dsxscal') ;

  dsh66 = uicontrol('Style','checkbox' ,'value', 0,...
         'Position' , [280 30 70 20] );
  set(dsh66,'callback','dsyscal') ;


  dsh67 = uicontrol('Style','checkbox' ,'value', 0,...
         'Position' , [280 10 70 20] );
  set(dsh67,'callback','dszscal') ;

% grid lines on or off.

  dsh68 = uicontrol('Style','checkbox' ,'value', 0,...
         'Position' , [350 50 40 20],'callback','dsxgrid') ;
  dsh69 = uicontrol('Style','checkbox' ,'value', 0,...
         'Position' , [350 30 40 20],'callback','dsygrid') ;
  dsh70 = uicontrol('Style','checkbox' ,'value', 0,...
         'Position' , [350 10 40 20],'callback','dszgrid') ;



h0 = figure( 'name','Surface Plot Window');

surf(xi,yi,zi);
shading interp;
title('Surface Plot');
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Z-axis');
hax = gca;


return; 
