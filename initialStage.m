function initialStage(videoFrame)

    boardSetup = 0;

    while boardSetup == 0

        image = videoFrame;
        cropBackground(image);
        [idMatFull, pieces] = outputPieces();
        boardSetup = initiateBoard(idMatFull, pieces);
    end
end