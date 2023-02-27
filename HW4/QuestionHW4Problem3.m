clear all;
close all;
clc;

%Problem 3
B = imread('baby.tif');
figure(1);
imshow(B); title('Original');
%B = 812 x 812 pixels
[M,N] = size(B);
B1 = dct2(B);
figure(2);
imshow(mat2gray(B1)); title('DCT Freq Content');
%frequency content is located in top left corner (1:80, 1:80)
B2 = zeros(size(B));
B2(1:round(M/10),1:round(N/10)) = B1(1:round(M/10),1:round(N/10));
B3 = idct2(B2);
figure(3);
imshow(mat2gray(B3)); title('DCTed Image');
imwrite(B3,'baby_test.tif');