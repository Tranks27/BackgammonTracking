function boardStatus = initiateBoard(idMatFull, pieces)

    initialBoardID = [2 0 0 0 0 1 ...
                        0 1 0 0 0 2 ...
                        1 0 0 0 2 0 ...
                        2 0 0 0 0 1];
    initialBoardPieces = [2 0 0 0 0 5 ...
                            0 3 0 0 0 5 ...
                            5 0 0 0 3 0 ...
                            5 0 0 0 0 2];

                        
%     if initialBoardPieces == pieces
%         
%         disp(0);
%     end
    if initialBoardID == idMatFull
        
        boardStatus = 1;
    else
        
        boardStatus = 0;
    end
end