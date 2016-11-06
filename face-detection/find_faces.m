%% function returns coordinates of identified faces
function faces = find_faces (imageBinary)

[rows, cols] = size(imageBinary);
faces = zeros(rows, cols, 1);

% Parameters for face detection
min_face_holes = 1;
min_face_width = cols/36;
max_face_width = cols/6;
min_face_height = rows/24;
max_face_height = rows/4;

% Label connected components
[imageLabeled, nComponents] = bwlabel(imageBinary, 8);

%% dismiss connected components without holes

face_index = 1;

for i = 1:nComponents
  
  % Compute the coordinates for this region
  [y, x] = find(imageLabeled == i);
  
  % Create binary image that only has the region of the i-th component, the rest is black
  componentImage = bwselect(imageBinary, x, y, 8);
  
  % Get the number of holes
  numfeatures = bweuler(componentImage,4);
  numholes = 1 - numfeatures;
  
  if numholes >= min_face_holes && (max(x)-min(x)) > min_face_width && (max(x)-min(x)) < max_face_width && (max(y)-min(y)) > min_face_height && (max(y)-min(y)) < max_face_height
    faces(y, x, face_index) = 1; % add identified face to resulting matrix
    face_index = face_index + 1;
  end
  
end

end