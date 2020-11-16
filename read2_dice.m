function [dice_result1, dice_result2] = read2_dice(cropped_dice_im)
% Author: Josiah
% This function takes an image of two dice and outputs the results
% Modified code from  https://au.mathworks.com/matlabcentral/answers/364870-count-dots-on-dice-wich-are-connected

    % Use the segment function to segment out dice
    segmented_dice = hard_dice_face(cropped_dice_im);

    
    % Expand the image so that there are more pixels to work with
    segmented_dice = imresize(segmented_dice,30);
    

    % Morphologically apply a filter on the image to dilate the pips
    struct_elem = strel('disk',50);
    morph = imdilate(segmented_dice,struct_elem);
    
    struct_elem2 = strel('disk',5);
    morph = imerode(morph,struct_elem2);
    
    % Pad the dice so that the outside "corners" get connected into one big
    % shape (easier to filter later)
    padded_dice_im = padarray(morph,[60,60],0, 'both');

%     figure(15)
%     imshow(~padded_dice_im);
%     
    % Count the shapes and their pixel areas
    find_shapes = bwconncomp(~padded_dice_im);
    get_pixels = cellfun(@numel,find_shapes.PixelIdxList)

    % Get the areas of all the shapes through regionprops
    get_pix_area = regionprops(find_shapes,'Area');

    % Create a label matrix from the BWCONNCOMP
    label_matrix_dice = labelmatrix(find_shapes);

    % Find the pips that are roughly the same size (based off smallest
    % object)
    find_shapes = ismember(label_matrix_dice, find(([get_pix_area.Area]<=min(get_pixels)*100)));

    % Count the final result on the dice
    count_final = bwconncomp(find_shapes);
    
    % Source code: https://au.mathworks.com/matlabcentral/answers/364870-count-dots-on-dice-wich-are-connected
    % Calculate centroid for each dot
    stats = struct2table(regionprops(find_shapes,'Centroid'));
    
    % Ensure that there is enough datapoints for Kmeans (ie. more than 2)
    % If so, proceed. If not, return NaN for die rolls
    if(length(stats.Centroid(:,1)) < 2)
           dice_result1 = NaN;
           dice_result2 = NaN;
           return;
    else
        % Clustering dots by k-means
        cluster_idx = kmeans(stats.Centroid,2);
    end

    % Count using a histogram counter method
    [num] = histcounts(cluster_idx,2);
    
    dice_result1 = num(1);
    
    dice_result2 = num(2);
  
   
 end