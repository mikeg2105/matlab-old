% Edit Current Board
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% File         : Edit_Current.m                                         %%
%% Description  : Edit an existing file                                  %%
%% Program      : Game of Life                                           %%
%% Programmer   : Mr. Kitsuchart Pasupa                                  %%
%% Last Update  : 01-JAN-2005                                            %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get inputs from user
ConfFile = input('Enter the Config File : ');
while isempty(ConfFile)
    ConfFile = input('Please Enter the Config File : ');    
end
CellSize = input('Enter the Width of Cell  (Default = 20): ');
disp('*******************************************************************')
disp('** Help                                                          **')
disp('*******************************************************************')
disp('** Left Click   - Add Cell                                       **')
disp('** Right Click  - Delete Cell                                    **')
disp('** Middle Click - Exit                                           **')
disp('*******************************************************************')

% Load Data File
load(ConfFile)

% Determine The Size of The Board
[YBoard, XBoard] = size(Board);

% Default Value when user did not input the data
if isempty(CellSize)
    CellSize = 20;
end

% Parameter Initialization & Draw a Board
Para_Initialization;

% Draw Alive & Dead Cell for the initial Board
BoardColor = DrawGen(XBoard, YBoard, BoardCentreX, BoardCentreY, Board, ...
                     radius, Theta);

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