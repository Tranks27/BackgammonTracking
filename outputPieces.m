function [idMat, piecesMat] = outputPieces()

    filename = strcat('trial.png');
    image = imread(filename);
    
    imgray = rgb2gray(image);
    imHSV = rgb2hsv(image);

    [row, col] = size(imgray);
    [newRow, newCol] = size(imHSV(:,:,1));
    
    for j = 1:newRow
        for k = 1:newCol
            
            % White -> Black
            if imHSV(j,k,3) > 0.6
                
                imHSV(j,k,:) = 0;
            end
            
            % Brown -> White
            if imHSV(j,k,1) < 22.5/180 && imHSV(j,k,2) < 0.3 && imHSV(j,k,3) > 0.35
                
                imHSV(j,k,2) = 0;
                imHSV(j,k,3) = 1;
            end
        end
    end
        
    %figure();
    trial = hsv2rgb(imHSV);
    trial = rgb2gray(trial);
    %trial = imcomplement(trial);
    
    %trial = rgb2gray(trial);
    trial = histeq(trial);
    %imshow(trial);
    
    se = strel('disk',20,4);
    im2 = imdilate(trial,se);
    im2 = imerode(trial,se);
    im2 = imopen(trial,se);
    im2 = imclose(trial,se);
    im2 = double(im2);
    
    im2 = trial .* im2;
    
    %imshow(im2);
    
    
    if row > col
        
        radMin = 20;
        radMax = 25;
    else
        
        radMin = 30;
        radMax = 35;
    end

    [centersWhite,radiiWhite] = imfindcircles(imgray,[radMin radMax],...
        'ObjectPolarity','bright','Sensitivity',0.96);
    [centersBrown,radiiBrown] = imfindcircles(trial, ...
        [radMin-3 radMax],'ObjectPolarity','bright', ...
    'Sensitivity',0.965);
    [centersBrown2,radiiBrown2] = imfindcircles(image, ...
        [radMin radMax],'ObjectPolarity','dark', ...
    'Sensitivity',0.97);

    [newBrownCoords, newBrownRad] = deleteRedundency(centersWhite, ...
                                radiiWhite, centersBrown, radiiBrown);
    [newBrownCoords, newBrownRad] = deleteDoubleDetected(newBrownCoords, ...
                                newBrownRad);
    newBrownCoords = [newBrownCoords;centersBrown2];
    newBrownRad = [newBrownRad;radiiBrown2];
    
    % Q1: Black Home Q4: White Home
    % qX = [q1xMin q1xMax
    %       q2xMin q2xMax
    %       q3xMin q3xMax
    %       q4xMin q4xMax

    qX = zeros(4, 2);
    qY = zeros(4, 2);
    if row > col

        x1 = round(col/8);
        x2 = round(row/50);
        y1 = round(row/12);
        y2 = round(row/46);

        qX(1,:) = [y2 + 1, col/2 - y1 - 1];
        qY(1,:) = [row/2 + x2 + 1, row - x1];
        qX(2,:) = [y2 + 1, col/2 - y1 - 1];
        qY(2,:) = [x1 + 1, row/2 - x2 - 1];
        qX(3,:) = [col/2 + y1 + 1, col - y2];
        qY(3,:) = [x1 + 1, row/2 - x2 - 1];
        qX(4,:) = [col/2 + y1 + 1, col - y2];
        qY(4,:) = [row/2 + x2 + 1, row - x1];
    else

        x1 = round(row/8);
        x2 = round(col/50);
        y1 = round(col/12);
        y2 = round(col/46);

        qX(1,:) = [y2 + 1, row/2 - y1 - 1];
        qY(1,:) = [col/2 + x2 + 1, col - x1 - 1];
        qX(2,:) = [y2 + 1, row/2 - y1 - 1];
        qY(2,:) = [x1 + 1, col/2 - x2 - 1];
        qX(3,:) = [row/2 + y1 + 1, row - y2 - 1];
        qY(3,:) = [x1 + 1, col/2 - x2 - 1];
        qX(4,:) = [row/2 + y1 + 1, row - y2 - 1];
        qY(4,:) = [col/2 + x2 + 1, col - x1 - 1];
    end

    % All quadrants
    % idMatrix indicates which piece is in each place
    % 0 = No pieces
    % 1 = White
    % 2 = Brown
    idMatrix = zeros(4, 6);
    q1 = zeros(6,5);
    q2 = zeros(6,5);
    q3 = zeros(6,5);
    q4 = zeros(6,5);

    % Q1
    incCol = diff(qX(1,:))/5;
    incRow = diff(qY(1,:))/6;
    for i = 1:6

        rowMin = qY(1,1) + incRow*(i - 1);
        rowMax = qY(1,1) + incRow*i;

        for j = 1:5

            colMin = qX(1,1) + incCol*(j - 1);
            colMax = qX(1,1) + incCol*j;

            rY = [rowMin rowMin rowMax rowMax]';
            rX = [colMin colMax colMax colMin]';

            for k = 1:length(radiiWhite)

                if inpolygon(centersWhite(k,1), centersWhite(k,2), rX, rY)
                    idMatrix(1,i) = 1;
                    q1(i,j) = 1;
                end
            end
            for k = 1:length(newBrownRad)

                if inpolygon(newBrownCoords(k,1), newBrownCoords(k,2), rX, rY)
                    idMatrix(1,i) = 2;
                    q1(i,j) = 1;
                end
            end
        end
    end

    % Q2
    incCol = diff(qX(2,:))/5;
    incRow = diff(qY(2,:))/6;
    for i = 1:6

        rowMin = qY(2,1) + incRow*(i - 1);
        rowMax = qY(2,1) + incRow*i;

        for j = 1:5

            colMin = qX(1,1) + incCol*(j - 1);
            colMax = qX(1,1) + incCol*j;

            rY = [rowMin rowMin rowMax rowMax]';
            rX = [colMin colMax colMax colMin]';

            for k = 1:length(radiiWhite)

                if inpolygon(centersWhite(k,1), centersWhite(k,2), rX, rY)
                    idMatrix(2,i) = 1;
                    q2(i,j) = 1;
                end
            end
            for k = 1:length(newBrownRad)

                if inpolygon(newBrownCoords(k,1), newBrownCoords(k,2), rX, rY)
                    idMatrix(2,i) = 2;
                    q2(i,j) = 1;
                end
            end
        end
    end

    % Q3
    incCol = diff(qX(3,:))/5;
    incRow = diff(qY(3,:))/6;
    for i = 1:6

        rowMin = qY(3,1) + incRow*(i - 1);
        rowMax = qY(3,1) + incRow*i;

        for j = 1:5

            colMin = qX(3,1) + incCol*(j - 1);
            colMax = qX(3,1) + incCol*j;

            rY = [rowMin rowMin rowMax rowMax]';
            rX = [colMin colMax colMax colMin]';

            for k = 1:length(radiiWhite)

                if inpolygon(centersWhite(k,1), centersWhite(k,2), rX, rY)
                    idMatrix(3,i) = 1;
                    q3(i,j) = 1;
                end
            end
            for k = 1:length(newBrownRad)

                if inpolygon(newBrownCoords(k,1), newBrownCoords(k,2), rX, rY)
                    idMatrix(3,i) = 2;
                    q3(i,j) = 1;
                end
            end
        end
    end

    % Q4
    incCol = diff(qX(4,:))/5;
    incRow = diff(qY(4,:))/6;
    for i = 1:6

        rowMin = qY(4,1) + incRow*(i - 1);
        rowMax = qY(4,1) + incRow*i;

        for j = 1:5

            colMin = qX(4,1) + incCol*(j - 1);
            colMax = qX(4,1) + incCol*j;

            rY = [rowMin rowMin rowMax rowMax]';
            rX = [colMin colMax colMax colMin]';

            for k = 1:length(radiiWhite)

                if inpolygon(centersWhite(k,1), centersWhite(k,2), rX, rY)
                    idMatrix(4,i) = 1;
                    q4(i,j) = 1;
                end
            end
            for k = 1:length(newBrownRad)

                if inpolygon(newBrownCoords(k,1), newBrownCoords(k,2), rX, rY)
                    idMatrix(4,i) = 2;
                    q4(i,j) = 1;
                end
            end
        end
    end

    idMatrix(1:2,:) = idMatrix(1:2,end:-1:1);
    q1 = q1(end:-1:1,:);
    q2 = q2(end:-1:1,:);
    q3 = q3(:,end:-1:1);
    q4 = q4(:,end:-1:1);

    quadrants = [q1;q2;q3;q4];

    for i = 1:24

        for j = 5:-1:1

            if sum(quadrants(i,:)) >= 1 && quadrants(i,j) ~= 0

                quadrants(i,1:j) = ones(1, j);
            end
        end
    end

    s = reshape(sum(quadrants,2),6,4)';
    idMatFull = [idMatrix(1,:) idMatrix(2,:) idMatrix(3,:) idMatrix(4,:)];
    pieces = sum(quadrants,2)';
    
    idMat = idMatFull;
    piecesMat = pieces;
end