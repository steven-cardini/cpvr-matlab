%% Face detection
%  by Steven Cardini

clear variables;
close all;
clc; % clear command window

imageRgbFile = '..\images\cpvr_classes\2016HS\_DSC0380.JPG';
%imageRgbFile = '..\images\cpvr_classes\2016HS\_DSC0383.JPG';

showNames = true;
debug = false;  % 1 Original image
                % 2 White balanced image
                % 3 Skin color segmented image
                % 4 Erosion
                % 5 Dilatation
                % 6 Final image
  
%% Define People
people = ['Tschanz  '; % 23
          'Laubscher'; % 24
          'Knöpfel  '; % 25
          'Häni     '; % 26
          'Mayr     '; % 27
          'Loosli   '; % 28
          'Genecand '; % 29
          'Tüscher  '; % 30
          'Buchegger'; % 31
          'Cardini  '; % 32
          'Zingg    '; % 33
          %'Gerber   '; % 34
          'Lauper   '; % 35
          'Bigler   ']; % 36
        
[nrPeople, ~] = size(people);

%% Load image with faces to be detected and resize if necessary

imageRgb = imread(imageRgbFile);

% resize image if it's too large
image_max_width = 1200;
[~, cols, ~] = size(imageRgb);
if cols>=image_max_width
  imageRgb = imresize(imageRgb, [NaN image_max_width]);
end

if debug == true
  imshow(imageRgb);
  pause;
end

imageGray = rgb2gray(imageRgb);
imageGray = imadjust(imageGray);


%% Segment skin based on color

skinImage = segment_skin(imageRgb, imageGray, debug);

%% Find the faces

facesBinary = find_faces(skinImage);
[rows, cols, n] = size (facesBinary);
facesGray = zeros(rows, cols, n);

%% Display found faces

imshow(imageRgb);

identified = zeros(n,1);

% for all identitifed faces, display a rectangle where it was found and add
% a random name
for i = 1:n
  [y, x] = find(facesBinary(:,:,i) == 1);
  hd = rectangle('Position', [min(x) min(y) (max(x)-min(x)) (max(y)-min(y))]);
  set(hd, 'edgecolor', 'r');
  
  if showNames == true
    face_i = randi(nrPeople);
    while find(identified==face_i)>=2
      face_i = randi(nrPeople);
    end
    identified(i,1) = face_i;
    t= text(min(x)-8, min(y)-8, people(face_i,1:9));
    t.Color = [1 1 1];
    t.BackgroundColor = [0 0 0];
  end
  
end
