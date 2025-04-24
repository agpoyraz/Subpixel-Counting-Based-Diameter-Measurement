# Subpixel-Counting-Based-Diameter-Measurement
This project presents a novel image processing algorithm for accurate subpixel-level diameter measurement. It is specifically designed for use in machine vision systems where precision is critical despite defocus or resolution limitations. The algorithm estimates diameters by counting intensity transitions across edges, enabling reliable measurement even under blurred conditions.

## Purpose
The goal of this algorithm is to offer a non-contact, pixel-independent, and highly accurate measurement solution for cylindrical or circular object diameters in industrial environments. It performs robustly in low-resolution or defocused images.

## Method Overview
Gaussian blur is applied to simulate defocus on the input images.
Edge transitions are identified.
Pixel intensity transitions are counted to achieve subpixel resolution.
A regression model or conversion factor predicts the actual diameter.
Compared to classical edge detection and segmentation techniques, this method provides higher accuracy and greater robustness to optical blur.

## Installation




Sub-Pixel counting based diameter measurement algorithm for industrial Machine vision
In terms of usage, the background should be filled in with white and the part of interest should be black, then the algorithm should be run. The preprocessing step is included in the subpixel_counting_method function. You can activate or deactivate it from there.

But I recommend you apply a preprocessing step to eliminate undesired noises.
