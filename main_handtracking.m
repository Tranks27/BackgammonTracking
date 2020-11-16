clc;
clear;
% Using live cam
cam = webcam(2);
% camera calibration
cam.Resolution = '1280x720';
cam.ExposureMode= 'manual';
cam.Exposure = -7;
cam.WhiteBalanceMode = 'manual';
cam.WhiteBalance = 5000;
cam.Zoom= 0;
cam.Contrast= 10;
cam.BacklightCompensation= 1;
cam.Sharpness= 50;
cam.Brightness= 255;
cam.Saturation= 30;
cam.Tilt= 0;
cam.Pan= 0;

% Calibrate for perspective change and cropping
sampleFrame = snapshot(cam);
[tform_param, crop_rectangle] = calibrate_perspective(sampleFrame);

% set up objects for hand tracking
[foregroundDetector, blobAnalysis] = init_handtracking(cam, tform_param, crop_rectangle);

% Create the video player object.
videoPlayer = vision.VideoPlayer('Position', [100 100 crop_rectangle(3) crop_rectangle(4)]);
videoPlayer2 = vision.VideoPlayer('Position', [100 100 crop_rectangle(3) crop_rectangle(4)]);

% Correct the perspective of the camera
perspective_correct = imtransform(sampleFrame, tform_param);
sampleFrame = imcrop(perspective_correct, crop_rectangle);

% initiate checkers detection
boardSet = 0;
while boardSet == 0
    % Get the next frame.
    videoFrame = snapshot(cam);
    % Correct the perspective of the camera
    perspective_correct = imtransform(videoFrame, tform_param);
    videoFrame = imcrop(perspective_correct, crop_rectangle);
    [a,b, boardSet] = initialStage(videoFrame);
end

turn_count = 0;
% White starts first
turn_player = 1;

% ID matrices and pieces
id_Matrix = [];
pieces_Matrix = [];
move_1 = [];
move_1p = [];

runLoop = true;
while runLoop
    
    % Get the next frame.
    videoFrame = snapshot(cam);
    % Correct the perspective of the camera
    perspective_correct = imtransform(videoFrame, tform_param);
    videoFrame = imcrop(perspective_correct, crop_rectangle);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Detect the hand from the frame
    [result, bw, hand_flag] = track_hands(videoFrame, foregroundDetector, blobAnalysis);
%     disp(hand_flag);
    
    % Display the annotated video frame using the video player object.
    step(videoPlayer, result);
    step(videoPlayer2, bw);
    
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
            
        end
    end
    
    % While no motion is detected, keep on detecting
    while hand_flag == 0 && runLoop
        %%%%%%%%%%%%% do nothing%%%%%%%%%%%%%%%%
        
        videoFrame = snapshot(cam);
        % Correct the perspective of the camera
        perspective_correct = imtransform(videoFrame, tform_param);
        videoFrame = imcrop(perspective_correct, crop_rectangle);
        
        [result, bw, hand_flag] = track_hands(videoFrame, foregroundDetector, blobAnalysis);
        
        % Check whether the video player window has been closed.
        runLoop = isOpen(videoPlayer); 
    end
    %%%%%%%%%%%%%%%%%%%%
    
    % Check whether the video player window has been closed.
    runLoop = isOpen(videoPlayer); 
end

release(videoPlayer);
release(videoPlayer2);