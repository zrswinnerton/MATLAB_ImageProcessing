clear all;
close all;
clc;

%Problem 2
B = im2double(imread('building.tif'));
%B = 1200x1200 pixels
figure(1);imshow(B); title('Original Image');

BFN = im2double(imread('buildingFreqNoise.tif'));
%BFN = 1200x1200 pixels
M = size(BFN,1);
N = size(BFN,2);
figure(2);imshow(BFN); title('Frequency Noise Image');

Bfft = fft2(B);
Bfft2 = fftshift(Bfft);
Bfft3 = log(abs(Bfft2)+1); %abs and + 1 for display
disp_Bfft = mat2gray(Bfft3); 
figure(3);imshow(disp_Bfft); title('Original Image FFT Shifted Magnitude');

BFNfft = fft2(BFN);
BFNfft2 = fftshift(BFNfft);
BFNfft3 = log(abs(BFNfft2)+1); %abs and + 1 for display
disp_BFNfft = mat2gray(BFNfft3); 
figure(4);imshow(disp_BFNfft); title('Frequency Noise Image FFT Shifted Magnitude');

%try removing frequency data by subtracting bad from original
FN = BFNfft2 - Bfft2;
fn = mat2gray(log(abs(FN)+1));
figure(5);imshow(fn); title('Frequency Noise Minus Original FFT');
f = ones([M N]);

for i = 1:M
    for j = 1:N
        f(i,j) = 1-(fn(i,j)); %inverse the frequency data removed to create high pass
    end
end
figure(6);imshow(f); title('Inverse Frequency Filter');

%try removing sections of frequency data with circles
%1st set of circles from center
rmid1 = (M - 300) / 2; %row 450
rmid2 = (M + 300) / 2; %row 750
%2nd set of circles from center
rmid3 = (M - 650) / 2; %row 275
rmid4 = (M + 650) / 2; %row 925
%3rd set of circles from center
rmid5 = (M - 900) / 2; %row 150
rmid6 = (M + 900) / 2; %row 1050
%4th set of circles from center
rmid7 = (M - 1200) / 2; %row 1
rmid8 = (M + 1200) / 2; %row 1200

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
        if dist1(r,c) < 85 %high pass filter radius 85
            filter(r,c) = 0;
        end
        if dist2(r,c) < 85 %high pass filter radius 85
            filter(r,c) = 0;
        end
        if dist3(r,c) < 75 %high pass filter radius 75
            filter(r,c) = 0;
        end
        if dist4(r,c) < 75 %high pass filter radius 75
            filter(r,c) = 0;
        end
        if dist5(r,c) < 35 %high pass filter radius 35
            filter(r,c) = 0;
        end
        if dist6(r,c) < 35 %high pass filter radius 35
            filter(r,c) = 0;
        end
        if dist7(r,c) < 90 %high pass filter radius 90
            filter(r,c) = 0;
        end
        if dist8(r,c) < 90 %high pass filter radius 90
            filter(r,c) = 0;
        end
    end
end

figure(7);imshow(filter); title('Circles Filter');
BFNfltr1 = BFNfft2 .* filter; %circles attempt
BFNfltr2 = BFNfft2 .* f; %inverse frequency attempt

BFNmod1 = log(abs(BFNfltr1)+1); %abs and + 1 for display
figure(8);imshow(mat2gray(BFNmod1)); title('Removed via Circles');

BFNmod2 = log(abs(BFNfltr2)+1); %abs and + 1 for display
figure(9);imshow(mat2gray(BFNmod2)); title('Removed via Inverse Frequency');

BFNfltr3 = ifftshift(BFNfltr1);
BFNfltr4 = abs(ifft2(BFNfltr3));
BFNfixed1 = BFNfltr4(1:M,1:N);
figure(10);imshow(BFNfixed1); title('Image using Circle Method');

BFNfltr5 = ifftshift(BFNfltr2);
BFNfltr6 = abs(ifft2(BFNfltr5));
BFNfixed2 = BFNfltr6(1:M,1:N);
figure(11);imshow(BFNfixed2); title('Image using Inverse Frequency Method');
