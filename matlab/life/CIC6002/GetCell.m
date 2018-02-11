% Get inputs from mouse & Add/Delete to/from board
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% File         : GetCell.m                                              %%
%% Description  : Get inputs from mouse & Add/Delete to/from board       %%
%% Program      : Game of Life                                           %%
%% Programmer   : Mr. Kitsuchart Pasupa                                  %%
%% Last Update  : 01-JAN-2005                                            %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Board, BoardColor] = GetCell(XBoard,YBoard,XLine,YLine,Board,BoardColor)

Done=0;
while Done==0
    [Xnew Ynew Button] = ginput(1);  % Get input from mouse
    if Button == 2  % Middle Click to quit editing
        break
    end
    
    % Check whether input is inside the board
    if (XLine(1)<Xnew) & (Xnew<XLine(XBoard+1)) & ...
            (YLine(1)<Ynew) & (Ynew<YLine(YBoard+1))
        XPos = sum(Xnew>XLine);  % Find X-axis block of input on the board
        YPos = YBoard-sum(Ynew>YLine)+1;  % Find Y-axis block of input on the board
        if Button == 1  % Left Click to Add Cell
            % Fill Blue Color for alive cell
            set(BoardColor(YPos,XPos),'FaceColor','b','EdgeColor',[0 0 0]); 
            % Set this cell to be 1 (alive)
            Board(YPos, XPos)=1;  
        elseif Button == 3  % Right Click to Delete Cell
            % Fill Grey Color for dead cell
            set(BoardColor(YPos,XPos),'FaceColor',[0.8 0.8 0.8],'EdgeColor',...
                [0.8 0.8 0.8]);
            % Set this cell to be 0 (dead)
            Board(YPos, XPos)=0;  
        end
    end
end