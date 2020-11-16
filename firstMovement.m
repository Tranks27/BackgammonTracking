function [firstFlag, secondFlag] = firstMovement(pieces, piecesFirst, move1, move1p)

    firstFlag = 0;
    secondFlag = 0;

    changePieces = piecesFirst - pieces;
    from = changePieces == -1;
    to = changePieces == 1;

    flagLegal = 0;
    % Check for first roll
    for i = 1:length(move1(1,:))
        if move1(:,i) == [from;to]
            flagLegal = 1;
            firstFlag = 1;
        end
    end
    % Check for one movement
    if flagLegal == 0
        for i = 1:length(move1p(1,:))
            if move1p(:,i) == [from;to]
                flagLegal = 1;
                firstFlag = 1;
                secondFlag = 1;
            end
        end
    end
    % check if illegal
    if flagLegal == 0
        fprintf('Illegal Move! Please Move Again.\n');
    end
end