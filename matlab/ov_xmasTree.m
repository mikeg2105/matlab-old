function handles = ov_xmasTree(varargin);
% ov_xmasTree: draw a xmas tree
% ---------------------------------------------------------------------
% Task   : draw a xmas tree in current axis, (issues a clf command)
%
% Input  : ov_xmasTree(MAXHEIGHT)
%          ov_xmasTree(...,'PropertyName',PropertyValue,...)
%
%          MAXHEIGHT: default (30)
%            the maximum height of the tree
%
%          Possible Property-Value pairs are:
%          'detail': default (8)
%            the number of points definening a circle on a sphere,
%            thus it defines the smoothness of the needles and decorations
%            of the tree.
%
%          'decorationscolorarray': 
%            the decorations on the tree are colored randomly by the
%            colors in this array. The color array is given
%            as a Nx3 matrix of rgb values
%
%          'seperatepatches': boolean value
%            if set true the tree will consist of different patches for the
%            stem, the top, the needles, the branches and the decorations.
%            if set to false (default), the tree is drawn as one patch
%            (The decorations will not look as shiny as they do in seperate
%            mode, as the material properties are applied to the patch and
%            not on the faces.)
%
%          'decorationsProbability': default (0.025)
%            determines the amount of decorations on the tree. 
%
% Output : a xmas tree in the current axis, 
%          the axis is cleared before drawing the tree
%
% ---------------------------------------------------------------------

% Authors  : Dr. Marc Lätzel (Lä)
%
% Revisions:
%   2005-12-12: (Lä) initial creation
%
% Copyright: 2005 Marc Lätzel
% email adress: 
% char(cumsum([109 -12 17 -15 -35 41 -6 -2 -48 -3 71 -7 ...
%              -5 -60 70 1 1 -1 0 -13 -6 17 2 -70 54 1]));
% ---------------------------------------------------------------------

% Annotations:
% ---------------------------------------------------------------------
% The file is by no means a good example for matlab programming, its main
% purpos was to draw a xmas tree.
% The povray source is from xtree.inc
% from Remco de Korte 1998 <remcodek@xs4all.nl>
% the decoration part was inspired by Ken Allred's (2002) additions to
% xtree.inc
% <SNIP xtree.inc>
% //The xtree-object is a simple firtree, starting at <0,0,0> up to maxheight
% //You can change the tree by altering the rand-seed or the height, or by changing the
% //tow increment-steps indeicated below. The setting as it is now is working allright for 
% //me, changing it can increase the render-time dramatically.
% <SNAP>
% povray uses a differently oriented coordinate system, therefore rotations
% around y and z axis are interchanged.
%
% The rotation subroutines are copied from CAD2MATDEMO.M 
% by Don Riley from the FEX
%
% Happy Christmas    *
%                    /\
%                   /^^\ 
%    Marc          /^°^°\
%                    || 
% ---------------------------------------------------------------------



  [reg, properties] = parseparams(varargin);

  if length(reg)==1
    maxHeight = reg{1};
  elseif length(reg)~=0
    maxHeight = 30;
    disp('XMasTree uses input of the form XMasTree([height],''Properties'',...)');
    warning(['input ' mat2str([reg{2:end}]) ' is ignored.']);
  else
    maxHeight = 30;
  end
  
%% setup some constants
  nPoints = 8;
  decorationsColorArray = ...
    [1,0,0;...
     0,1,0;...
     0,0,1;...
     1,1,0;...
     1,0,1;];
% decorationsColorArray = ...
%  [0.85 0.66 0.3;...
%   0.91 0.91 0.91]; 
  decorationsSize = 0.6;
  NeedlePropability = 0.975;
  BRANCHTYPE = 1;
  NEEDLETYPE = 2;
  BALLTYPE   = 3;
  STEMTYPE   = 4;
  TOPTYPE    = 5;
  colorArrayTree = [0.5, 0.4, 0.2;...
                    0.2, 0.5, 0.2;...
                    0.0, 0.0, 0.9;...
                    0.5, 0.4, 0.2;...
                    0.6, 0.2, 0.0];
  seperatePatches = false;                
  
%% read Property-Value pairs
  for ii=1:2:length(properties)
    switch lower(properties{ii})
      case 'detail'
        nPoints = properties{ii+1};
      case 'decorationscolorarray'
        decorationsColorArray = properties{ii+1};
      case 'seperatepatches'
        seperatePatches = properties{ii+1};
      case 'decorationsprobability'
        NeedlePropability = 1-properties{ii+1};
      case 'decorationssize'
        decorationsSize = properties{ii+1};
      otherwise
        warning([properties{ii} ' unrecognized property.']);
    end
  end


%% a template ball
  [x,y,z] = sphere(nPoints);
  tmpBall.Vertices = [x(:),y(:),z(:)]*decorationsSize;
  tmpBall.Faces = convhulln(tmpBall.Vertices);


%% a template branch part
  [x,z,y] = ellipsoid( 0,0,0,  0.2,0.2*2.5,0.2,  nPoints);
  tmpBranch.Vertices = [x(:),y(:),z(:)];
  tmpBranch.Faces = convhulln(tmpBranch.Vertices);


%% a template needle
% #declare needle=sphere{<0,0,0>,1 scale<.75,.1,.1> pigment{rgb<.2,.5,.2>}}
% //here you can change the size of the needles - they're quite large and a
% bit 'fat' now 
  [x,z,y]  = ellipsoid(0,0,0,  0.5,0.1,0.1,  nPoints);
  tmpNeedle.Vertices = [x(:),y(:),z(:)];
  tmpNeedle.Faces = convhulln(tmpNeedle.Vertices);


%% The main XTree
  maxheight = maxHeight;              % #declare maxheight=30;
  rand('state',9);                    % #declare r=seed(777);

%% the stem of the tree, 
  % #declare xtree=union{  
  % width at top and foot depending on the height
  % cone{<0,0,0>,         maxheight/50,...
  %      <0,maxheight,0>, maxheight/200 texture{branch_text}}
  [x,y,z] = cylinder([maxheight/50; maxheight/200], nPoints);
  z = z * maxheight;
  stem.Vertices = [x(:),y(:),z(:)];
  stem.Faces = convhulln(stem.Vertices);
  
%% the top
  %   sphere{<0,maxheight,0>,maxheight/175 texture{branch_text}} 
  [x,y,z] = ellipsoid(0,0,maxheight, maxheight/175,maxheight/175,maxheight/175,nPoints);
  top.Vertices = [x(:),y(:),z(:)];
  top.Faces = convhulln(top.Vertices);
  
% //this starts the branches of at 1/15th of the tree's size off the ground.
%   #declare cc=maxheight/15;
  cc=maxheight/15;
  
  tree = povUnion;
%   #while (cc<maxheight)
  while (cc<maxheight)
    % start a branch:  
    % union{ 
    branch = povUnion;
    % #declare i=0;
    i = 0;
    % #declare dd=(maxheight*.95-cc)/2.5;
    dd = (maxheight*.95-cc)/2.5;
    % //put needles on the branch:  
    % #while (i<dd)
    while (i<dd)
      % union{
      branchPart = povUnion;
      %   sphere{<0,0,0>,.2 scale <1,2.5,1> texture{branch_text}}
      tmp = tmpBranch;
      branchPart = povUnion(branchPart,tmp,BRANCHTYPE);
      % //put the needles all around: 
      % #declare j=60*rand(r);   
      j = 60*rand;
      % #while (j<360)      
      while (j<360)
        % object{needle translate -x rotate z*-15-i*45/dd rotate y*j+30*rand(r)}  
        hasLight = rand;
        if hasLight<=NeedlePropability
          tmp = tmpNeedle;
          hasLight = 0;
        else
          tmp = tmpBall;
          hasLight = 1;
        end
        % translate -x rotate z*-15-i*45/dd rotate y*j+30*rand(r)
        tmp.Vertices(:,1) = tmp.Vertices(:,1)-0.75;
        tmp = c_rotateYAxis(tmp,-(-15-i*45/dd));
        tmp = c_rotateZAxis(tmp,j+30*rand);
      
        if hasLight==0
          branchPart = povUnion(branchPart,tmp,NEEDLETYPE);
        else
          branchPart = povUnion(branchPart,tmp,BALLTYPE);
        end
      
        % #declare j=j+60;
        j = j + 60;
      % #end
      end 

      % scale 1-.25*i/dd
      branchPart.Vertices = branchPart.Vertices * (1-0.25*i/dd);
      % translate y*i 
      branchPart.Vertices(:,3) = branchPart.Vertices(:,3)+i;
    % }

      branch = povUnion(branch,branchPart);

      % the frequency of the needles (~the amount of needles) depends on this step
      % if you make it smaller you have more needles and a much more rendertime
      % #declare i=i+.4;
      i = i + 0.4; 

    % #end
    end %(i<dd)
  
    if ~isempty(branch.Vertices)
      % //this makes the branch point up a bit 
      % (depending on how high it is on the tree)
      % rotate z*(-75+cc/2)
      branch = c_rotateYAxis(branch,-75+cc/2);

      % //this puts it on the tree somewhere around 
      % rotate y*360*rand(r)
      branch = c_rotateZAxis(branch,360*rand);

      % this puts the branch at its proper height
      % translate y*cc    
      branch.Vertices(:,3) = branch.Vertices(:,3) + cc;

      tree = povUnion(tree,branch); 
    end
    % }

    % Not implemented yet
    % //put some needles on the stem:
    %   #declare j=0;
    %   #while (j<360)
    %     object{needle translate -x rotate z*(-45-15*rand(r)) translate -x*maxheight/400 rotate y*j+30*rand(r) translate y*cc}
    %   #declare j=j+60;
    %   #end

    % //this step defines the number of branches. 
    % //There's one branch for each step, but it can be at any side of the tree
    % //Again, if you make this smaller you'll have more branches, but it'll also render much slower
    % //You could probably make the tree more realistic by increasing the step towards the top of the tree 
    % #declare cc=cc+.25;
    cc = cc + 0.25;
  % #end
  end %while (cc<maxheight) 
  % }

%% Now the drawing part
  clf;
  hold on
  % check whether to draw one patch or seperate patches
  if seperatePatches
    handles.Top  = trisurf(top.Faces,top.Vertices(:,1),top.Vertices(:,2),top.Vertices(:,3),1,...
                   'FaceColor',[0.6,0.2,0.0],...
                   'EdgeColor','none','FaceLighting','gouraud');
    handles.Stem = trisurf(stem.Faces,stem.Vertices(:,1),stem.Vertices(:,2),stem.Vertices(:,3),2,...
                   'FaceColor',[0.5, 0.4, 0.2],...
                   'EdgeColor','none','FaceLighting','gouraud');
    [needles.Faces,needles.Vertices,needles.Types] = c_seperateType(tree,NEEDLETYPE);
    handles.Needles = patch('Faces',needles.Faces,...
                    'Vertices',needles.Vertices,...
                    'FaceColor','flat',...
                    'FaceVertexCData',colorArrayTree(needles.Types,:),...
                    'EdgeColor','none','FaceLighting','gouraud');
    [branches.Faces,branches.Vertices,branches.Types] = c_seperateType(tree,BRANCHTYPE);
    handles.Branches = patch('Faces',branches.Faces,...
                    'Vertices',branches.Vertices,...
                    'FaceColor','flat',...
                    'FaceVertexCData',colorArrayTree(branches.Types,:),...
                    'EdgeColor','none','FaceLighting','gouraud');
    [decorations.Faces,decorations.Vertices,decorations.Types] = c_seperateType(tree,BALLTYPE);
    if ~isempty(decorations.Faces)
      handles.Decorations = patch('Faces',decorations.Faces,...
                      'Vertices',decorations.Vertices,...
                      'FaceColor','flat',...
                      'FaceVertexCData',colorArrayTree(decorations.Types,:),...
                      'EdgeColor','none','FaceLighting','gouraud');
      colorDecorations(decorations,handles.Decorations,...
                       BALLTYPE,tmpBall,decorationsColorArray);                  
    end
  else
    tree = povUnion(tree,top,TOPTYPE);
    tree = povUnion(tree,stem,STEMTYPE);
    handles = patch('Faces',tree.Faces,...
                    'Vertices',tree.Vertices,...
                    'FaceColor','flat',...
                    'FaceVertexCData',colorArrayTree(tree.Types,:),...
                    'EdgeColor','none','FaceLighting','gouraud');
    colorDecorations(tree,handles,BALLTYPE,tmpBall,decorationsColorArray);                  
  end                    
  light
  axis equal
  view(0,0);
  set(gca,'Visible','off');
  set(gca,'DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',[1 1 1])
end % of function s_XMasTree
  
%% --- Definition of some local functions ------------------
 function unionObject = povUnion(unionObject, newObject, Type)
   if nargin==0
     unionObject.Faces = [];
     unionObject.Vertices = [];
     unionObject.Types = [];
     return
   end

   if nargin<3
     Type = NaN;
   end
   
   unionObject.Faces    = [unionObject.Faces; ...
                           newObject.Faces+length(unionObject.Vertices)];  
   unionObject.Vertices = [unionObject.Vertices; newObject.Vertices];
   if isnan(Type)
     unionObject.Types  = [unionObject.Types; newObject.Types];
   else
     unionObject.Types  = [unionObject.Types; ...
                           ones(length(newObject.Faces),1)*Type];
   end
 end % of function povUnion
 % ---------------------------------------------------------------------------
  
 function object = c_rotateYAxis(object,THETA)
 % ROTATION ABOUT THE Y-AXIS
 %
 % This is the homogeneous transformation for
 % rotation about the Y-axis.
 %
 %		NOTE: The angel THETA must be in DEGREES.
 %
   THETA = THETA*pi/180;  %Note: THETA is in radians.
   c = cos(THETA);
   s = sin(THETA);
   Ry = [c 0 s 0; 0 1 0 0; -s 0 c 0; 0 0 0 1];
   tmp = Ry*[object.Vertices ones(length(object.Vertices),1)]';
   object.Vertices = tmp(1:3,:)';
 end % of function c_rotateYAxis
 % ---------------------------------------------------------------------------

 function object = c_rotateZAxis(object,THETA)
 % ROTATION ABOUT THE Z-AXIS
 %
 % This is the homogeneous transformation for
 % rotation about the Z-axis.
 %
 %		NOTE:  The angle THETA must be in DEGREES.
 %
   THETA = THETA*pi/180;  %Note: THETA is in radians.
   c = cos(THETA);
   s = sin(THETA);
   Rz = [c -s 0 0; s c 0 0; 0 0 1 0; 0 0 0 1];
   tmp = Rz*[object.Vertices ones(length(object.Vertices),1)]';
   object.Vertices = tmp(1:3,:)';
 end % of function c_rotateZAxis
 % ---------------------------------------------------------------------------
 
 function [newFaces,newVertices,newTypes] = c_seperateType(varargin)
 % if 2 inputs those are: object,selectType
 % if 4 inputs those are: faces,vertices,types,selcetType
   if nargin==2
     faces      = varargin{1}.Faces;
     vertices   = varargin{1}.Vertices;
     types      = varargin{1}.Types;
     selectType = varargin{2};
   elseif nargin==4
     faces      = varargin{1};
     vertices   = varargin{2};
     types      = varargin{3};
     selectType = varargin{4};    
   else
     error('c_seperateType: wrong number of parameters.');
   end

   tmp = unique(faces(types==selectType,:));
   tmpMap = [tmp [1:length(tmp)]'];
   map = ones(length(vertices),1)*NaN;
   map(tmpMap(:,1)) = tmpMap(:,2);

   newVertices = vertices(tmp,:);
   newFaces    = map(faces(types==selectType,:));
   newTypes    = ones(size(newFaces,1),1)*selectType;
 end % of function c_seperateType
 % ---------------------------------------------------------------------------
 
 function colorDecorations(object,handle,BALLTYPE,tmpBall,decorationsColorArray)
   if ~isempty(object.Types==BALLTYPE)    
     decoIdx = find(object.Types==BALLTYPE);
     numBalls = length(decoIdx)/length(tmpBall.Faces);
     numFaces = length(decoIdx);
     tmpFaceVertexCData = repmat([0.0, 0.9, 0.0],numFaces,1);
     for iBalls=1:numBalls 
       rColor = rand*length(decorationsColorArray); 
       rColor = min(ceil(rColor),size(decorationsColorArray,1));
       color = repmat(decorationsColorArray(rColor,:),length(tmpBall.Faces),1);
       tmpFaceVertexCData(1+(iBalls-1)*length(tmpBall.Faces):...
                          iBalls*length(tmpBall.Faces),:) = color;
     end
     faceVertexCData=get(handle,'FaceVertexCData');
     faceVertexCData(decoIdx,:) = tmpFaceVertexCData;
     set(handle,'FaceVertexCData',faceVertexCData);
     % use metalic looking balls if    
     % all faces belong to one decoration patch
     if size(object.Faces,1)==numFaces 
       set(handle,...
           'AmbientStrength',0.4,...
           'DiffuseStrength',0.7,...
           'SpecularStrength',8.0,...
           'SpecularExponent',5,...
           'SpecularColorReflectance',0.6);
     end
   end
 end % of function colorDecorations
 % --------------------------------------------------------------------------- 
