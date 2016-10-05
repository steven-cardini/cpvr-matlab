function image = kMeansClustering (image)
[rows, cols] = size(image);
pixels = rows * cols;

t0 = double (max(image(:)));
t = double (median(image(:))); % set the threshold as median of the picture matrix

while abs(t-t0) > 0.0001
  t0 = t;
  t = normalizeThreshold (t0);
end

image = binariseImage (image, t);

  function t = normalizeThreshold (threshold)
    lower = zeros(pixels / 2, 1);
    higher = zeros(pixels / 2, 1);
    nLower = 0;
    nHigher = 0;
    
    for row = 1:rows
      for col = 1:cols
        if (image(row,col) < threshold)
          nLower = nLower + 1;
          lower(nLower) = image(row, col);
        else
          nHigher = nHigher + 1;
          higher(nHigher) = image(row, col);
        end
      end
    end
    
    mean1 = mean(lower);
    mean2 = mean(higher);
    t = (mean1 + mean2) / 2;
  end



end