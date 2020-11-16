clc;
clear;

path_name = 'C:\Users\might\Desktop\Year 4 Sem 2\AMME4710\Major Project\Assets\';
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

    
    
    

