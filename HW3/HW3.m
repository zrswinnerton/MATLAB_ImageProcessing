%TEE 461 Image Processing
%Zach Swinnerton
%HW 3

clear all;
close all;
clc;

%Problem 1
BSP = im2double(imread('buildingSPnoise.tif'));
%BSP = 1200x1200 pixels
M = size(BSP,1);
N = size(BSP,2);
%7x7 Averaging Filter
figure(1);imshow(BSP); title('Original Noisy Image');
k = (1/49) * ones([7 7]); %7x7 averaging kernel
BSPavg = conv2(BSP,k,"same"); %average can use conv2 or iterate
figure(2);imshow(BSPavg); title("7x7 Averaging Kernel Applied");

%7x7 Median Filter
BSPmed1 = zeros([M+6 N+6]); %pads image for extra rows and columns
BSPmed1(4:(M+3),4:(N+3)) = BSP; %place original image in center of zeros
%median filter conv2 doesnt work, must iterate image with kernel
for r = 1:M
    for c = 1:N
        %no kernel intialized, median of small window of image = to kernel
        BSPmed1(r,c) = median(median(BSPmed1((r):(r+6),(c):(c+6))));
    end
end
BSPmed2 = BSPmed1(4:(M+3),4:(N+3)); %crop off zeros boarder
figure(3);imshow(BSPmed2); title('7x7 Median Filter Applied');

%Comparing the two filtering methods the median filter is clearly better
%than the averaging filter. The averaging filter blurs the image and
%retains some hints of the noise due to the nature of averaging. The median
%filter however retains the sharpness of the image and effectively removes
%the noise from the image.

% clear all;
% close all;
% clc;

%Problem 2
B = im2double(imread('building.tif'));
%B = 1200x1200 pixels
figure(4);imshow(B); title('Original Image');
m = size(B,1); %original column dimension
n = size(B,2); %original row dimension
M = 2*size(B,1); %padded column dimension
N = 2*size(B,2); %padded row dimension
BZero = zeros([M N]);

%Zero pad for higher resolution after convolution
for r = 1:m
    for c = 1:n
        BZero(r,c) = B(r,c); 
    end
end

BFN = im2double(imread('buildingFreqNoise.tif'));
%BFN = 1200x1200 pixels
figure(5);imshow(BFN); title('Frequency Noise Image');
BFNZero = zeros([M N]);

%Zero pad for higher resolution after convolution
for r = 1:m
    for c = 1:n
        BFNZero(r,c) = BFN(r,c); 
    end
end

Bfft = fft2(BZero);
Bfft2 = fftshift(Bfft);
Bfft3 = log(abs(Bfft2)+1); %abs and + 1 for display
disp_Bfft = mat2gray(Bfft3); 
figure(6);imshow(disp_Bfft); title('Original Image FFT Shifted Magnitude');

BFNfft = fft2(BFNZero);
BFNfft2 = fftshift(BFNfft);
BFNfft3 = log(abs(BFNfft2)+1); %abs and + 1 for display
disp_BFNfft = mat2gray(BFNfft3); 
figure(7);imshow(disp_BFNfft); title('Frequency Noise Image FFT Shifted Magnitude');

%try removing frequency data by subtracting bad from original
FN = BFNfft2 - Bfft2;
fn = mat2gray(log(abs(FN)+1));
figure(8);imshow(fn); title('Frequency Noise Minus Original FFT');
f = ones([M N]);

for i = 1:M
    for j = 1:N
        f(i,j) = 1-(fn(i,j)); %inverse the frequency data removed to create high pass
    end
end
figure(9);imshow(f); title('Inverse Frequency Filter');

%try removing sections of frequency data with circles
%1st set of circles from center
rmid1 = (M - 600) / 2; %row 450
rmid2 = (M + 600) / 2; %row 750
%2nd set of circles from center
rmid3 = (M - 1200) / 2; %row 275
rmid4 = (M + 1200) / 2; %row 925
%3rd set of circles from center
rmid5 = (M - 1800) / 2; %row 150
rmid6 = (M + 1800) / 2; %row 1050
%4th set of circles from center
rmid7 = (M - 2400) / 2; %row 1
rmid8 = (M + 2400) / 2; %row 1200

cmid = (N + 1)/ 2; %circles along same center column

dist1 = zeros([M N]); %distance for 1st upper circle
dist2 = zeros([M N]); %distance for 1st lower circle
dist3 = zeros([M N]); %distance for 2nd upper circle
dist4 = zeros([M N]); %distance for 2nd lower circle
dist5 = zeros([M N]); %distance for 3rd upper circle
dist6 = zeros([M N]); %distance for 3rd lower circle
dist7 = zeros([M N]); %distance for 4th upper circle
dist8 = zeros([M N]); %distance for 4th lower circle
filter = ones([M N]);

for r = 1:M
    for c = 1:N
        dist1(r,c) = sqrt((r - rmid1)^2 + (c - cmid)^2);
        dist2(r,c) = sqrt((r - rmid2)^2 + (c - cmid)^2);
        dist3(r,c) = sqrt((r - rmid3)^2 + (c - cmid)^2);
        dist4(r,c) = sqrt((r - rmid4)^2 + (c - cmid)^2);
        dist5(r,c) = sqrt((r - rmid5)^2 + (c - cmid)^2);
        dist6(r,c) = sqrt((r - rmid6)^2 + (c - cmid)^2);
        dist7(r,c) = sqrt((r - rmid7)^2 + (c - cmid)^2);
        dist8(r,c) = sqrt((r - rmid8)^2 + (c - cmid)^2);
        if dist1(r,c) < 105 %high pass filter radius 105
            filter(r,c) = 0;
        end
        if dist2(r,c) < 105 %high pass filter radius 105
            filter(r,c) = 0;
        end
        if dist3(r,c) < 95 %high pass filter radius 95
            filter(r,c) = 0;
        end
        if dist4(r,c) < 95 %high pass filter radius 95
            filter(r,c) = 0;
        end
        if dist5(r,c) < 55 %high pass filter radius 55
            filter(r,c) = 0;
        end
        if dist6(r,c) < 55 %high pass filter radius 55
            filter(r,c) = 0;
        end
        if dist7(r,c) < 110 %high pass filter radius 110
            filter(r,c) = 0;
        end
        if dist8(r,c) < 110 %high pass filter radius 110
            filter(r,c) = 0;
        end
    end
end

figure(10);imshow(filter); title('Circles Filter');
BFNfltr1 = BFNfft2 .* filter; %circles attempt
BFNfltr2 = BFNfft2 .* f; %inverse frequency attempt

BFNmod1 = log(abs(BFNfltr1)+1); %abs and + 1 for display
figure(11);imshow(mat2gray(BFNmod1)); title('Removed via Circles');

BFNmod2 = log(abs(BFNfltr2)+1); %abs and + 1 for display
figure(12);imshow(mat2gray(BFNmod2)); title('Removed via Inverse Frequency');

BFNfltr3 = ifftshift(BFNfltr1);
BFNfltr4 = abs(ifft2(BFNfltr3));
BFNfixed1 = BFNfltr4(1:m,1:n);
figure(13);imshow(BFNfixed1); title('Image using Circle Method');

BFNfltr5 = ifftshift(BFNfltr2);
BFNfltr6 = abs(ifft2(BFNfltr5));
BFNfixed2 = BFNfltr6(1:m,1:n);
figure(14);imshow(BFNfixed2); title('Image using Inverse Frequency Method');

%Comparing these two methods I think the ideal highpass filter circles
%method gave better results than the inverse frequency noise method. This
%is because the inverse frequency noise filter removed some of the central
%low frequency content and made the whole image much darker with less
%contrast. The center of the shifted FFT after applying the inverse
%frequency filter shows the values being much duller than the original.
%From applying these two methods I learned that you cannot always remove
%frequency noise without possibly sacrificing the quality/details of the
%image. I might have tried to use gaussian highpass filters for the circle
%method to reduce the ringing of the applied filter image.
