% Homework 1 Solutions 
% By: Mike McCourt
% April 1

clear; close; clc


%% Problem 1a

astro = imread('astronaut.tif');
astro2 = astro(1:2:end,1:2:end); 

figure; imshow(astro); 
figure; imshow(astro2); 

% Problem 1b
astro5 = astro(1:5:end,1:5:end); 
figure; imshow(astro5); 



%% Problem 2a
rose = imread('rose_LR.tif');
[r,c] = size(rose);

rose2 = uint8(zeros(2*r-1,2*c-1));
rose2(1:2:end,1:2:end) = rose;

for i=1:2:(2*r-2)
    for j=1:2:(2*c-2)
        rose2(i,j+1) = rose2(i,j)/2+rose2(i,j+2)/2;
        rose2(i+1,j) = rose2(i,j)/2+rose2(i+2,j)/2;
        rose2(i+1,j+1) = rose2(i,j)/4+rose2(i,j+2)/4+rose2(i+2,j)/4+rose2(i+2,j+2)/4;
    end
end

figure; imshow(rose); 
figure; imshow(rose2)


%% Problem 2b
[r,c] = size(rose2);
rose4 = uint8(zeros(2*r-1,2*c-1));
rose4(1:2:end,1:2:end) = rose2;


for i=1:2:(2*r-2)
    for j=1:2:(2*c-2)
        rose4(i,j+1) = rose4(i,j)/2+rose4(i,j+2)/2;
        rose4(i+1,j) = rose4(i,j)/2+rose4(i+2,j)/2;
        rose4(i+1,j+1) = rose4(i,j)/4+rose4(i,j+2)/4+rose4(i+2,j)/4+rose4(i+2,j+2)/4;
    end
end

figure; imshow(rose4); 


%% Problem 3
rose = imread('rose_LR.tif');
rose_invert = 255-rose; 
figure; imshow(rose_invert); 


%% Problem 4a (Solutions will vary)
r = 0:0.001:1;
gamma = 0.4; 
s = r.^gamma;

% Problem 4b 
plot(r,s); hold on; 
plot(r,r,'--'); 
title('Transformation to increase brightness'); 

% Problem 4c
astro2 = double(astro)/255; 
astro_bright = astro2.^gamma; 
astro_bright2 = uint8(255*astro_bright); 
figure; imshow(astro); 
figure; imshow(astro_bright2); 

% Problem 4d (Depends on results)


%% Problem 5a (Solutions will vary)
x = 0:0.001:1; 
Tr = atan(4*(x-0.5))/2.23+0.5;

% Problem 5b 
plot(x,Tr); hold on; 
plot(r,r,'--'); 
title('Transformation to increase contrast'); 

% Problem 5c 
astro_contrast = atan(4*(astro2-0.5))/2.23+0.5;
astro_contrast2 = uint8(255*astro_contrast); 
figure; imshow(astro); 
figure; imshow(astro_contrast2); 


% Problem 5d (Depends on results)
