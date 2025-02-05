function [cap] = subpixel_counting_method(im,edge_method,numberofmaxk,average_type)
th = 254;
%% with preprocessing and auto
% For auto version, numberofmaxk value is calculated autonomously. So
% numberofmaxk = 9 can be choosen for upper bound. If you want to select
% manually you can use calibration_for_subpixel_counting function
%[bottom_th,upper_th,im_filled] = calibration_for_subpixel_countingv2(im,th,edge_method,numberofmaxk,average_type); % Auto

%% without preprocessing and auto
% Also calibration_for_subpixel_countingv2 function has preprocessing step.
% In order to pass preprocessing step use
% calibration_for_subpixel_countingv2_nopreprocessing function
[bottom_th,upper_th,im_filled] = calibration_for_subpixel_countingv2_nopreprocessing(im,th,edge_method,numberofmaxk,average_type);

%% with preprocessing and manuel
% [bottom_th,upper_th,im_filled] = calibration_for_subpixel_counting(im,th,edge_method,numberofmaxk,average_type); % Manuel

[cap] = dis_cap_AGP_v1_denklem5(im_filled,upper_th,bottom_th);
end