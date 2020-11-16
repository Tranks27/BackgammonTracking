function boardStatus = initiateBoard(idMatFull, pieces)

    initialBoardID = [2 0 0 0 0 1 ...
                        0 1 0 0 0 2 ...
                        1 0 0 0 2 0 ...
                        2 0 0 0 0 1];
    initialBoardPieces = [2 0 0 0 0 5 ...
                            0 3 0 0 0 5 ...
                            5 0 0 0 3 0 ...
                            5 0 0 0 0 2];

    if initialBoardID ~= idMatFull
        
        boardStatus = 0;
        return;
    end
    if initialBoardPieces ~= pieces
        
        boardStatus = 0;
        return;
    end
    
    boardStatus = 1;
end