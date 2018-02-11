% Draw Alive & Dead Cell for the initial Board
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% File         : DrawGen.m                                              %%
%% Description  : Draw Alive & Dead Cell for the initial Board           %%
%% Program      : Game of Life                                           %%
%% Programmer   : Mr. Kitsuchart Pasupa                                  %%
%% Last Update  : 01-JAN-2005                                            %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function BoardColor = DrawGen(XBoard, YBoard, BoardCentreX, BoardCentreY, ...
                              Board, radius, Theta)

for i=1:XBoard
   for j=1:YBoard
      X = BoardCentreX(j,i) + radius*cos(Theta);
      Y = BoardCentreY(j,i) + radius*sin(Theta);
      if Board(j,i) == 1
          % Fill Blue Color When cell is alive
          BoardColor(j,i) = fill(X,Y,'b');             
      else
          % Fill Grey Color When cell is dead
          BoardColor(j,i) = fill(X,Y,[0.8 0.8 0.8]);  
          set(BoardColor(j,i),'EdgeColor',[0.8 0.8 0.8]);
      end
   end
end