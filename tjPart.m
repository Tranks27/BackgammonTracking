%% AMME4710 Major Project
% Thomas Jeong
% SID 470341300

clear;
clc;
clf;
close all;

% Initial Setup
cropBackground();
[idMatFull, pieces] = outputPieces();
boardSetup = initiateBoard(idMatFull, pieces);
boardSetup = 1;
finished = 0;

% disp(1);
while finished == 0 && boardSetup == 1
    
    diceRolls = [randi(6) randi(6)];
    turn = randi(2);

    returnable = [0 0];

    cropBackground();
    [idMatFull, pieces] = outputPieces();
    [available, unavailable] = availability(idMatFull, pieces, turn);
    [move1 move2 move1p] = identifyAllPossibilities(diceRolls, turn, idMatFull, pieces, returnable, available, unavailable);
    
    finished = checkFinished(idMatFull);
    
%     finished = 1;
%     disp(2);
end


