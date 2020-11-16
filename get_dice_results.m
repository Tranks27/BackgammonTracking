function [move_array, dice_position] = get_dice_results(dice_im)

dice_im = cropBackgroundForDice(dice_im);

% figure(20)
% imshow(dice_im);

% Segment the dice according to the YcBcR colour space
segmented_dice = segment_dice(dice_im);
dice_record = [];
% Create a structuring element of size 3
struct_elem = strel('square',3);
process_im = imdilate(segmented_dice, struct_elem);

% Find the connected shapes
shape_second_die = bwconncomp(process_im);
get_num_pixels = cellfun(@numel,shape_second_die.PixelIdxList);

% Get the areas of all the shapes in the processed filtered image
dice_props_area = regionprops(shape_second_die,'Area');

% Create a label matrix from the BWCONNCOMP
label_matrix_dice = labelmatrix(shape_second_die);

% Remove shapes that are not in the bounds of 250-3700 px (standard die sizes
% +- 10% with one dice or 2 dice together) 
process_im = ismember(label_matrix_dice, find(([dice_props_area.Area]>=250 & [dice_props_area.Area]<=3700)));

% Create bounding boxes around each of the suspected dice shapess
dice_props = regionprops(process_im,'BoundingBox','Centroid');


% Find the connected shapes
find_pips = bwconncomp(~process_im);
get_num_pixels_pip = cellfun(@numel,shape_second_die.PixelIdxList);

% Get the areas of all the shapes in the processed filtered image
pip_props_area = regionprops(find_pips,'Area');

% Create a label matrix from the BWCONNCOMP
label_matrix_pips = labelmatrix(find_pips);

find_pips = ismember(label_matrix_pips, find(([pip_props_area.Area]<=40)));

pip_props = regionprops(find_pips,'Centroid');

num_matches_found = 0;

% For each bounding box, calculate the distance of each pip from the
% centroid of the bounding box. The closest indicates that they belong to
% dice. Record the index of that shape
for dice_idx = 1:length(dice_props)
    
    for pip_idx = 1:length(pip_props)
       
        pip_dist(dice_idx,pip_idx) = norm(pip_props(pip_idx).Centroid - dice_props(dice_idx).Centroid);
        
        if(pip_dist(dice_idx,pip_idx) <= 40)
            num_matches_found = num_matches_found+1;
            dice_record(num_matches_found) = [dice_idx];
        end
        
    end
    
end
%%%%%%%%%%%%%%%%%% Tranks' addition: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%% if no dice is detected, return empty arrays%%%%%%%%%%%%%
if isempty(dice_record)
    move_array = [];
    dice_position = [];
    return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find the most frequent dice index
[first_die,freq] = mode(dice_record);

% Remove the most frequent value (the first dice)
dice_record(dice_record == first_die) = [];

% Guess that the total number of objects will be 2 (in the case where two
% dice are separated)
dice_total_obj = 2;

% If there is no second dice identified, it means all pips belong to one
% shape and the two dice are together.
if(length(dice_record) == 0)
    dice_total_obj = 1;
end

% Find the second dice shape
[second_die, freq] = mode(dice_record);

extract_dice = bwconncomp(process_im);

% Create images of the first and second dice by removing all other shapes
generate_first_die = process_im;

if(dice_total_obj == 2)
    generate_second_die = process_im;
end

for remove_obj = 1:length(dice_props)
    if(remove_obj ~= first_die)
        generate_first_die(extract_dice.PixelIdxList{remove_obj}) = 0;
    end
    
    if(remove_obj ~= second_die && dice_total_obj == 2)
        generate_second_die(extract_dice.PixelIdxList{remove_obj}) = 0;
    end
end


% Make bounding boxes around the dice
show_dice = regionprops(generate_first_die,'BoundingBox');

if(dice_total_obj == 2)
    show_dice2 = regionprops(generate_second_die,'BoundingBox');
end


% Crop thie dice according to the bounding boxes
cropdie1 = imcrop(dice_im, show_dice.BoundingBox);


if(dice_total_obj == 2)
    cropdie2 = imcrop(dice_im, show_dice2.BoundingBox);
end

% If there is two separate dice, treat them as individual pieces. If they
% are together, analyse them together.
if(dice_total_obj == 2)
    first_die_result = read_die(cropdie1);
    second_die_result = read_die(cropdie2);
    dice_position = [show_dice.BoundingBox;show_dice2.BoundingBox];
    
elseif(dice_total_obj == 1)
    [first_die_result, second_die_result] = read2_dice(cropdie1);
    dice_position = [show_dice.BoundingBox; [0,0,0,0]];
 
end

% Logic to determine what moves are allowed and detect any errors
if(first_die_result > 6 || second_die_result > 6 || first_die_result + second_die_result < 2 || first_die_result + second_die_result > 12 )
   
   disp("Error with dice roll, please move dice to darker background or adjust camera position/lighting"); 
   
   move_array = [];
   
else
    
    move_array = sort([first_die_result, second_die_result],'descend');
    
end

% Return the position of the bounding boxes
%rectangle('Position',show_dice.BoundingBox, 'EdgeColor', 'r', 'LineWidth', 1.5);
    %rectangle('Position',show_dice2.BoundingBox, 'EdgeColor', 'r', 'LineWidth', 1.5);

end

