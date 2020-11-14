function [foregroundDetector, blobAnalysis] = init_handtracking_video(videoReader, tform_param, crop_rectangle)
    foregroundDetector = vision.ForegroundDetector('NumGaussians',3,... 
        'NumTrainingFrames',50);
    blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
        'AreaOutputPort', false, 'CentroidOutputPort', false, ....
        'MinimumBlobArea', 2000);

    for i = 1:50
        trainFrame = readFrame(videoReader);
        % Correct the perspective of the frame
        perspective_correct = imtransform(trainFrame, tform_param);
        trainFrame = imcrop(perspective_correct, crop_rectangle);
        % Detect the foreground mask
        foreground = step(foregroundDetector,trainFrame);
    end

    % Optimal learning rate to determine how quickly it adapts to changing
    % conditions
    foregroundDetector.LearningRate = 0.02;
end