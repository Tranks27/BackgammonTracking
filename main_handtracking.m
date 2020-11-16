clc;
clear;
% Using live cam
cam = webcam(2);
cam.Resolution = '1280x720';

% Calibrate for perspective change and cropping
sampleFrame = snapshot(cam);
[tform_param, crop_rectangle] = calibrate_perspective(sampleFrame);

% set up objects for hand tracking
[foregroundDetector, blobAnalysis] = init_handtracking(cam, tform_param, crop_rectangle);

% Create the video player object.
videoPlayer = vision.VideoPlayer('Position', [100 100 crop_rectangle(3) crop_rectangle(4)]);
videoPlayer2 = vision.VideoPlayer('Position', [100 100 crop_rectangle(3) crop_rectangle(4)]);


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