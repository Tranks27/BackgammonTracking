function move1 = identifySecond(diceRoll, turn, idMatFull, pieces, returnable, available, unavailable)

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
    
    possibleMovements = diceRoll;

    bufferFrom1Final = [];
    bufferTo1Final = [];

    for i = 1:length(available)
        bufferFrom1 = [];
        bufferTo1 = [];

        checkMovement1 = 0;

        checkMovement1 = available(i) + movement*possibleMovements;
        
        for j = 1:length(unavailable)
            flag1 = 0;
            if checkMovement1 ~= unavailable(j)
                flag1 = 1;
            end
            if returnable(turn) == 0 && (checkMovement1 < 0 || checkMovement1 > 24)
                flag1 = 0;
            end
            if flag1 == 1
                if isempty(bufferFrom1)
                    bufferFrom1 = [bufferFrom1 available(i)];
                    bufferTo1 = [bufferTo1 checkMovement1];
                else
                    l = length(bufferFrom1);
                    if ~(bufferFrom1(l) == available(i) && bufferTo1(l) == checkMovement1)
                        bufferFrom1 = [bufferFrom1 available(i)];
                        bufferTo1 = [bufferTo1 checkMovement1];
                    end
                end
            end
        end

        bufferFrom1Final = [bufferFrom1Final bufferFrom1];
        bufferTo1Final = [bufferTo1Final bufferTo1];
    end
    
    b1Final = [bufferFrom1Final; bufferTo1Final];

    newBuf1 = [b1Final(:,1)];
    
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
    
    move1 = newBuf1;
end