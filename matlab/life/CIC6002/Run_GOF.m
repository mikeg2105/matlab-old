% Run Game of Life
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% File         : Run_GOF.m                                              %%
%% Description  : Run Game of Life                                       %%
%% Program      : Game of Life                                           %%
%% Programmer   : Mr. Kitsuchart Pasupa                                  %%
%% Last Update  : 01-JAN-2005                                            %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get inputs from user
ConfFile = input('Enter the Config File : ');
while isempty(ConfFile)
    ConfFile = input('Please Enter the Config File : ');    
end
CellSize = input('Enter the Width of Cell (Default = 20): ');
StepGen  = input('Enter the Number of Steps to run (Default = 5): ');
GenSave  = input('Enter the Number of How Often The Generated Configurations Will Be Saved (Default = 2): ');

% Load Data File
load(ConfFile)

% Determine The Size of The Board
[YBoard, XBoard] = size(Board);

% Default Value when user did not input the data
if isempty(CellSize)
    CellSize = 20;
end

if isempty(StepGen)
    StepGen = 5;
end

if isempty(GenSave)
    GenSave = 2;
end

% Parameter Initialization & Draw a Board
Para_Initialization;

% Draw Alive & Dead Cell for the initial Board
BoardColor = DrawGen(XBoard, YBoard, BoardCentreX, BoardCentreY, Board, ...
                     radius, Theta);

fprintf('Loading is Done \n\t\t\t\t\t\t\tPress any key to continue \n')
pause

for i = 1:StepGen
    fprintf('Generation %i\n', i)
    
    % Generate a game of life for 1 generation 
    Board = BoardGen(XBoard, YBoard, Board, 1);
    
    % Show the outcome after the game is generated
    BoardColor = DrawGen(XBoard, YBoard, BoardCentreX, BoardCentreY, Board, ...
                         radius, Theta);
    
    % Save every 'GenSave'-Generation
    if mod(i,GenSave)==0
        save(ConfFile, 'Board')
        fprintf('\t\t\t\tData Save\n')
    end
    fprintf('\t\t\t\t\t\t\tPress any key to continue \n')
    pause
end