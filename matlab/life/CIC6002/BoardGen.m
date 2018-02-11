% Board Generation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% File         : Board_Generation.m                                     %%
%% Description  : Generate the game of life for the number of generation %%
%%                you want.                                              %%
%% Program      : Game of Life                                           %%
%% Programmer   : Mr. Kitsuchart Pasupa                                  %%
%% Last Update  : 01-JAN-2005                                            %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Board = BoardGen(XBoard, YBoard, Board, NGen)

% Counter Clockwise Directions Starting From West
XDir = [-1 -1 0 +1 +1 +1 0 -1];
YDir = [0 +1 +1 +1 0 -1 -1 -1];

for i = 1:NGen
    for i = 1:YBoard
        for j = 1:XBoard
            Count = 0;  % Initialise Counter to 0
            for dir = 1:8  % Check all surrounding cells for each cell
                if i+YDir(dir) >= 1 & j+XDir(dir) >= 1 & ...
                   i+YDir(dir) <= YBoard & j+XDir(dir) <= XBoard
                    % Adding counter when alive cell is detected
                    Count = Count+Board(i+YDir(dir),j+XDir(dir));
                end
            end
            if Board(i,j) == 0 & Count == 3 % A dead cell with exactly three live
                NewBoard(i,j) = 1;          % neighbors becomes a live cell.
                
            elseif Board(i,j) == 1 & Count == 2 % A live cell with two live  
                NewBoard(i,j) = 1;              % neighbors stays alive.
                
            elseif Board(i,j) == 1 & Count == 3 % A live cell with three live 
                NewBoard(i,j) = 1;              % neighbors stays alive .
                
            else  % In all other cases, a cell dies or remains dead
                NewBoard(i,j) = 0;
            end
        end
    end
    Board = NewBoard;
end