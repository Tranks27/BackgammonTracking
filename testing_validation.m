% Backgammon Tracking Program
% Author: Josiah Jagelman
% Date: 11 Nov, 2020


% Clear the workspace, command window and figures
%clear;
%clc;
%clf;

% Have a table of the true results in order
true_results_easy = [4,6;2,3;1,2;1,6;1,3;3,5;3,3;2,3; ...
    5,6;1,6;2,5;3,6;4,6;5,6;3,5;5,6;2,6;4,5;1,2;3,5; ...
    6,6;1,3;3,6;2,5;2,5;2,6;1,1;1,3;1,5;2,5;3,5;3,5; ...
    3,6;2,5;2,4];

true_results_hard = [1,3;3,4;3,4;2,5;1,2;1,6;6,6; ...
    3,4;3,4;4,6;4,4;3,6;1,4;5,6;4,4;1,1;1,4;1,4;1,1; ...
    1,6;5,5;4,6;5,5;4,5;];

% Store a variable for the start and finish of the count (for the numbering system)
start = 56;
finish = 79;

 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % TEST FOR EASY IMAGES % % % 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%
% % % % FIRST HALF  % % %
% %%%%%%%%%%%%%%%%%%%%%%%
% for count = start:finish
%     
%     
%     % Read the image
%     test_im = imread(['test_data1/easy/', num2str(count) ,'.png']);
% 
%     % Open a new figure starting at the count 
% %     figure(count-(start-1))
% %     clf;
% %     imshow(test_im);
% %     title(['Test #', num2str(count-(start-1))]);
% 
%     % Get the results of the dice
%     [move_array, dice_position] =  get_dice_results(test_im);
% 
%     % If the results return empty, store a NaN and 0 0 0 0 coordinate box
%     if isempty(move_array) 
%        move_array = [(NaN), (NaN)];
%        dice_position = [0,0,0,0;0,0,0,0];
%     end
%     
%     % Plot where the location of the dice are with a red box
% %     figure(count-(start-1))
% %     hold on;
% %     rectangle('Position',dice_position(1,:), 'EdgeColor', 'r', 'LineWidth', 1.5);
% %     rectangle('Position',dice_position(2,:), 'EdgeColor', 'r', 'LineWidth', 1.5);
% % 
% %     saveas(gcf,['test_data1/montage_easy/validation_result',num2str(count), '.png']);
% %     
%     % Store the results in an array called validation.
%     validation(count-(start-1),:) = sort(move_array(1:2), 'ascend');
% end
% 
% 
% % Compare the true results against the tested dataset
% compare = [true_results_easy,validation];
% 
% for count = start:finish
%     
%     % Mark the success index's as 1's and fails as 0's
%     if(compare(count-(start-1), 1) == compare(count-(start-1), 3) && compare(count-(start-1), 2) == compare(count-(start-1), 4))
%         success(count-(start-1),:) = [count-(start-1),1];
%         
%     else
%         success(count-(start-1),:) = [count-(start-1),0];
%     
%     end
% ends
% %%%%%%%%%%%%%%%%%%%%%%%
% % % % SECOND HALF % % %
% %%%%%%%%%%%%%%%%%%%%%%%
% % Calculate the indices of the success and fails
% success_items = find(success(:,1).*success(:,2));
% 
% fail_items = find(~(success(:,1).*success(:,2)));
% 
% for count = start:finish
%     
%     % First obtain and crop the image
%     get_image = imread(['test_data1/montage_easy/validation_result',num2str(count),'.png']);
%     
%     finalized_image = imcrop(get_image,[0,0,962,694]);
%     
%     montage_easy(:,:,:,count-20) = finalized_image;    
% 
% end
% 
% 
% % Save all the results in a figure
% figure(1)
% clf;
% montage(montage_easy, 'Size', [7,5]);
% title('All results on one montage');
% 
% saveas(gcf,['test_data1/test_results/montage_easy_total.png']);
% 
% figure(2)
% clf;
% montage(montage_easy, 'Size', [6,6], 'Indices', success_items');
% title('Successes');
% saveas(gcf,['test_data1/test_results/montage_easy_success.png']);
% 
% 
% figure(3)
% clf;
% montage(montage_easy, 'Indices', fail_items');
% title('Fails');
% saveas(gcf,['test_data1/test_results/montage_easy_fails.png']);
% 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % TEST FOR HARD IMAGES % % % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%
% % % % FIRST HALF  % % %
% %%%%%%%%%%%%%%%%%%%%%%%
% for count = start:finish
%     
%     
%     % Read the image
%     test_im = imread(['test_data1/hard/', num2str(count) ,'.png']);
% 
%     % Open a new figure starting at the count 
%     figure(count-(start-1))
%     clf;
%     imshow(test_im);
%     title(['Test #', num2str(count-(start-1))]);
% 
%     % Get the results of the dice
%     [move_array, dice_position] =  get_dice_results(test_im);
% 
%     move_array
%     % If the results return empty, store a NaN and 0 0 0 0 coordinate box
%     if isempty(move_array) 
%        move_array = [(NaN), (NaN)];
%        dice_position = [0,0,0,0;0,0,0,0];
%     end
%     
%     % Plot where the location of the dice are with a red box
%     figure(count-(start-1))
%     hold on;
%     rectangle('Position',dice_position(1,:), 'EdgeColor', 'r', 'LineWidth', 1.5);
%     rectangle('Position',dice_position(2,:), 'EdgeColor', 'r', 'LineWidth', 1.5);
% 
%     %saveas(gcf,['test_data1/montage_hard/validation_result',num2str(count), '.png']);
%     
%     % Store the results in an array called validation.
%     validation(count-(start-1),:) = sort(move_array(1:2), 'ascend');
% end
% 
% 
% % Compare the true results against the tested dataset
% compare = [true_results_hard,validation];
% 
% for count = start:finish
%     
%     % Mark the success index's as 1's and fails as 0's
%     if(compare(count-(start-1), 1) == compare(count-(start-1), 3) && compare(count-(start-1), 2) == compare(count-(start-1), 4))
%         success(count-(start-1),:) = [count-(start-1),1];
%         
%     else
%         success(count-(start-1),:) = [count-(start-1),0];
%     
%     end
% end

%%%%%%%%%%%%%%%%%%%%%%
% % SECOND HALF % % %
%%%%%%%%%%%%%%%%%%%%%%
% 
% % Calculate the indices of the success and fails
% success_items = find(success(:,1).*success(:,2));
% 
% fail_items = find(~(success(:,1).*success(:,2)));
% 
% % Manually change test #6 since it was a fail (didn't detect the die)
% success_items(4) = [];
% 
% fail_items(10) = 6;
% 
% compare(6,3) = NaN;
% 
% 
% fail_items = sort(fail_items, 'ascend');
% 
% for count = start:finish
%     
%     % First obtain and crop the image
%     get_image = imread(['test_data1/montage_hard/validation_result',num2str(count),'.png']);
%     
%     finalized_image = imcrop(get_image,[0,0,962,694]);
%     
%     montage_easy(:,:,:,count-55) = finalized_image;    
% 
% end

% Save all the results in a figure
% figure(1)
% clf;
% montage(montage_easy, 'Size', [5,5]);
% title('All results on one montage');
% 
% saveas(gcf,['test_data1/test_results/montage_hard_total.png']);
% 
% figure(2)
% clf;
% montage(montage_easy,  'Indices', success_items');
% title('Successes');
% saveas(gcf,['test_data1/test_results/montage_hard_success.png']);
% 
% 
% figure(3)
% clf;
% montage(montage_easy, 'Indices', fail_items');
% title('Fails');
% saveas(gcf,['test_data1/test_results/montage_hard_fails.png']);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %    NUMBER CRUNCHING   % % % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Total correct results
easy_success_rate = double(31/35)*100

easy_fail_rate = 100-easy_success_rate

% Of the 4 failed frames, 3 were due to positioning of the dice close to
% other pieces on the board, making them more borderline difficult. Only
% one was read wrong after correctly identifying both dice.

% Total dice detection
easy_dice_detection_success = double(66/70)*100

easy_dice_detection_fail = 100-easy_dice_detection_success

% By looking at how accurate the dice detection algorithm is, it is fairly accurate
% with a rate of 95% success

% Total correct results
hard_success_rate = double(14/24)*100

hard_fail_rate = 100-hard_success_rate
% There was a low success rate with the hard dice. Usually only one dice
% correctly identified


% Total dice detection 
hard_dice_detection_success = double(38/48)*100

hard_dice_detection_fail = 100 - hard_dice_detection_success
% There were quite high detection of the dice, however segmentation and
% reading the results were wrong. This indicates a lack of versatility in the read_die
% function 

% One way to mitigate this is to have 2 functions, an easy detection (which
% only detects where it is 95% confident in the middle of the board) and a
% more advanced function utilised when it cannot find 2 easy dice. This
% more advanced function would rely on finer segmentation and image
% processing but only be used when the simple algorithm failed. For this
% assignment, we simplified it to the assumption that simple would be
% enough






