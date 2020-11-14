function [dice_result] = read_die(cropped_dice_im)
% Author: Josiah
% This function takes an image of one dice and outputs the result

    % Use the segment function to segment out dice
    segmented_dice = hard_dice_face(cropped_dice_im);
    

    % Morphologically apply a filter on the image to dilate the pips
    struct_elem = strel('square',2);
    morph = imdilate(segmented_dice,struct_elem);
    
    padded_dice_im = padarray(morph,[2,2],0, 'both');

   

    % Count the shapes and their pixel areas
    find_shapes = bwconncomp(~padded_dice_im);
    get_pixels = cellfun(@numel,find_shapes.PixelIdxList);
    
    % Get the areas of all the shapes through regionprops
    get_pix_area = regionprops(find_shapes,'Area');

    % Create a label matrix from the BWCONNCOMP
    label_matrix_dice = labelmatrix(find_shapes);

    find_min = min(get_pixels);
    
    if(find_min < 6)
       find_min = 10; 
    end
    % Find the pips that are roughly the same size (based off smallest
    % object)
    find_shapes = ismember(label_matrix_dice, find(([get_pix_area.Area]<=find_min*2.5)));

%     figure
%     clf;
%     imshow(~find_shapes)
    
    % Count the final result on the dice
    count_final = bwconncomp(find_shapes);
    
	dice_result = count_final.NumObjects;

   
 end