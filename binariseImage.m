function image = binariseImage (image, threshold)
[rows, cols] = size(image);
for row = 1:rows
  for col = 1:cols
    if (image(row,col)<threshold)
      image(row,col)=255;
    else
      image(row,col)=0;
    end
  end
end
end