% M-file to place multiple small circles of Gaussian profile
% inside a big circle. 

% Clean up 
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures.
clear;  % Erase all existing variables.
workspace;  % Make sure the workspace panel is showing.
fontSize = 14;

% Initialize some parameters. 
numberOfSmallCircles = 50; % Number of small circles 
smallCircleOutsideValue = 0.3; 
smallCircleInsideValue = 0.8; 
smallCircleRadius = 31;    % small circle radius 
bigImageWidth = 500; 
bigImageHeight =  500; % square area 0f 500*500 
bigCircleRadius = 250;    % big circle radius 

% Initialize an image to hold one single big circle. 
bigCircleImage = zeros(bigImageHeight, bigImageWidth); 
[x, y] = meshgrid(1:bigImageWidth, 1:bigImageHeight); 
bigCircleImage((x - bigImageWidth/2).^2 + (y - bigImageHeight/2).^2 <= bigCircleRadius.^2) = 1; 
% Display it in the upper left plot. 
subplot(3,2,1); 
imshow(bigCircleImage, []); 
title('Big Circle Mask', 'FontSize', fontSize);
axis on;
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.

% Initialize an image to hold one single small circle. 
sigma = smallCircleRadius * .4;
singleCircleImage = fspecial('gaussian', 2*smallCircleRadius, sigma); 
% Normalize to 0-1.
singleCircleImage=singleCircleImage/max(max(singleCircleImage));
% Display it in the upper right plot. 
subplot(3,2,2); 
imshow(singleCircleImage, []); 
title('Single Small Circle (scaled to fit)', 'FontSize', fontSize);
axis on;

singleWidth = size(singleCircleImage, 2); 
singleHeight = size(singleCircleImage, 1); 
% Get random coordinates in the big image where 
% we will place the upper left corner of the small circle. 
widthThatWillFit = bigImageWidth - 2 * smallCircleRadius; 
heightThatWillFit = bigImageHeight - 2 * smallCircleRadius; 
smallUpperLeftX = widthThatWillFit * rand(numberOfSmallCircles, 1); 
smallUpperLeftY = heightThatWillFit * rand(numberOfSmallCircles, 1); 
% Initialize an output image to hold many small overlapping circles. 
manySmallCircles = zeros(bigImageHeight, bigImageWidth); 
% Place the small circles one by one. 
for k = 1 : numberOfSmallCircles 
        % Find the square in the big image where we're going to add a small circle. 
        x1 = int16(smallUpperLeftX(k)); 
        y1 = int16(smallUpperLeftY(k)); 
        if x1 < 1
            x1 = 1;
        end
        if y1 < 1
            y1 = 1;
        end
        x2 = int16(x1 + singleWidth - 1); 
        y2 = int16(y1 + singleHeight - 1); 
        if x2 > bigImageWidth
            x2 = bigImageWidth;
        end
        if y2 > bigImageHeight
            y2 = bigImageHeight;
        end
        % Add in one small circle to the existing big image. 
        manySmallCircles(y1:y2, x1:x2) = manySmallCircles(y1:y2, x1:x2) + singleCircleImage; 
end 
% Make outside the circles the outside color. 
manySmallCircles(manySmallCircles == 0) = smallCircleOutsideValue; 
% Display it in the lower left plot. 
subplot(3,2,3); 
imshow(manySmallCircles, []); 
title('Many Small Overlapping Circles', 'FontSize', fontSize); 
axis on;

% Multiply the big circle mask by the many small circles image to clip 
% those small circles that lie outside the big circle. 
maskedByBigCircle = bigCircleImage .* manySmallCircles; 
% Display it in the lower right plot. 
subplot(3,2,4); 
imshow(maskedByBigCircle, []); 
title('Many Small Circles Masked by Big Circle', 'FontSize', fontSize); 
axis on;

% Take the histogram and display it in the bottom row. 
subplot(3,2,5:6);
numberOfBins = 128;
[pixelCounts grayLevels] = hist(maskedByBigCircle(:), numberOfBins); 
% Suppress the zero bin because so many pixels are in there that
% we won't see the shape of it.
% pixelCounts(1) = pixelCounts(2);
% Now plot it with a bar chart
bar(pixelCounts);
xlim([1 numberOfBins]);
grid on;
title('Intensity Histogram of Many Small Circles Masked by Big Circle', 'FontSize', fontSize); 
ylabel('Pixel Count', 'FontSize', fontSize);
xlabel('Bin', 'FontSize', fontSize);
