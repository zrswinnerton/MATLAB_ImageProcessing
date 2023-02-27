%TEE 461 Image Processing
%Zach Swinnerton
%HW 4

clear all;
close all;
clc;

%Problem 1
C = im2double(imread("chalk-RGB.tif"));
R = C(:,:,1); %separate R component
G = C(:,:,2); %separate G component
B = C(:,:,3); %separate B component
figure(1);
imshow(R); title('Red');
figure(2);
imshow(G); title('Green');
figure(3);
imshow(B); title('Blue');
CR = C; %make CR copy of C
CG = C; %make CG copy of C
CB = C; %make CB copy of C

fsize = [9,9]; %kernel size
rmid = (fsize(1) + 1) / 2;
cmid = (fsize(2) + 1)/ 2;
dist = zeros(fsize(1),fsize(2)); 
%Euclidean distance matrix based on size of kernel
Gfilter = zeros(fsize(1),fsize(2));
%Guassian filter size of kernel
sigma = 3;

%Create Guassian filter from Euclidean distance matrix
for r = 1:fsize(1)
    for c = 1:fsize(2)
        dist(r,c) = sqrt((r - rmid)^2 + (c-cmid)^2);
        Gfilter(r,c) = exp(-.5 * ((dist(r,c) / sigma)^2));
    end
end

Gtot = sum(sum(Gfilter)); %Sum of all elements in Gfilter matrix
Gfilter = (Gfilter./(Gtot)); %Normalize Guassian filter

%create RGB gaussian filters
RGaus = conv2(R,Gfilter,"same"); %uses center matrix size of R
figure(4);
imshow(RGaus); title('Red LPFed');

GGaus = conv2(G,Gfilter,"same"); %uses center matrix size of G
figure(5);
imshow(GGaus); title('Green LPFed');

BGaus = conv2(B,Gfilter,"same"); %uses center matrix size of B
figure(6);
imshow(BGaus); title('Blue LPFed');

%show results
figure(7);
imshow(C); title('Original');

CR(:,:,1) = RGaus; %replace with new red component
figure(8);
imshow(CR); title('Guassian Low Pass Filter on Red');

CG(:,:,2) = GGaus; %replace with new green component
figure(9);
imshow(CG); title('Guassian Low Pass Filter on Green');

CB(:,:,3) = BGaus; %replace with new blue component
figure(10);
imshow(CB); title('Guassian Low Pass Filter on Blue');

%From the Low Pass Filtered images I noticed the most difference in the
%highlights of the brown chalks. For each filter the highlights/light
%reflections changed. For the Red Filter the highlights became more blue or
%cyan, for the Green Filter they became more pink or magenta, and for the
%Blue Filter they became more yellow. I also noticed for the Green Filter
%the whole image became less focused. This is probably because a majority
%of the edges and tray had green components that were filtered out.

clear all;
% close all;
clc;

%Problem 2
C = im2double(imread('chalk-RGB.tif'));
figure(11);
imshow(C); title('Original');
[H,S,I] = rgb2hsv(C); %separate H S I components
figure(12);
imshow(H); title('Hue');
figure(13);
imshow(S); title('Saturation');
figure(14);
imshow(I); title('Intensity');
[M,N,O] = size(C);
NewC = zeros([M,N,O]);

for r = 1:M
    for c = 1:N
        %Blue hue between 0.6 and 0.65, Yellow hue between 0.14 and 0.192
        if ((H(r,c) > 0.6 && H(r,c) < 0.65) && (S(r,c) > 0.37 && S(r,c) < 0.49) && (I(r,c) > 0.89 && I(r,c) <= 1))...
        || ((H(r,c) > 0.14 && H(r,c) < 0.2) && (S(r,c) > 0.2 && S(r,c) < 0.75) && (I(r,c) > 0.55 && I(r,c) <= 1))
            NewC(r,c,1:3) = C(r,c,1:3); %1:3 because need H,S,& I values at (r,c)
        else
            NewC(r,c,1:3) = 0.5; %make HSI value at (r,c) = gray
        end
    end
end
figure(15);
imshow(NewC); title('Segmented Chalk - Blue & Yellow');

%The selected chalk results are very close to expected. I was able to
%isolate the blue and yellow chalk. The yellow was easier to isolate since
%the hue was much different than the other chalks and the saturation and
%intensity were different than some of the chalk, so when combining all
%three expressions it was able to accurately narrow down to the yellow
%chalk. 
% 
%The blue chalk was pretty good at isolating that color but there
%were some issues with the tray having the same range of the hue,
%saturation, and intensity as the chalk. Overall I would say that this
%exercise was a success. If only using hue to isolate the colors it would
%prove difficult for bottom row of chalk since their hue values are very
%close on the spectrum. This is why I chose to use the combination of the
%three components to further isolate the colors.

clear all;
% close all;
clc;

%Problem 3
B = imread('baby.tif');
figure(16);
imshow(B); title('Original = 5.03MB');
% B = 812 x 812 pixels
% Size of B = (812*812) * 8 / (1024^2) = 5.03 MB
[M,N] = size(B);
B1 = dct2(B);
figure(17);
imshow(mat2gray(B1)); title('DCT Freq Content');
B2 = zeros(size(B));
B2(1:round(M*.2),1:round(N*.2)) = B1(1:round(M*.2),1:round(N*.2)); %162x162 kept is 20% of UL quadrant
% Size of B3 = ((162)*(162)) * 8 / (1024^2) = .2 MB TOO MUCH
B3 = idct2(B2);
figure(18);
imshow(mat2gray(B3)); title('DCTed Image using 20% = .2MB');

% 812*812*8 = 5274752 bits / 10 = 527475.2 bits GOAL / 8 = 65934.4
% sqrt(65934.4) = 256.77 about 256 to maintain slightly more than 1/10th
% 256/812 = .31527 about .315 for multiplication factor
B4 = zeros(size(B));
B4(1:round(M*.315),1:round(N*.315)) = B1(1:round(M*.315),1:round(N*.315)); %256x256 kept is 31.5% of UL quadrant
%Size of B3 = ((256)*(256)) * 8 / (1024^2) = .5 MB ACHIEVED GOAL
B5 = idct2(B4);
figure(19);
imshow(mat2gray(B5)); title('DCTed Image using 31.5% = .5MB');

% Compared to the original, the DCTed Image that is 1/10th the original a
% bit blurry with very little ringing. The only ringing I was able to see
% was at the bottom of the image near the baby's hand and around the
% vertical balloon string. The Happy Birthday ribbon is almost unreadable.
% Reverse calculating the necessary indexing to achieve 1/10th the original
% image resulted in a higher quality image than using the 20% approximation
% that was shown in the Panopto videos. The 20% approximation removed more
% details than necessary resulting in more noticeable ringing and blurriness.

clear all;
% close all;
clc;

%Problem 4
W = im2double(imread('wood-dowels-binary-noisy.tif'));
figure(20);
imshow(W); title('Original');
[M,N] = size(W);
B = [1,1,1;1,1,1;1,1,1]; %structure element

%Erosion
EroW = zeros(size(W));
for r = 2:M-1 %excluding edges as advised
    for c = 2:N-1 %excluding edges as advised
        if W(r-1:r+1,c-1:c+1) == B()
            EroW(r,c) = 1;
        end
    end
end
figure(21);
imshow(EroW); title('Erosion');

%Comparing to the original Erosion removes the stray white pixels outside
%of the wood dowel shapes, but increases the dark pixels inside of the
%shapes. This is because the structure element is a 3x3 and if any of the
%values in the 3x3 are zero then the algorithm skips this case and sets
%those pixels to zero.

%Dilation
DilW = zeros(size(W));
for r = 2:M-1 %excluding edges as advised
    for c = 2:N-1 %excluding edges as advised
        if W(r,c) == 1
            DilW(r-1:r+1,c-1:c+1) = 1;
        end
    end
end
figure(22);
imshow(DilW); title('Dilation');

%Comparing to the original image, Dilation removes the black pixels within
%the wooden dowels due to the structure element replacing them with all
%ones. It also increases the stray white pixel sizes outside the wooden
%dowels due to this structure element detecting a one and setting that window
%to a 3x3 of all ones.

%Opening - First Erosion, then Dilation
OpenW = zeros(size(W));
Temp1W = zeros(size(W));
for r = 2:M-1 %excluding edges as advised
    for c = 2:N-1 %excluding edges as advised
        if W(r-1:r+1,c-1:c+1) == B()
            Temp1W(r,c) = 1;
        end
    end
end

for r = 2:M-1 %excluding edges as advised
    for c = 2:N-1 %excluding edges as advised
        if Temp1W(r,c) == 1
            OpenW(r-1:r+1,c-1:c+1) = 1;
        end
    end
end
figure(23);
imshow(OpenW); title('Opening');

% Comparing to the original, Opening removes the stray white pixels outside
% the wooden dowels, and does not increase the black pixel noise inside of
% the shapes. It does however in some cases increase the gaps between white
% pixels. For example the small wooden dowel about the second row in from
% the left has more black gaps due to opening algorithm effects.

%Closing - First Dilation, then Erosion
ClosW = zeros(size(W));
Temp2W = zeros(size(W));
for r = 2:M-1 %excluding edges as advised
    for c = 2:N-1 %excluding edges as advised
        if W(r,c) == 1
            Temp2W(r-1:r+1,c-1:c+1) = 1;
        end
    end
end

for r = 2:M-1 %excluding edges as advised
    for c = 2:N-1 %excluding edges as advised
        if Temp2W(r-1:r+1,c-1:c+1) == B()
            ClosW(r,c) = 1;
        end
    end
end
figure(24);
imshow(ClosW); title('Closing');

%Comparing to the original, Closing removes the dark pixels inside of the
%wooden dowel shapes but does not remove the stray white pixels outside of
%the shapes. Also it connects a few of the wooden dowels that are very
%close due to this smoothing effect of sharp corners.
