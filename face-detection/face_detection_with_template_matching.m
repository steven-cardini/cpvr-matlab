%% Face detection
%  by Steven Cardini

clear variables;
close all;
clc; % clear command window

imageRgbFile = '..\images\cpvr_classes\2016HS\_DSC0380.JPG';
%imageRgbFile = '..\images\cpvr_classes\2016HS\_DSC0383.JPG';

%% Define People
people = ['Tschanz  ';
  'Laubscher';
  'Knöpfel  ';
  'Häni     ';
  'Mayr     ';
  'Loosli   ';
  'Genecand ';
  'Tüscher  ';
  'Buchegger';
  'Cardini  ';
  'Zingg    ';
  'Gerber   ';
  'Lauper   ';
  'Bigler   '];

[nrPeople, ~] = size(people);

%% Load image with faces to be detected and resize if necessary

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

skinImage = segment_skin(imageRgb, imageGray, false);

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
  faceGray = imageGray(min(y):max(y), min(x):max(x));
  
  bestScore = [0, 0]; % index / value
  for j = 1:nrPeople % iterate through all template pics
    
    score = 0.0;
    for k = 1:9 % iterate through individual templates
      templateLocation = sprintf('..\\images\\cpvr_faces_320\\00%d\\0%d.JPG', j+22, k);
      templateImage = imread(templateLocation);
      templateImage = imresize(templateImage, [max(y)-min(y)+1 max(x)-min(x)+1]);
      templateImage = rgb2gray(templateImage);
      
      for xi = 1:max(x)-min(x)-1
        for yi = 1:max(y)-min(y)-1
          score = score + abs( double(faceGray(yi, xi)) / 100.0 - double(templateImage(yi, xi)) / 100.0);
        end
      end
      
    end
    
    if score>bestScore(1,2)
      bestScore(1,1) = j;
      bestScore(1,2) = score;
    end
    
  end
  
  t= text(min(x)-10, min(y)-10, people(bestScore(1,1),1:9));
  t.Color = [1 1 1];
  t.BackgroundColor = [0 0 0];
end
