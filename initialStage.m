function [idMatFull, pieces] = initialStage(videoFrame)

    boardSetup = 0;

    while boardSetup == 0

        buffer = videoFrame;
        r = buffer(:,end:-1:1,1)';
        g = buffer(:,end:-1:1,2)';
        b = buffer(:,end:-1:1,3)';
        image = cat(3, r, g, b);
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