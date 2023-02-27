% Zoom 8 activity 
% Load images - Inspect histogram, FFT, etc. 
% Choose filter for each case 

%% Image 1 - test-pattern1.tif
clear; clc; close; 

% Can look at original for a comparison point 
% figure; imshow(im2double(imread('test-pattern.tif')));

% Load image, convert to double, get size of image 
pattern = im2double(imread('test-pattern1.tif'));
[M,N] = size(pattern); 

% Look at image histogram
figure; imshow(pattern) 
figure; imhist(pattern) 

% Look at the FFT
pattern_fft = fftshift(fft2(pattern)); 
disp_fft = mat2gray(log(abs(pattern_fft)+1)); 
figure; imshow(disp_fft);

% Try an averaging filter and median filter
pattern_avg = pattern; 
pattern_med = pattern; 

% Iterate through all rows and columns to get mean and median 
% Note: started with 3x3 but revised to 5x5 
for i = 3:(M-2)
    for j = 3:(N-2) 
        pattern_avg(i,j) = mean(mean(pattern((i-2):(i+2),(j-2):(j+2)))); 
        pattern_med(i,j) = median(median(pattern((i-2):(i+2),(j-2):(j+2)))); 

    end
end

figure; imshow(pattern_avg); 
figure; imshow(pattern_med); 
% Note: Mean filter appears to work better for this image 


%% Image 2 - test-pattern1.tif
clear; clc; close; 

% Load image -- convert to double 
xray = im2double(imread('dentalXray.tif'));
[M,N] = size(xray); 

% Look at image histogram
figure; imshow(xray) 
figure; imhist(xray) 

% Look at the FFT
xray_fft = fftshift(fft2(xray)); 
disp_fft = mat2gray(log(abs(xray_fft)+1)); 
figure; imshow(disp_fft);

% Try an averaging filter and median filter
xray_avg = xray; 
xray_med = xray; 

% Iterate through all rows and columns to get mean and median 
% Note: started with 3x3 but revised to 5x5 
for i = 3:(M-2)
    for j = 3:(N-2) 
        xray_avg(i,j) = mean(mean(xray((i-2):(i+2),(j-2):(j+2)))); 
        xray_med(i,j) = median(median(xray((i-2):(i+2),(j-2):(j+2)))); 

    end
end

figure; imshow(xray_avg); 
figure; imshow(xray_med); 

% Note: Median filter appears to work better (salt and pepper noise) 
