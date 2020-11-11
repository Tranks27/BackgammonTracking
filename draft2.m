clc;
clear;

% Using recorded video
path_name = 'C:\Users\might\Desktop\Year 4 Sem 2\AMME4710\Major Project\Assets\AMME4710_majorProject\';
video_name = '1.avi';
videoSource = VideoReader(strcat(path_name,video_name));

% Create the video player object.
videoPlayer = vision.VideoPlayer('Position', [1 1 [1088, 1920]+30]);

foregroundDetector = vision.ForegroundDetector('NumGaussians',3,...
    'NumTrainingFrames',50);

% Create blob anaylysis object
blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
    'AreaOutputPort', false, 'CentroidOutputPort', false, ....
    'MinimumBlobArea', 300);

k = strel('square',3);

% Train the model with first 10 frames of background
for i = 1:50
    frame = readFrame(videoSource);
    foreground = step(foregroundDetector,frame);
end
frameSize = size(frame);
% Optimal learning rate to determine how quickly it adapts to changing
% conditions
foregroundDetector.LearningRate = 0.02;
frameCnt = 0;
while hasFrame(videoSource) && frameCnt < 200
    videoFrame = readFrame(videoSource);
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Detect foreground in the current video frame
    foreground = step(foregroundDetector,videoFrame); 
    % Filter noise by morphological operation
    filteredForeground = imopen(foreground,k); 
    % Detect blobs with min area and compute bounding boxes
    bbox = step(blobAnalysis, filteredForeground); 
    
    % Draw bounding boxes
    result = insertShape(videoFrame, 'Rectangle', bbox, 'Color', 'green'); 
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    % Display the annotated video frame using the video player object.
    step(videoPlayer, result);
    
    frameCnt = frameCnt + 1;
    
end


release(videoPlayer);
