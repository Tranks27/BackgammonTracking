clc;
clear;

path_name = 'C:\Users\might\Desktop\Year 4 Sem 2\AMME4710\Major Project\Assets\';
video_name = 'demo1.MOV';
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
    frame = readFrame(videoReader); 
    % Correct the perspective of the frame
    perspective_correct = imtransform(frame, tform_param);
    frame = imcrop(perspective_correct, crop_rectangle);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Detect the hand from the frame
    [result, bw, hand_flag] = track_hands(frame, foregroundDetector, blobAnalysis);
    
    % display results
    step(videoPlayer, result); 
    
    while hand_flag == 0
        [move_array, dice_position] =  get_dice_results(frame);
        
        % display bouding boxes on die
        result_dice = insertShape(frame, 'Rectangle', dice_position, 'Color', 'red'); 
        step(videoPlayer, result_dice);
        
        hand_flag = 1;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    runLoop = isOpen(videoPlayer); 
end

release(videoPlayer);

    
    
    

