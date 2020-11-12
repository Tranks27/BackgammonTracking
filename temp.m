%%%%%%%%%%%Test stuff
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