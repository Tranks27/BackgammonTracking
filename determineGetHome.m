function movable = determineGetHome(turn, idMatFull, pieces)

    interestMat = zeros(1, 18);
    interestQuad = zeros(1, 6);
    interestPieces = zeros(1, 6);
    if turn == 1
        interestMat = idMatFull(7:24);
        interestQuad = idMatFull(1:6);
        interestPieces = pieces(1:6);
    else
        interestMat = idMatFull(1:18);
        interestQuad = idMatFull(19:24);
        interestPieces = pieces(19:24);
    end
    
    count = 0;
    for i = 1:length(interestMat)
        
        if interestMat(i) == turn
            
            count = count + 1;
        end
    end
    pieceCount = 0;
    for i = 1:length(interestPieces)
        
        if interestMat(i) == turn
            
            pieceCount = pieceCount + interestPieces(i);
        end
    end
    
    if count == 0 && pieceCount == 15
        
        movable = 1;
    else
        
        movable = 0;
    end
end