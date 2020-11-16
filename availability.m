function [avMat, unavMat] = availability(idMatFull, pieces, turn)

    available = [];
    unavailable = [];
    for i = 1:length(idMatFull)

        if turn == 1

            if idMatFull(i) == 1
                available = [available i];
            elseif idMatFull(i) == 2 && pieces(i) >= 2
                unavailable = [unavailable i];
            end

        elseif turn == 2 

            if idMatFull(i) == 2
                available = [available i];
            elseif idMatFull(i) == 1 && pieces(i) >= 2
                unavailable = [unavailable i];
            end
        end
    end
    
    avMat = available;
    unavMat = unavailable;
end