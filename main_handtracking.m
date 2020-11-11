clc;
clear;

% Using live cam
cam = webcam(2);
cam.Resolution = '1280x720';
% determine frame size
videoFrame = snapshot(cam);
frameSize = size(videoFrame);
% Create the video player object.
videoPlayer = vision.VideoPlayer('Position', [1 1 [frameSize(2), frameSize(1)]+30]);
videoPlayer2 = vision.VideoPlayer('Position', [1 1 [frameSize(2), frameSize(1)]+30]);

foregroundDetector = vision.ForegroundDetector('NumGaussians',3,...
    'NumTrainingFrames',100);

% Create blob anaylysis object
blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
    'AreaOutputPort', false, 'CentroidOutputPort', false, ....
    'MinimumBlobArea', 500);

k = strel('square',4);
k2 = strel('square',10);

% Train the model with first 150 frames of background
for i = 1:100
    frame = snapshot(cam);
    foreground = step(foregroundDetector,frame);
end

% Optimal learning rate to determine how quickly it adapts to changing
% conditions
foregroundDetector.LearningRate = 0.01;

runLoop = true;
frameCount = 0;
while runLoop
    
    % Get the next frame.
    videoFrame = snapshot(cam);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Detect foreground in the current video frame
    foreground = step(foregroundDetector,videoFrame); 
    % Filter noise by morphological operation
    filteredForeground = imopen(foreground,k); 
    filteredForeground = imclose(filteredForeground,k2);
    
    % Masking (just for display, not used afterwards)
    bw = imbinarize(uint8(filteredForeground));
    % Detect blobs with min area and compute bounding boxes
    bbox = step(blobAnalysis, filteredForeground); 
    
    if length(bbox) > 1
        disp('1'); % Busy (hand detected)
    else
        disp('0'); % Free
    end
    % Draw bounding boxes
    result = insertShape(videoFrame, 'Rectangle', bbox, 'Color', 'green'); 
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    % Display the annotated video frame using the video player object.
    step(videoPlayer, result);
    step(videoPlayer2, bw);
    
    % Check whether the video player window has been closed.
    runLoop = isOpen(videoPlayer);
    
end

release(videoPlayer);
release(videoPlayer2);