% New Custom Board
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% File         : New_Custom.m                                           %%
%% Description  : Edit a new custom board                                %%
%% Program      : Game of Life                                           %%
%% Programmer   : Mr. Kitsuchart Pasupa                                  %%
%% Last Update  : 01-JAN-2005                                            %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get inputs from user
XBoard   = input('Enter the Width of Board (Default = 10): ');
YBoard   = input('Enter the Hight of Board (Default = 10): ');
CellSize = input('Enter the Width of Cell  (Default = 20): ');
ConfFile = input('Enter the Config File    (Default = Data.mat): ');
disp('*******************************************************************')
disp('** Help                                                          **')
disp('*******************************************************************')
disp('** Left Click   - Add Cell                                       **')
disp('** Right Click  - Delete Cell                                    **')
disp('** Middle Click - Exit                                           **')
disp('*******************************************************************')

% Default value when user did not input the data
if isempty(XBoard)
    XBoard = 10;
end

if isempty(YBoard)
    YBoard = 10;
end

if isempty(CellSize)
    CellSize = 20;
end

if isempty(ConfFile)
    ConfFile = 'Data.mat';
end

% Define the board
Board = zeros(YBoard,XBoard);   % Blank board

% Parameter Initialization & Draw a Board
Para_Initialization;

% Draw Alive & Dead Cell for the initial Board
BoardColor = DrawGen(XBoard, YBoard, BoardCentreX, BoardCentreY, ...
                     Board, radius, Theta);

% Get inputs from mouse & Add/Delete to/from board
[Board, BoardColor] = GetCell(XBoard,YBoard,XLine,YLine,Board,BoardColor);

% Display A Board in Matric
% Board

% Save or not?
Save_YN = questdlg(['Do you want to save?' ],'Save', 'Y', 'N', 'N');
if Save_YN == 'Y'
    save(ConfFile, 'Board')
    fprintf('Configuration File Save - %s\nNow You Can Run a Game of Life\n', ...
            ConfFile)
elseif Save_YN == 'N'
    disp('You Did Not Save The Configuration File')
end