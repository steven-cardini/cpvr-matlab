function image = otsu (image)
    [rows, cols] = size(image);
    maxValue = 256;
    
    % compute histogram and amount for each level
    histogram = zeros(maxValue, 1, 'double');
    for row = 1:rows
      for col = 1:cols
        i = image(row,col); % current pixel intensity
        histogram(i) = histogram(i) + 1;
      end
    end
    
    % transform histogram amounts to probabilities
    pixels = sum(histogram);
    for i = 1:maxValue
      histogram(i) = histogram(i) / pixels;
    end
    
    % step through all possible thresholds 1..max intensity and calculate
    % inter-class variance
    icVar = zeros(maxValue,1,'double');
    for t = 1:maxValue
      [w0, w1] = calculateWeights (histogram, t);
      var0 = var(histogram(1:t-1));
      var1 = var(histogram(t:maxValue));
      icVar(t) = w0*var0 + w1*var1;
    end
    
    % get threshold with the lowest inter-class variance
    threshold = 0;
    variance = 1000000;
    for t = 1:maxValue
      if icVar(t) < variance
        threshold = t;
        variance = icVar(t);
      end
    end
    
    % binarise image with found threshold
    image = binariseImage (image, threshold);
    
    
  function [w0, w1] = calculateWeights (histogram, threshold)
    w0=0;
    w1=0;
    for j=1:(threshold-1)
      w0 = w0 + histogram(j);
    end
    for j=threshold:length(histogram)
      w1 = w1 + histogram(j);
    end
  end
    
end