%% Face detection
%  by Steven Cardini

clear variables;
close all;
clc; % clear command window

%% Load image with faces to be detected and resize if necessary

imageRgbFile = '..\images\cpvr_classes\2016HS\_DSC0373.JPG';
imageRgb = imread(imageRgbFile);

% resize image if it's too large
image_max_width = 1200;
[~, cols, ~] = size(imageRgb);
if cols>=image_max_width
  imageRgb = imresize(imageRgb, [NaN image_max_width]);
end

imageGray = rgb2gray(imageRgb);
imageGray = imadjust(imageGray);


%% Segment skin based on color

skinImage = segment_skin(imageRgb, imageGray);

%% Find the faces

facesBinary = find_faces(skinImage);
[rows, cols, n] = size (facesBinary);
facesGray = zeros(rows, cols, n);

%% Display found faces

imshow(imageRgb);

% for all identitifed faces, display a rectangle where it was found
for i = 1:n
  [y, x] = find(facesBinary(:,:,i) == 1);
  hd = rectangle('Position', [min(x) min(y) (max(x)-min(x)) (max(y)-min(y))]);
  set(hd, 'edgecolor', 'r');
end
