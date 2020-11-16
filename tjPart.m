%% AMME4710 Major Project
% Thomas Jeong
% SID 470341300

clear;
clc;
clf;
close all;

diceRolls = [randi(6) randi(6)];
turn = randi(2);

returnable = [1 1];

cropBackground();
[idMatFull, pieces] = outputPieces();
[available, unavailable] = availability(idMatFull, pieces, turn);
[move1 move2 move1p] = identifyAllPossibilities(diceRolls, turn, idMatFull, pieces, returnable, available, unavailable);

