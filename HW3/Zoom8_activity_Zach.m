% Zoom 8 activity 
% Load images - Inspect 

clear; clc; close; 

% Can look at original for a comparison point 
% figure; imshow(im2double(imread('test-pattern.tif')));


% Load images -- convert to double 
pattern = im2double(imread('test-pattern1.tif'));
% pattern = im2double(imread('dentalXray.tif'));
[M,N] = size(pattern); 

% % identify center row and column 
% r_mid = (M+1)/2; 
% c_mid = (N+1)/2; 


% Look at image histogram
figure; imshow(pattern) 
% figure; imhist(pattern) 

% Look at the FFT
pattern_fft = fftshift(fft2(pattern)); 
disp_fft = mat2gray(log(abs(pattern_fft)+1)); 
% figure; imshow(disp_fft);

% Try an averaging filter and median
pattern_avg = pattern; 
pattern_med = pattern; 
pattern_round = pattern; 

pattern2 = zeros(M+4,N+4); 
pattern2(3:(M+2),3:(N+2)) = pattern; 

% kern = ones(50); 
% 
% figure; imshow(kron(pattern(1:10,1:10),kern)); 
% figure; imshow(kron(pattern2(1:10,1:10),kern)); 

for i = 1:M
    for j = 1:N
        pattern_avg(i,j) = mean(mean(pattern2((i):(i+4),(j):(j+4)))); 
        pattern_med(i,j) = median(median(pattern2((i):(i+4),(j):(j+4)))); 

    end
end

% for i = 2:(M-1)
%     for j = 2:(N-1) 
%         
%         if pattern(i,j) < 0.32 
%             pattern_round(i,j) = 0.1; 
%         elseif pattern(i,j) < 0.6 
%             pattern_round(i,j) = 0.45; 
%         else
%             pattern_round(i,j) = 0.7; 
%         end
%         
%     end
% end
% figure; imshow(pattern_round); 

figure; imshow(pattern_avg); 
figure; imshow(pattern_med); 

