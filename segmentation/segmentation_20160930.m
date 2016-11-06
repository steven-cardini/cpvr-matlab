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

% k Means Clustering Threshold Segmentation
I_kMeans = kMeansClustering(I);

% Otsu's method
I_otsu = otsu(I);


% Graphics
subplot(2,2,1)
imshow(I_mean);
title('Mean value');

subplot(2,2,2)
imshow(I_kMeans);
title('kMeans');

subplot(2,2,3)
imshow(I_otsu);
title('Otsu');

