% Usage with syntetic images
% In this script a syntetic image is evaluated with subpixel counting
% algorithm to measure outer diameter of circle. 
clear all
clc
addpath(genpath('.'));

%% For Syntetic image
im = imread('yeni_30_255_25_gauss_0.5.bmp');
tic
result = subpixel_counting_method(im,'intermediate',9,'mean'); % Preprocessing step is deactive
toc

%In order to add preprocessing step, change "subpixel_counting_method"
%function. Explanation is available in the script (open subpixel_counting_method)

%If you evaluate speed comparison, apply code in a for loop and
%average it. Because for the first time speed results generally are slow.


%% For real image
im = imread('real\im_real.bmp');
result = subpixel_counting_method(im,'intermediate',9,'mean'); % Preprocessing step is deactive
