function secondFlag = secondMovement(pieces, piecesSecond, move1)

    secondFlag = 0;

    changePieces = piecesSecond - pieces;
    from = changePieces == -1;
    to = changePieces == 1;

    flagLegal = 0;
    % Check for second roll
    for i = 1:length(move1(1,:))
        if move1(:,i) == [from;to]
            flagLegal = 1;
            secondFlag = 1;
        end
    end
    % check if illegal
%     if flagLegal == 0
%         fprintf('Illegal Move! Please Move Again.\n');
%     end

    secondFlag = 1;
end