clc;
clear;

path_name = 'Assets\';
video_name = 'webcam2.mp4';
source_name = strcat(path_name,video_name);
% Load the video
videoReader = VideoReader(source_name);

% Calibrate for perspective change and cropping
sampleFrame = readFrame(videoReader);
[tform_param, crop_rectangle] = calibrate_perspective(sampleFrame);

% set up objects for hand tracking
[foregroundDetector, blobAnalysis] = init_handtracking_video(videoReader, ...
    tform_param, crop_rectangle);

% Create the video player object.
videoPlayer = vision.VideoPlayer('Position', crop_rectangle);

%%%%%%% Requirements for checkers detection
% Correct the perspective of the camera
perspective_correct = imtransform(sampleFrame, tform_param);
sampleFrame = imcrop(perspective_correct, crop_rectangle);

% initiate checkers detection
boardSet = 0;
while boardSet == 0
    % Get the next frame.
    videoFrame = readFrame(videoReader);
    % Correct the perspective of the camera
    perspective_correct = imtransform(videoFrame, tform_param);
    videoFrame = imcrop(perspective_correct, crop_rectangle);
    [a,b, boardSet] = initialStage(videoFrame);
end

global movement
movement = 0;

recordedMoves = fopen('record.txt', 'w');
finalText = sprintf("Backgammon Transcript\nTournament Date: ");
t = datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss Z');
datestring = string(cellstr(t));
newL = sprintf("\n");
fwrite(recordedMoves, strcat(finalText,datestring,newL));
fclose(recordedMoves);


turn_count = 0;
% White starts first
turn_player = 1;

% ID matrices and pieces
id_Matrix = [];
pieces_Matrix = [];
move_1 = [];
move_1p = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
runLoop = true;
while hasFrame(videoReader) && runLoop
    
    % read the next frame
    videoFrame = readFrame(videoReader); 
    % Correct the perspective of the frame
    perspective_correct = imtransform(videoFrame, tform_param);
    videoFrame = imcrop(perspective_correct, crop_rectangle);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Detect the hand from the frame
    [result, bw, hand_flag] = track_hands(videoFrame, foregroundDetector, blobAnalysis);
    
    % display results
    step(videoPlayer, result); 
    
     %%%%%%%% Do image processing here %%%%%%%%%%%
    % if hand is not detected, initiate dice detection
    if hand_flag == 0
        pause(1); % wait for the dice to settle
        % Detect dice
        [move_array, dice_position] =  get_dice_results(videoFrame);
        % if no dice detected, continue detection process
        if isempty(move_array)
            disp("Dice not detected, throw the dice again");
        else
            % if dice is detected, draw bounding boxes on the dice
            disp(move_array);
            % display bouding boxes on die
            result_dice = insertShape(videoFrame, 'Rectangle', dice_position, 'Color', 'red'); 
            step(videoPlayer, result_dice);
            
            %%%%%%%checkers detection
            
            [finished_turn, turn_count, turn_player, id_Matrix, pieces_Matrix, move_1, move_1p] = tjPart(videoFrame, move_array, turn_count, turn_player, id_Matrix, pieces_Matrix, move_1, move_1p)
            % reset count
            turn_count = mod(turn_count, 3);
            if finished_turn == 1
                disp('next player');
                finished_turn = 0;
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%
        end
    end
    
    % While no motion is detected, keep on detecting
    while hand_flag == 0 && runLoop
        %%%%%%%%%%%%% do nothing%%%%%%%%%%%%%%%%
        
        videoFrame = readFrame(videoReader); 
        % Correct the perspective of the camera
        perspective_correct = imtransform(videoFrame, tform_param);
        videoFrame = imcrop(perspective_correct, crop_rectangle);
        
        [result, bw, hand_flag] = track_hands(videoFrame, foregroundDetector, blobAnalysis);
        
        % Check whether the video player window has been closed.
        runLoop = isOpen(videoPlayer); 
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    runLoop = isOpen(videoPlayer); 
end

release(videoPlayer);

    
    
    

