function [foregroundDetector, blobAnalysis] = init_handtracking(cam, tform_param, crop_rectangle)
    
    foregroundDetector = vision.ForegroundDetector('NumGaussians',3,...
        'NumTrainingFrames',50);

    % Create blob anaylysis object
    blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
        'AreaOutputPort', false, 'CentroidOutputPort', false, ....
        'MinimumBlobArea', 2000);

    % Train the model with first 100 frames of background
    for i = 1:50
        trainFrame = snapshot(cam);
        % Correct the perspective of the frame
        perspective_correct = imtransform(trainFrame, tform_param);
        trainFrame = imcrop(perspective_correct, crop_rectangle);
        % Detect the foreground mask
        foreground_mask = step(foregroundDetector,trainFrame);
    end

    % Optimal learning rate to determine how quickly it adapts to changing
    % conditions
    foregroundDetector.LearningRate = 0.02;

end