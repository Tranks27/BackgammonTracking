%% AMME4710 Major Project
% Thomas Jeong
% SID 470341300

% Initial Setup
function [finished_turn, countNew, playerTurn, id_Matrix, piece_Matrix, move_1, move_1p] = tjPart(videoFrame, move_array, count, turn_player, idMatrix, pieceMatrix, move1, move1p)
    

    finished = 0;

    % Return from Josiah
    diceRolls = move_array;
    turn = turn_player;
    

    returnable = [0 0];

    if count == 0

        % Get initial board
        buffer = videoFrame;
        r = buffer(end:-1:1,:,1)';
        g = buffer(end:-1:1,:,2)';
        b = buffer(end:-1:1,:,3)';
        image = cat(3, r, g, b);
        cropBackground(image);
        [idMatFull, pieces] = outputPieces();
        [available, unavailable] = availability(idMatFull, pieces, turn);
        [move1 move1p] = identifyAllPossibilities(diceRolls, turn, idMatFull, pieces, returnable, available, unavailable);

        countNew = 1;
    elseif count == 1

        idMatFull = idMatrix;
        pieces = pieceMatrix;
        
        firstDone = 0;
        secondDone = 0;
        % Check for first move
        while firstDone == 0
            buffer = videoFrame;
            r = buffer(end:-1:1,:,1)';
            g = buffer(end:-1:1,:,2)';
            b = buffer(end:-1:1,:,3)';
            image = cat(3, r, g, b);
            cropBackground(image);
            [idMatFirst, piecesFirst] = outputPieces();
            %[firstDone, secondDone] = firstMovement(pieces, piecesFirst, move1, move1p);
            firstDone = 1;
        end
        idMatFull = idMatFirst;
        pieces = piecesFirst;
        countNew = count + firstDone + secondDone;
        if secondDone == 1
            finished = 1;

            disp('Turn Finished. Next Player.');
        end

        disp('First Movement Successful. Next Movement.');
    elseif count == 2

        idMatFull = idMatrix;
        pieces = pieceMatrix;
        
        % second move
        %if finished ~= 0
            newRoll = 0;
            secondDone = 0;
            [available, unavailable] = availability(idMatFull, pieces, turn);
            move1 = identifySecond(newRoll, turn, idMatFull, pieces, returnable, available, unavailable);
            while secondDone == 0
                buffer = videoFrame;
                r = buffer(end:-1:1,:,1)';
                g = buffer(end:-1:1,:,2)';
                b = buffer(end:-1:1,:,3)';
                image = cat(3, r, g, b);
                cropBackground(image);
                [idMatSecond, piecesSecond] = outputPieces();
                %secondDone = secondMovement(pieces, piecesSecond, move1);
                secondDone = 1;
            end
            idMatFull = idMatSecond;
            pieces = piecesSecond;
            %finished = checkFinished(idMatFull);
        %end
        disp('Second Movement Successful.');
        disp('Turn Finished. Next Player.');
        countNew = count + 1;
        finished = 1;
    end
    id_Matrix = idMatFull;
    piece_Matrix = pieces;
    
    if count == 2
        move_1 = move1;
        move_1p = [];
    elseif count == 3
        move_1 = [];
        move_1p = [];
    else
        move_1 = move1;
        move_1p = move1p;
    end
    
    playerString = "";
    status = "";
    if count == 0 || count == 2
        
        if count == 0
            
            status = "Start of Turn";
        else
            
            status = "End of Turn";
        end
        
        if turn_player == 1
            
            playerString = "White";
            
        else
            
            playerString = "Brown";
        end
        
        outputString1 = strcat(playerString, " - ", status, " - Dice Rolls:", num2str(move_array));
        outputString2 = strcat("Colour ID:      ", num2str(idMatFull));
        outputString3 = strcat("No. of Pieces:  ",num2str(pieces));
        recordedMoves = fopen('record.txt', 'a+');
        finalText = sprintf("%s\n%s\n%s\n",outputString1,outputString2,outputString3);
        fwrite(recordedMoves, finalText);
        fclose(recordedMoves);
    end
    
    playerTurn = turn;
    
    if finished == 1
        
        % change turn
        if turn_player == 1
            playerTurn = 2;
        else
            playerTurn = 1;
        end
    end
    
    


    finished_turn = finished;
end