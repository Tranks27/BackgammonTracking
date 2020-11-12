clc;
clear;

% set up camera for hand tracking, Outputs = objects
[cam, videoPlayer, videoPlayer2, foregroundDetector, ...
    blobAnalysis] = setup_cam_for_handtracking();

runLoop = true;
while runLoop
    
    % Get the next frame.
    videoFrame = snapshot(cam);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    hand_flag = track_hands(videoFrame, videoPlayer, videoPlayer2, foregroundDetector, blobAnalysis);
    
    disp(hand_flag);
    %%%%%%%% Do image processing here %%%%%%%%%%%
    
    
    %%%%%%%%%%%%%%%%%%%%
    % Check whether the video player window has been closed.
    runLoop = isOpen(videoPlayer); 
end

release(videoPlayer);
release(videoPlayer2);