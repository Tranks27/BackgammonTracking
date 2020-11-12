function [cam, videoPlayer, videoPlayer2, foregroundDetector, blobAnalysis] = setup_cam_for_handtracking()
    % Using live cam
    cam = webcam(2);
    cam.Resolution = '1280x720';
    % determine frame size
    videoFrame = snapshot(cam);
    frameSize = size(videoFrame);
    % Create the video player object.
    videoPlayer = vision.VideoPlayer('Position', [1 1 [frameSize(2), frameSize(1)]]);
    videoPlayer2 = vision.VideoPlayer('Position', [1 1 [frameSize(2), frameSize(1)]]);

    foregroundDetector = vision.ForegroundDetector('NumGaussians',3,...
        'NumTrainingFrames',100);

    % Create blob anaylysis object
    blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
        'AreaOutputPort', false, 'CentroidOutputPort', false, ....
        'MinimumBlobArea', 2000);

    % Train the model with first 150 frames of background
    for i = 1:100
        frame = snapshot(cam);
        foreground_mask = step(foregroundDetector,frame);
    end

    % Optimal learning rate to determine how quickly it adapts to changing
    % conditions
    foregroundDetector.LearningRate = 0.02;

end