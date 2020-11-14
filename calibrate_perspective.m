function [tform_param, crop_rectangle] = calibrate_perspective(initial_frame)
% Read the image
perspective_im = initial_frame;

figure(1)
imshow(perspective_im);
title("Please select the 4 corners of the board.");

calibrate=1;
if(calibrate == 1)
num_corners = 0;

while(num_corners ~= 4)
    
    [receive_x, receive_y] = getpts;

    corners = [receive_x,receive_y];

    [num_corners, corner_dimension] = size(corners);

    if(num_corners ~= 4)
        fprintf("Error: %d point/s detected. Number of points must equal 4. Please try again.\n", num_corners);
        figure(1)
        title(["Error: Incorrect number of points. Number of points must equal 4. Please try again."]);

    else
        fprintf("Success. Perspective changed.\n"); 
    end
    
end

for corner_sort = 1:4
    corner_dist(corner_sort,1) = sqrt(corners(corner_sort, 1)^2 + corners(corner_sort, 2)^2);
end

[adj_corners, index_corners] = sort(corner_dist, 'ascend');

% Check to see the top right and bottom left corner distances to determine corner 2 and 3
if(corners(index_corners(2),1)<corners(index_corners(3),1))
    save_3 = index_corners(3);
    index_corners(3) = index_corners(2);
    index_corners(2) = save_3;
end

% Sort the corners so that it doesn't matter which order the user clicks
sorted_corners = corners(index_corners, :);
corners = sorted_corners;

% Calculate the average of the top, left, right and bottom edges
mid_left = (corners(1,1) + corners(3,1))/2;
mid_right = (corners(2,1)+corners(4,1))/2;
mid_top = (corners(1,2)+corners(2,2))/2;
mid_bot = (corners(3,2)+corners(4,2))/2;

% Create a transformation to what the final rectangle should be
corners_transform = [mid_left,mid_top;mid_right,mid_top;mid_left,mid_bot;mid_right,mid_bot];
tform = maketform('projective', corners, corners_transform);
tform_param = tform;

% Correct the perspective of the camera
perspective_correct = imtransform(perspective_im, tform);

clf;
figure(1)
imshow(perspective_correct);
title("Please crop the image to include the edges of the board.")

[perspective_crop, crop_rectangle] = imcrop(perspective_correct);
 

end
end

