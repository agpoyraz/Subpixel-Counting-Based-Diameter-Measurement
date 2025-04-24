% Usage of the algorithm
% In this script a syntetic and real images are evaluated with subpixel counting
% algorithm to measure outer diameter of circle. 
clear all
clc
addpath(genpath('.'));

%% For Syntetic image
im = imread('yeni_30_255_25_gauss_0.5bmp');
result = subpixel_counting_method(im,'intermediate',9,'mean'); % Preprocessing step is deactive


%% For real image
th = 254;
im = imread('real\im_real.bmp');

% Preprocessing-----begin (RECOMMENDED)
[im_desired] = eliminate_small_objects(im,th);
im_filled = imcomplement(imfill(imcomplement(im_desired)));
% Preprocessing-----end

result2 = subpixel_counting_method(im_filled,'intermediate',9,'mean'); % Preprocessing step is deactive
