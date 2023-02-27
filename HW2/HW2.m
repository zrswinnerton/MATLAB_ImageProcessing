%TEE 461 Image Processing
%Zach Swinnerton
%HW 2

clear all;
close all;
clc;

%Problem 1
T = imread('totem-poles.tif'); 
%T = 600x800 pixels
M = size(T,1);
N = size(T,2);
imhist(T); axis tight; title('Original Histogram');
pdf = zeros([1,256]); %initalize blank pdf vector
cdf = zeros([1,256]); %initalize blank cdf vector
TEq = uint8(zeros([M,N])); %initalize blank equalized image
[counts,L] = imhist(T);
pdf = counts / (M * N);
cdf = 255 * (cumsum(pdf));

%Mapping to Equalized Image
for r = 1:M
    for c = 1:N
        TEq(r,c) = cdf(T(r,c) + 1); 
        % if T(1,1) = 0 then cdf(1) = 0
        % if T(x,x) = 255 then cdf(256) = 255
    end
end

imhist(TEq); axis tight;  title('Equalized Histogram');
imshow(T); title('Original');
imshow(TEq); title('Equalized');

%The equalized image clearly is worse than the original image. The image is
%much closer to a binary image than the original due to the pixel values
%being stretched out further along the range from 0-255. Subtle changes in
%the sky of the original image are much more noticeable due to this
%equalization.

% clear all;
% close all;
% clc;

%Problem 2
T = im2double(imread('totem-poles.tif')); 
%T = 600x800 pixels
M = size(T,1);
N = size(T,2);
fsize = [7,7]; %kernel size
rmid = (fsize(1) + 1) / 2;
cmid = (fsize(2) + 1)/ 2;
dist = zeros(fsize(1),fsize(2)); 
%Euclidean distance matrix based on size of kernel
Gfilter = zeros(fsize(1),fsize(2));
%Guassian filter size of kernel
sigma = 2;

%Create Guassian filter from Euclidean distance matrix
for r = 1:fsize(1)
    for c = 1:fsize(2)
        dist(r,c) = sqrt((r - rmid)^2 + (c-cmid)^2);
        Gfilter(r,c) = exp(-.5 * ((dist(r,c) / sigma)^2));
    end
end

Gtot = sum(sum(Gfilter)); %Sum of all elements in Gfilter matrix
Gfilter = (Gfilter./(Gtot)); %Normalize Guassian filter
% minval = min(min(dist));
% maxval = max(max(dist));
% imshow(dist,([minval,maxval])); %show Euclidean distance matrix
% imshow(Gfilter); %show Guassian filter
TGaus = conv2(T,Gfilter,"same"); %uses center matrix size of T
imshow(T); title('Original');
imshow(TGaus); title('Guassian Low Pass Filter');

%The Gaussian lowpass filter blurred the image as expected by removing some
%medium and high frequency content. The noticeable difference is that the
%Gaussian lowpass filter does not show ringing like the example we were
%shown in class. This is due to the smooth transition of the filter. Also
%the image is grayer due to the removal of the high frequency content.
%This is clear in the mouth of the left totem and the ground.

% clear all;
% close all;
% clc;

%Problem 3
T = im2double(imread('totem-poles.tif')); 
%T = 600x800 pixels
M = size(T,1);
N = size(T,2);
k = [-1,-1,-1;-1,8,-1;-1,-1,-1]; %sharpen kernel

sharp = conv2(T,k,"same"); %auto-removes excess boarders
TSharp1 = T + (.2*sharp); %add sharpened edges to original
TSharp5 = T + (.6*sharp);
imshow(T); title('Original');
imshow(sharp); title('High Pass Filter')
imshow(TSharp1); title('High Pass Filter Applied Scalar .2'); %better
imshow(TSharp5); title('High Pass Filter Applied Scalar .6');

%The highpass filtered image with the scaling factor of .2 looks better
%than the original and better than the scaling factor of .6. The detail in
%the right totem pole was noticeably better around the right edge. The .6
%image seemed too harsh of sharpness in my opinion and hurt my eyes. I
%think the .2 scaling factor image is the best compromise.

% clear all;
% close all;
% clc;

%Problem 4
T = im2double(imread('totem-poles.tif')); 
%T = 600x800 pixels
M = size(T,1);
N = size(T,2);
rmid = (2*M + 1) / 2;
cmid = (2*N + 1) / 2;
dist = zeros(M,N);
filter = zeros(M*2,N*2);
TZero = zeros(M*2,N*2);

imshow(T); title('Original');

%Zero pad for higher resolution after convolution
for r = 1:M
    for c = 1:N
        TZero(r,c) = T(r,c); 
    end
end
%imshow(TZero);

TZfft = fft2(TZero);
TZfft2 = fftshift(TZfft);

TZfft3 = log(abs(TZfft2)+1); %abs and + 1 for display
disp_fft = mat2gray(TZfft3); 
imshow(disp_fft); title('Magnitude of Shifted FFT on Log Scale');

for r = 1:2*M
    for c = 1:2*N
        dist(r,c) = sqrt((r - rmid)^2 + (c - cmid)^2);
        if dist(r,c) < 200 %low pass filter radius 200
            filter(r,c) = 1;
        end
    end
end

imshow(filter); title('Ideal Low Pass Filter');

Tlp = TZfft2 .* filter;
Tlp2 = ifftshift(Tlp);
Tlp3 = abs(ifft2(Tlp2));
TLowPass = Tlp3(1:M,1:N);
imshow(TLowPass); title('Ideal Low Pass Filter Applied');

%The ideal lowpass filter clearly shows ringing between the two totem-
%poles. This is due to the harsh edge of the ideal lowpass filter. This
%ringing makes the image look worse in my opinion and choosing a smoother
%lowpass filter such as Gaussian, or a Butterworth filter would be better.
%The ideal lowpass filter also makes the image blurrier in my opinion due
%to the filter removing some medium and high frequency content that helps
%to sharpen the image.
