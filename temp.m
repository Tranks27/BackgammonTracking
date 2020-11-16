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
% camera calibration
cam.Resolution = '1280x720';
cam.ExposureMode= 'manual';
cam.Exposure = -7;
cam.WhiteBalanceMode = 'manual';
cam.WhiteBalance = 5000;
cam.Zoom= 0;
cam.Contrast= 10;
cam.BacklightCompensation= 1;
cam.Sharpness= 50;
cam.Brightness= 255;
cam.Saturation= 30;
cam.Tilt= 0;
cam.Pan= 0;

% Calibrate for perspective change and cropping
sampleFrame = snapshot(cam);
[tform_param, crop_rectangle] = calibrate_perspective(sampleFrame);
    
for i = 56:80
    frame = snapshot(cam);
    perspective_correct = imtransform(frame, tform_param);
    frame = imcrop(perspective_correct, crop_rectangle);

    fileName = strcat(num2str(i),'.png');
    imwrite(frame,fileName);
    disp(fileName);
    pause;
end
%%%%%%%%%%%%%%%%%%%%%%%