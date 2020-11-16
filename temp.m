%% Test stuff
% for i = 1:150
%     frame = snapshot(cam);
%     foreground = step(foregroundDetector,frame);
% end
% 
% figure; imshow(frame);
% figure; imshow(foreground);
% 
% se = strel('square', 3);
% filteredForeground = imopen(foreground, se);
% figure; imshow(filteredForeground); title('Clean Foreground');
%%%%%%%%%%%%%%%%%%%

%% Get snapshot samples
clc;
clear;
% Using live cam
cam = webcam(2);
cam.Resolution = '1280x720';

% Calibrate for perspective change and cropping
sampleFrame = snapshot(cam);
[tform_param, crop_rectangle] = calibrate_perspective(sampleFrame);
    
for i = 11:20
    frame = snapshot(cam);
    perspective_correct = imtransform(frame, tform_param);
    frame = imcrop(perspective_correct, crop_rectangle);

    fileName = strcat(num2str(i),'.png');
    imwrite(frame,fileName);
    disp(fileName);
    pause;
end
%%%%%%%%%%%%%%%%%%%%%%%