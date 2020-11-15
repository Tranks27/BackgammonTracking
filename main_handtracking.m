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
videoPlayer = vision.VideoPlayer('Position', [70 70 crop_rectangle(3) crop_rectangle(4)]);
videoPlayer2 = vision.VideoPlayer('Position', [50 50 crop_rectangle(3) crop_rectangle(4)]);

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
    disp(hand_flag);
    
    % Display the annotated video frame using the video player object.
    step(videoPlayer, result);
    step(videoPlayer2, bw);
    
    %%%%%%%% Do image processing here %%%%%%%%%%%
    % Use the videoFrame for the current cropped image
    while hand_flag == 0
        
        [move_array, dice_position] =  get_dice_results(videoFrame);

        % display bouding boxes on die
        result_dice = insertShape(videoFrame, 'Rectangle', dice_position, 'Color', 'red'); 
        step(videoPlayer, result_dice);

        hand_flag = 1;
    end
    
    %%%%%%%%%%%%%%%%%%%%
    
    % Check whether the video player window has been closed.
    runLoop = isOpen(videoPlayer); 
end

release(videoPlayer);
release(videoPlayer2);