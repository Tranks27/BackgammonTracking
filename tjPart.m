%% AMME4710 Major Project
% Thomas Jeong
% SID 470341300

clear;
clc;
clf;
close all;

% Initial Setup

filename = strcat('cropped_1.jpeg');
image = imread(filename); % Will be edited out as variable passed on by Tranks
cropBackground(image);
[idMatFull, pieces] = outputPieces();
boardSetup = initiateBoard(idMatFull, pieces);
boardSetup = 1;
finished = 0;

while finished == 0 && boardSetup == 1
    
    % Return from Josiah
    diceRolls = [randi(6) randi(6)];
    turn = randi(2);
    
    returnable = [0 0];

    % Get initial board
    image = imread(filename); % Will be edited out as variable passed on by Tranks
    cropBackground(image);
    [idMatFull, pieces] = outputPieces();
    [available, unavailable] = availability(idMatFull, pieces, turn);
    [move1 move1p] = identifyAllPossibilities(diceRolls, turn, idMatFull, pieces, returnable, available, unavailable);
    
    firstDone = 0;
    secondDone = 0;
    % Check for first move
    while firstDone == 0
        image = imread(filename); % Will be edited out as variable passed on by Tranks
        cropBackground(image);
        [idMatFirst, piecesFirst] = outputPieces();
        [firstDone, secondDone] = firstMovement(pieces, piecesFirst, move1, move1p);
    end
    idMatFull = idMatFirst;
    pieces = piecesFirst;
    finished = checkFinished(idMatFull);
    % second move
    if finished ~= 0
        newRoll = 0;
        if abs(from - to) == diceRolls(1)
            newRoll = diceRolls(2);
        else
            newRoll = diceRolls(1);
        end
        [available, unavailable] = availability(idMatFull, pieces, turn);
        move1 = identifySecond(newRoll, turn, idMatFull, pieces, returnable, available, unavailable);
        while secondDone == 0
            image = imread(filename); % Will be edited out as variable passed on by Tranks
            cropBackground(image);
            [idMatSecond, piecesSecond] = outputPieces();
            secondDone = secondMovement(pieces, piecesSecond, move1);
        end
        idMatFull = idMatSecond;
        pieces = piecesSecond;
        finished = checkFinished(idMatFull);
    end
    % change turn
    if turn == 1
        turn = 2;
    else
        turn = 1;
    end
end


