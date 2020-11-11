function [hand_flag] = track_hands(videoFrame, videoPlayer, ...
    videoPlayer2, foregroundDetector, blobAnalysis)
    
    % create kernals for mophological operations
    k = strel('square',4);
    k2 = strel('square',15);
    
    % Detect foreground in the current video frame
    foreground_mask = step(foregroundDetector,videoFrame); 
    % Filter noise by morphological operation
    filteredForeground = imopen(foreground_mask,k); 
    filteredForeground = imclose(filteredForeground,k2);
    
    % Masking (just for display, not used afterwards)
    bw = imbinarize(uint8(filteredForeground));
    % Detect blobs with min area and compute bounding boxes
    bbox = step(blobAnalysis, filteredForeground); 
    
    if length(bbox) > 1
        hand_flag = 1; % Busy (hand detected)
    else
        hand_flag = 0; % Free
    end
    
    % Draw bounding boxes
    result = insertShape(videoFrame, 'Rectangle', bbox, 'Color', 'green'); 
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    % Display the annotated video frame using the video player object.
    step(videoPlayer, result);
    step(videoPlayer2, bw);
    
end