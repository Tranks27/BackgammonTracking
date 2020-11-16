function finished = checkFinished(idMatFull)

    whiteCheck = idMatFull == 1;
    brownCheck = idMatFull == 2;
    
    if sum(whiteCheck) == 0
        finished = 1;
        return;
    elseif sum(brownCheck) == 0
        finished = 2;
        return;
    end
    
    finished = 0;
end