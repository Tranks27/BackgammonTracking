%% AMME4710 Major Project
% Thomas Jeong
% SID 470341300

% Initial Setup
function [finished_turn, countNew] = tjPart(videoFrame, move_array, count)
    
    finished = 0;

    while finished == 0 && boardSetup == 1

        % Return from Josiah
        diceRolls = move_array;
        turn = randi(2);

        returnable = [0 0];

        if count == 0
        
            % Get initial board
            image = videoFrame; % Will be edited out as variable passed on by Tranks
            cropBackground(image);
            [idMatFull, pieces] = outputPieces();
            [available, unavailable] = availability(idMatFull, pieces, turn);
            [move1 move1p] = identifyAllPossibilities(diceRolls, turn, idMatFull, pieces, returnable, available, unavailable);

            countNew = 1;
        elseif count == 1
            
            firstDone = 0;
            secondDone = 0;
            % Check for first move
            while firstDone == 0
                image = videoFrame; % Will be edited out as variable passed on by Tranks
                cropBackground(image);
                [idMatFirst, piecesFirst] = outputPieces();
                [firstDone, secondDone] = firstMovement(pieces, piecesFirst, move1, move1p);
            end
            idMatFull = idMatFirst;
            pieces = piecesFirst;
            countNew = count + firstDone + secondDone;
            if secondDone == 1
                finished = 1;
            end
        elseif count == 2
            
            % second move
            %if finished ~= 0
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
                %finished = checkFinished(idMatFull);
            %end
            % change turn
            if turn == 1
                turn = 2;
            else
                turn = 1;
            end

            countNew = count + 1;
            finished = 1;
        end
    end
    
    finished_turn = finished;
end