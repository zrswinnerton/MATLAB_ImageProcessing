%TEE 461 Image Processing
%Zach Swinnerton
%HW 1

clear all;
close all;
clc;

%Problem 1
A = imread('astronaut.tif'); 
%A = 1650x2000 pixels
siz = size(A);

A2 = A(1:2:end,1:2:end); 
%Downsample by 2 = 1/2 as many rows and columns
%A2 should be (1650x2000)/2 = 825x1000 pixels

A5 = A(1:5:end,1:5:end); 
%Downsample by 5 = 1/5 as many rows and columns
%A5 should be (1650x2000)/5 = 330x400 pixels

%side by side comparison
figure(1);
subplot(1,3,1);
imshow(A);
title('Original');

subplot(1,3,2);
imshow(A2);
title('Downsampled by 2');

subplot(1,3,3);
imshow(A5);
title('Downsampled by 5');

%individual images
figure(2);
imshow(A);
title('Original');

figure(3);
imshow(A2);
title('Downsampled by 2');

figure(4);
imshow(A5);
title('Downsampled by 5');

clear all;
%close all;
clc;

%Problem 2 - Part 1
R = double(imread('rose_LR.tif'))/255;
%R = 240x256 pixels
w = size(R,1); %240 pixels wide
h = size(R,2); %256 pixels high

%linear interpolation by 2
R2 = double(zeros([2*size(R)]));

R2(1:2:end,1:2:end) = R(:,:); %known pixels added every odd location
% ___________________    _____________________________________
% | 1,1 | 1,2 | 1,3 |    | 1,1 | U.H | 1,2 | U.H | 1,3 | U.H |
% |_____|_____|_____|    |_____|_____|_____|_____|_____|_____|
% | 2,1 | 2,2 | 2,3 |    | U.V | U.C | U.V | U.C | U.V | U.C |
% |_____|_____|_____| -> |_____|_____|_____|_____|_____|_____|
% | 3,1 | 3,2 | 3,3 |    | 2,1 | U.H | 2,2 | U.H | 2,3 | U.H |
% |_____|_____|_____|    |_____|_____|_____|_____|_____|_____|
%                        | U.V | U.C | U.V | U.C | U.V | U.C |
%                        |_____|_____|_____|_____|_____|_____|
%                        | 3,1 | U.H | 3,2 | U.H | 3,3 | U.H |
%                        |_____|_____|_____|_____|_____|_____|
%                        | U.V | U.C | U.V | U.C | U.V | U.C |
%                        |_____|_____|_____|_____|_____|_____|
%
for r = 1:(w-1) %rows
    for c = 1:(h-1) %columns
        %unknown horizontal pixel
        R2((2*r-1),2*c) = .5*(R(r,c) + R(r,c+1)); 
        %unknown vertical pixel
        R2(2*r,(2*c-1)) = .5*(R(r,c) + R(r+1,c)); 
        %unknown center pixel
        R2(2*r,2*c) = .25*(R(r,c) + R(r,c+1) + R(r+1,c) + R(r+1,c+1)); 
    end
end

figure(6);
imshow(R);
title('Original');

figure(7)
imshow(R2);
title('Linear Interpolation by 2');

clear all;
%close all;
clc;

%Problem 2 - Part 2
R = double(imread('rose_LR.tif'))/255;
RO = double(imread('rose_LR.tif'))/255;
%R = 240x256 pixels
%R4 = 960x1024 pixels

%linear interpolation by 4 = (linear interpolatation by 2)x2
for loop = 1:2
    w = size(R,1); %pixels wide
    h = size(R,2); %pixels high
    R4 = double(zeros([2*size(R)]));
    
    R4(1:2:end,1:2:end) = R(:,:); %known pixels added every odd location
    % _____________    _________________________________________________
    % | 1,1 | 1,2 |    | 1,1 |     | U.H |     | 1,2 |     | U.H |     |
    % |_____|_____| -> |_____|_UH2_|_____|_____|_____|_UH2_|_____|_____|
    % | 2,1 | 2,2 |    |     |     |     |     |     |     |     |     |
    % |_____|_____|    |_UV2_|_UC2_|_____|_____|_UV2_|_UC2_|_____|_____|
    %                  | U.V |     | U.C |     | U.V |     | U.C |     |
    %                  |_____|_____|_____|_____|_____|_____|_____|_____|
    %                  |     |     |     |     |     |     |     |     |
    %                  |_____|_____|_____|_____|_____|_____|_____|_____|
    %                  | 2,1 |     | U.H |     | 2,2 |     | U.H |     |
    %                  |_____|_____|_____|_____|_____|_____|_____|_____|
    %                  |     |     |     |     |     |     |     |     |
    %                  |_____|_____|_____|_____|_____|_____|_____|_____|
    %                  | U.V |     | U.C |     | U.V |     | U.C |     |
    %                  |_____|_____|_____|_____|_____|_____|_____|_____|
    %                  |     |     |     |     |     |     |     |     |
    %                  |_____|_____|_____|_____|_____|_____|_____|_____|
    
    for r = 1:(w-1) %rows
        for c = 1:(h-1) %columns
            %unknown horizontal pixel
            R4((2*r-1),2*c) = .5*(R(r,c) + R(r,c+1)); 
            %unknown vertical pixel
            R4(2*r,(2*c-1)) = .5*(R(r,c) + R(r+1,c)); 
            %unknown center pixel
            R4(2*r,2*c) = .25*(R(r,c) + R(r,c+1) + R(r+1,c) + R(r+1,c+1)); 
        end
    end
    R = double(zeros([2*size(R)])); %reset R to be doubled blank image
    R(:,:) = R4(:,:); %remap 1st iterpolation image to original and repeat
end

figure(8);
imshow(RO);
title('Original');

figure(9)
imshow(R4);
title('Linear Interpolation by 4');

clear all;
%close all;
clc;

%Problem 3
R = double(imread('rose_LR.tif'))/255;
IR = 1-R; %inverted

%side by side comparison
figure(10);
subplot(1,2,1);
imshow(R);
title('Original');

subplot(1,2,2);
imshow(IR);
title('Inverted');

%individual images
figure(11);
imshow(R);
title('Original');

figure(12);
imshow(IR);
title('Inverted');

clear all;
%close all;
clc;

%Problem 4
b15 = (1/1.5);
b2 = (1/2);

r = 0:0.001:1; %range
s1 = r.^b15; %brighten by 1.5 variable
s2 = r.^b2; %brighten by 2 variable
plot(r,s1,'g',r,s2,'r',r,r,'b--'); %ensure that 0 & 1 mapped properly
title('Pixel Mapping Graph');
legend({'Brighten 1.5','Brighten 2','Identity'},'Location','southeast');

A = double(imread('astronaut.tif'))/255; %Cast as double then divide 
AB15 = A.^b15; %brighten image by 1.5
AB2 = A.^b2; %brighten image by 2

%side by side comparison
figure(13);
subplot(1,3,1);
imshow(A);
title('Original');

subplot(1,3,2);
imshow(AB15);
title('Brighten by 1.5');

subplot(1,3,3);
imshow(AB2);
title('Brighten by 2');

%individual images
figure(14);
imshow(A);
title('Original');

figure(15);
imshow(AB15);
title('Brighten by 1.5');

figure(16);
imshow(AB2);
title('Brighten by 2');

%From these results I think that 'Brighten by 1.5' was the best image. By
%brightening the image slightly we can see more detail in the rock's
%darker face and detail in the astronaut's suit that were previously too
%dark to see those details. 'Brighten by 2' was too much and seemed to be
%washed out in my opinion.

clear all;
%close all;
clc;

%Problem 5
r = 0:0.001:1; %range
s1 = .6366*atan(2*(r - .5)) + .5;
s2 = .42005*atan(5*(r - .5)) + .5; 
s3 = .36405*atan(10*(r - .5)) + .5;
s4 = .33987*atan(20*(r - .5)) + .5; 
plot(r,s1,'y',r,s2,'g',r,s3,'c',r,s4,'r',r,r,'b--'); %ensure 0 & 1 mapped
title('Pixel Mapping Graph');
legend({'A1','A2','A3','A4','Identity'},'Location','southeast');

A = double(imread('astronaut.tif'))/255; %Cast as double then divide 
%A = 1650x2000 pixels
w = size(A,1); %1650 pixels wide
h = size(A,2); %2000 pixels high


for r = 1:w %rows
    for c = 1:h %columns
        A1(r,c) = .6366*atan(2*(A(r,c) -.5)) + .5;
        A2(r,c) = .42005*atan(5*(A(r,c) - .5)) + .5;
        A3(r,c) = .36405*atan(10*(A(r,c) - .5)) + .5;
        A4(r,c) = .33987*atan(20*(A(r,c) - .5)) + .5;
    end
end

%side by side comparison
figure(17);
subplot(3,2,1);
imshow(A);
title('Original');

subplot(3,2,2);
imshow(A1);
title('Contrast v1'); %slightly better than original

subplot(3,2,3);
imshow(A2);
title('Contrast v2');

subplot(3,2,4);
imshow(A3);
title('Contrast v3');

subplot(3,2,5);
imshow(A4);
title('Contrast v4');

%individual images
figure(18);
imshow(A);
title('Original');

figure(19);
imshow(A1);
title('Contrast v1');

figure(20);
imshow(A2);
title('Contrast v2');

figure(21);
imshow(A3);
title('Contrast v3');

figure(22);
imshow(A4);
title('Contrast v4');

%After reviewing the results, I feel that 'Contrast v1' was the best image.
%This image was slightly better than the original in my opinion because it
%shows a bit more depth and detail in the background soil of the moon. The
%background terrain seems less washed out with the greater contrast and
%range of values to display for those pixels. All other contrast images
%seemed too harsh.
