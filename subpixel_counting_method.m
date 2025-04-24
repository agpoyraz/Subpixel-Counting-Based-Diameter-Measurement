function [cap] = subpixel_counting_method(im,edge_method,numberofmaxk,average_type)
% numberofmaxk value is mentioned as n value in the published paper

%% numberofmaxk:manual, thresholds:auto
% [bottom_th,upper_th,im_filled] = determine_thresholds_with_manual_k(im,th,edge_method,numberofmaxk,average_type); % Manual

%% numberofmaxk:auto, thresholds:auto
% For auto version, numberofmaxk value is calculated autonomously. So
% numberofmaxk = 9 can be choosen for upper bound. If you want to select
% manually you can use calibration_for_subpixel_counting function
[bottom_th,upper_th,im_filled] = determine_thresholds(im,edge_method,average_type); % Auto

%% Calculation
[cap] = calculation(im_filled,upper_th,bottom_th);

end