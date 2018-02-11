% Main Menu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% File         : GoF.m                                                  %%
%% Description  : Main Menu For Game of Life                             %%
%% Program      : Game of Life                                           %%
%% Programmer   : Mr. Kitsuchart Pasupa                                  %%
%% Last Update  : 01-JAN-2005                                            %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear all
close all
disp('*******************************************************************')
disp('**  Pragram    : Game of Life                                     *')
disp('**  Programmer : Mr. Kitsuchart Pasupa                            *')
disp('*******************************************************************')
disp('** Menu : 1 - Generate an initial configuration for file          *')
disp('**        2 - Run a game of life                                  *')
disp('*******************************************************************')

% Get input from user - Menu
Menu     = input('Enter the Menu           : ');  
switch Menu
    case 1  % Generate an initial configuration for file
        disp('*******************************************************************')
        disp('** Menu : 1 - New (Custom)                                        *')
        disp('**        2 - New (Random)                                        *')
        disp('**        3 - Edit                                                *')
        disp('*******************************************************************')
        % Get input from user - SubMenu
        SubMenu = input('Enter the Menu           : ');  
        switch SubMenu
            case 1  % New - Custom
                New_Custom
            case 2  % New - Random
                New_Random
            case 3  % Edit
                Edit_Current
        end
    case 2  % Run a game of life
        Run_GOF
end