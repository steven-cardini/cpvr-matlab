%% function returns a binary image where 1 = skin and 0 = no skin
function imageBinary = segment_skin (imageRgb, imageGray)

[rows, cols, ~] = size(imageRgb);

% HSV segmentation thresholds
min_skin_hue = 2;
max_skin_hue = 39;
min_skin_sat = 0.20;
max_skin_sat = 0.68;
min_skin_val = 0.35;
max_skin_val = 0.93;

% structure element radii for morphological operations
skin_erosion_radius = 2;
skin_dilation_radius = 1;

%% do a white balance
% 
% Extract the individual red, green, and blue color channels.
redChannel = imageRgb(:, :, 1);
greenChannel = imageRgb(:, :, 2);
blueChannel = imageRgb(:, :, 3);
meanR = mean2(redChannel);
meanG = mean2(greenChannel);
meanB = mean2(blueChannel);
meanGray = mean2(imageGray);

% Make all channels have the same mean
redChannel = uint8(double(redChannel) * meanGray / meanR);
greenChannel = uint8(double(greenChannel) * meanGray / meanG);
blueChannel = uint8(double(blueChannel) * meanGray / meanB);

% Recombine separate color channels into a single, true color RGB image.
imageRgb = cat(3, redChannel, greenChannel, blueChannel);


%% get HSV values of image and do the segmentation

imageHsv = rgb2hsv(imageRgb);
hueChannel = imageHsv(:,:,1);
satChannel = imageHsv(:,:,2);
valChannel = imageHsv(:,:,3);
hueChannel = hueChannel * 360; % map the hue channel to 360 degrees

imageBinary = ones(rows, cols);
for row = 1:rows
  for col = 1:cols
    if hueChannel(row,col) < min_skin_hue || hueChannel(row,col) > max_skin_hue || satChannel(row,col) < min_skin_sat || satChannel(row,col) > max_skin_sat || valChannel(row,col) < min_skin_val || valChannel(row,col) > max_skin_val
      imageBinary(row, col) = 0;
    end
  end
end


%% Erosion and dilatation

% erosion 1
se = strel('diamond', skin_erosion_radius);
imageBinary = imerode(imageBinary, se);

% dilation 1
se = strel('diamond', skin_dilation_radius);
imageBinary = imdilate(imageBinary, se);


end %function