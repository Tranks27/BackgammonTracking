function [move1 move1p] = identifyAllPossibilities(diceRoll, turn, idMatFull, pieces, returnable, available, unavailable)

    if length(diceRoll) == 4
        
        diceRolls = diceRoll(1:2);
    else
        
        diceRolls = diceRoll;
    end
    
    % White & Brown
    if returnable(turn) == 0
        
        returnable(turn) = determineGetHome(turn, idMatFull, pieces);
    end

    if turn == 1
        movement = -1;
    else
        movement = 1;
    end
    
    if diceRolls(1) == diceRolls(2)
    
        possibleMovements(1,:) = [diceRolls(1) 2*diceRolls(1)];
        possibleMovements(2,:) = [diceRolls(1) 0];
    else

        possibleMovements(1,:) = [diceRolls(1) diceRolls(2) sum(diceRolls)];
        possibleMovements(2,:) = [diceRolls(2) diceRolls(1) 0];
    end

    bufferFrom1Final = [];
    bufferTo1Final = [];
    bufferFrom2Final = [];
    bufferTo2Final = [];
    bufferFrom1PieceFinal = [];
    bufferTo1PieceFinal = [];
    for i = 1:length(available)
        bufferFrom1 = [];
        bufferTo1 = [];
        bufferFrom2 = [];
        bufferTo2 = [];
        bufferFrom1Piece = [];
        bufferTo1Piece = [];

        checkMovement1 = zeros(1,length(possibleMovements(1,:)));
        checkMovement2 = checkMovement1;

        checkMovement1 = available(i) + movement*possibleMovements(1,:);
        checkMovement2 = available(i) + movement*possibleMovements(2,:);

        for j = 1:length(unavailable)
            for k = 1:length(checkMovement1)

                flag1 = 0;
                flag2 = 0;
                flag3 = 0;
                if checkMovement1(k) ~= unavailable(j)
                    if k == length(checkMovement1)
                        flag3 = 1;
                    else
                        flag1 = 1;
                    end
                end
                if checkMovement2(k) ~= unavailable(j) && k ~= length(checkMovement1)
                    flag2 = 1;
                end
                if returnable(turn) == 0 && (checkMovement1(k) < 0 || checkMovement1(k) > 24)
                    flag1 = 0;
                    flag3 = 0;
                end
                if returnable(turn) == 0 && (checkMovement2(k) < 0 || checkMovement2(k) > 24)
                    flag2 = 0;
                end
                if flag1 == 1
                    if isempty(bufferFrom1)
                        bufferFrom1 = [bufferFrom1 available(i)];
                        bufferTo1 = [bufferTo1 checkMovement1(k)];
                    else
                        l = length(bufferFrom1);
                        if ~(bufferFrom1(l) == available(i) && bufferTo1(l) == checkMovement1(k))
                            bufferFrom1 = [bufferFrom1 available(i)];
                            bufferTo1 = [bufferTo1 checkMovement1(k)];
                        end
                    end
                end
                if flag2 == 1
                    if isempty(bufferFrom2)
                        bufferFrom2 = [bufferFrom2 available(i)];
                        bufferTo2 = [bufferTo2 checkMovement2(k)];
                    else
                        l = length(bufferFrom2);
                        if ~(bufferFrom2(l) == available(i) && bufferTo2(l) == checkMovement2(k))
                            bufferFrom2 = [bufferFrom2 available(i)];
                            bufferTo2 = [bufferTo2 checkMovement1(k)];
                        end
                    end
                end
                if flag3 == 1
                    if isempty(bufferFrom1Piece)
                        bufferFrom1Piece = [bufferFrom1Piece available(i)];
                        bufferTo1Piece = [bufferTo1Piece checkMovement1(k)];
                    else
                        l = length(bufferFrom1Piece);
                        if ~(bufferFrom1Piece(l) == available(i) && bufferTo1Piece(l) == checkMovement1(k))
                            bufferFrom1Piece = [bufferFrom1Piece available(i)];
                            bufferTo1Piece = [bufferTo1Piece checkMovement1(k)];
                        end
                    end
                end
            end
        end

        bufferFrom1Final = [bufferFrom1Final bufferFrom1];
        bufferTo1Final = [bufferTo1Final bufferTo1];
        bufferFrom2Final = [bufferFrom2Final bufferFrom2];
        bufferTo2Final = [bufferTo2Final bufferTo2];
        bufferFrom1PieceFinal = [bufferFrom1PieceFinal bufferFrom1Piece];
        bufferTo1PieceFinal = [bufferTo1PieceFinal bufferTo1Piece];
    end
    
    b1Final = [bufferFrom1Final; bufferTo1Final];
    b2Final = [bufferFrom2Final; bufferTo2Final];
    
    newBuf1 = [b1Final(:,1)];
    newBuf2 = [b2Final(:,1)];
    newBuf1p = [bufferFrom1PieceFinal; bufferTo1PieceFinal];
    c = 1;
    for i = 2:length(bufferFrom1Final)
        
        count = 0;
        for j = 1:c
            if newBuf1(:,j) == b1Final(:,i)
                
                count = count + 1;
            end
        end
        
        if count == 0
            newBuf1 = [newBuf1 b1Final(:,i)];
            c = c + 1;
        end
    end
    c = 1;
    for i = 2:length(bufferFrom2Final)
        
        count = 0;
        for j = 1:c
            if newBuf2(:,j) == b2Final(:,i)
                
                count = count + 1;
            end
        end
        
        if count == 0
            
            newBuf2 = [newBuf2 b2Final(:,i)];
            c = c + 1;
        end
    end
    
    move1 = newBuf1;
    move1p = newBuf1p;
end