function [idMatFull, pieces] = initialStage(videoFrame)

    boardSetup = 0;

    while boardSetup == 0

        image = videoFrame;
        cropBackground(image);
        [idMatFull, pieces] = outputPieces();
        boardSetup = initiateBoard(idMatFull, pieces);
        
        if boardSetup == 0
            
            disp('Error! Initial Setup Not Detected. \n');
        else
            
            disp('Initiation Successful.\n');
        end
    end
end