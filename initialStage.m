function [idMatFull, pieces, boardSetup] = initialStage(videoFrame)

    boardSet = 0;

    buffer = videoFrame;
    r = buffer(end:-1:1,:,1)';
    g = buffer(end:-1:1,:,2)';
    b = buffer(end:-1:1,:,3)';
    image = cat(3, r, g, b);
    cropBackground(image);
    [idMatFull, pieces] = outputPieces();
    boardSet = initiateBoard(idMatFull, pieces);

    if boardSet == 0
        boardSetup = 0;
        disp('Error! Initial Setup Not Detected.');
    else
        boardSetup = 1;
        disp('Initiation Successful.');
    end
end