path_name = 'C:\Users\might\Desktop\Year 4 Sem 2\AMME4710\Major Project\Assets\';
video_name = '2.MOV';

foregroundDetector = vision.ForegroundDetector('NumGaussians',3,...
    'NumTrainingFrames',50);
% videoReader = VideoReader('visiontraffic.avi');
videoReader = VideoReader(strcat(path_name,video_name));

for i = 1:150
    frame = readFrame(videoReader);
    frame = imresize(frame,[640 480]);
    foreground = step(foregroundDetector,frame);
end

% figure; imshow(frame);
% figure; imshow(foreground);

se = strel('square', 3);
filteredForeground = imopen(foreground, se);
% figure; imshow(filteredForeground); title('Clean Foreground');

blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
    'AreaOutputPort', false, 'CentroidOutputPort', false, ....
    'MinimumBlobArea', 300);


videoPlayer = vision.VideoPlayer('Name','Detected Cars');
videoPlayer.Position(3:4) = [640 480];
% Kernal for morphological operations
k = strel('square',3);

while hasFrame(videoReader)
    frame = readFrame(videoReader); % read the next frame
    frame = imresize(frame,[640 480]);
    foreground = step(foregroundDetector,frame); % detect foreground in the current video frame
    
    filteredForeground = imopen(foreground,k); % filter noise by morphological operation
    
    bbox = step(blobAnalysis, filteredForeground); % detect blobs with min area and compute bounding boxes
    
    result = insertShape(frame, 'Rectangle', bbox, 'Color', 'green'); % Draw bounding boxes
    
    step(videoPlayer, result); % display results
end

    
    
    

