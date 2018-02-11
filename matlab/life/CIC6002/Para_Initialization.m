% Parameter Initialization & Draw a Board
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% File         : Para_Initialization.m                                  %%
%% Description  : Parameter Initialization & Draw a Board                %%
%% Program      : Game of Life                                           %%
%% Programmer   : Mr. Kitsuchart Pasupa                                  %%
%% Last Update  : 01-JAN-2005                                            %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Drawing Parameter
XFigSize = XBoard*CellSize;
YFigSize = YBoard*CellSize;
DrawResolution = 1/100;
N              = 2*pi;
Theta          = 0:DrawResolution:N;

% Setup The Main Frame
Fig1 = figure(1); 
set(Fig1, 'Position', [50 50 XFigSize YFigSize],...
   'Name','Game of Life, By Mr. Kitsuchart Pasupa',...
   'NumberTitle','off',...
   'MenuBar','none');

% Determine The Board Grids
XLine = linspace(0,XFigSize,XBoard+1);
YLine = linspace(0,YFigSize,YBoard+1);

% Draw The Board Grids
for i=1:(XBoard+1)
   line([XLine(i) XLine(i)], [YLine(1) YLine(YBoard+1)],'Color',[1 1 1]);
   for j=1:(YBoard+1)
       line([XLine(1) XLine(XBoard+1)], [YLine(j) YLine(j)],'Color',[1 1 1]);
   end
end

hold on; 
axis off;
 
% Calculate The Radius of The Piece
gap = (XLine(2)-XLine(1))/2;
radius = gap - (gap*0.40); % Leave a 40% Side Margin

% The Centre of The Pieces For Drawing Purposes
XCentre = linspace((XLine(2)-XLine(1))/2, XFigSize-(XLine(2)-XLine(1))/2, XBoard);
YCentre = linspace((YLine(2)-YLine(1))/2, YFigSize-(YLine(2)-YLine(1))/2, YBoard);

BoardCentreX = repmat(XCentre,YBoard,1);
BoardCentreY = repmat((YFigSize - YCentre)',1,XBoard);