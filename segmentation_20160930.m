clear all;
close all;
clc; % clear command window

fileName = 'img\bloodcells.png';

I = imread(fileName);
[rows, cols, channels] = size(I);
pixels = rows * cols;

if (channels == 3) % if image is rgb, convert it to grayscale
  I = rgb2gray(I);
end

% Mean Value Threshold Segmentation
t = mean(I(:));
I_mean = binariseImage(I,t);
imshow(I_mean);
pause;

% k Means Clustering Threshold Segmentation
I_kMeans = kMeansClustering(I);
imshow(I_kMeans);
pause;

I_otsu = otsu(I);
imshow(I_otsu);

