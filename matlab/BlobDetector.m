%% Function to detect blobs in a given image
%% Arbitary threshold values for different images
% sunflowers.jpg = 0.01
% butterfly.jpg = 0.01
% einstein.jpg = 0. 005
% fishes.jpg = 0.0075
% bluerose.jpeg = 0.005
% rocks.jpg=0.01
% smile.png = 0.005
% eyes.jpg = 0.01

%% Change input image in line 23
%% Change threshold in line 34
%% Change between downsampling and filter size on line 83
%% Add/ Modify sigma values in line 30 - logScales
%% Change k -> factor on line 33

clc;
clear;
close all;

tic
img=imread('butterfly.jpg');
original_image=img;
img=rgb2gray(img);
img=im2double(img);


%% Input Parameters
logScales      = [2 4 8 16 20 24 28 32 50]; % value of sigma
sigma=logScales(1); %% Initial value %%
LOG=sigma*sigma*fspecial('log',2*ceil(3*sigma)+1,logScales(1));
k=1.5; 
threshold=0.01; %% threshold value


%% Down sampling method for creating scaleSpace_ds
factor=k;
img_ds=img;

fprintf('\n Downsampling: ');
tic;

for i=1:1:length(logScales)
    green=imfilter(img_ds,LOG,'replicate');
    green=green.^2;
    if i==1
        scaleSpace_ds=green;
    end
    if i>1
        green=imresize(green,size(img),'bicubic'); %Interpolation with bicubic option
        scaleSpace_ds=cat(3,scaleSpace_ds,green);
    end
    img_ds=imresize(img,1/factor,'bicubic'); % down-sampling image with bicubic option
    factor=k^(i);
end
toc

fprintf('\n Changing filter size for scaleSpace : ');
tic;


%% Changing Filter Size for creation of scaleSpace
i=1;
for sigma=logScales
    LOG=fspecial('log',2*ceil(3*sigma)+1,sigma);
    blue=sigma*sigma*imfilter(img,LOG);
    
    blue=blue.^2;
    Gaussian{i,1}=blue;
    %figure(i);
    %imshow(Gaussian{i,1});  To Visualize the scale space
    if i==1
        scaleSpace=Gaussian{i};
    end
    if i>1
        scaleSpace=cat(3,scaleSpace,Gaussian{i}); % 3- Dimensional array with the output
    end
    i=i+1;
end
toc;

%% Choosing which method for non maximum suppression
% scaleSpace_ds-->downsampling and scaleSpace-->Changing filter size
scaleSpace_ds=scaleSpace_ds;

%% Non-Maximum Suppression for each 2D scale Space

fprintf('\n Non-Maximum Suppression : ');
tic
i=1;
for sigma=logScales
    a=ordfilt2(scaleSpace_ds(:,:,i),25,ones(5,5),'zeros');
    B{i}=a;
    if i==1
        Op=B{i};
    end
    if i>1
        Op=cat(3,Op,B{i}); % 3- Dimensional array with the output
    end
    i=i+1;
    
end


%% Non-Maximum Supression Across Scale Space - 3D

for i=1:length(logScales)
    if i>1
        if i==length(logScales)
            Op(:,:,i)=max(Op(:,:,i-1:i),[],3);
            continue;
        end
        Op(:,:,i)=max(Op(:,:,i-1:i+1),[],3);
    end
    if i==1
        Op(:,:,i)=max(Op(:,:,i:i+1),[],3);
    end
end
Op = Op .* (Op == scaleSpace_ds);
toc;

%% Finding co-ordinates for maxima
fprintf('\n Finding co-ordinates : ');
tic;

[Adhere,i]=max(Op>=threshold,[],3);
[row,col]=find(Adhere);
clear sigma
for idx=1:1:length(row)
    sigma(idx)=i(row(idx),col(idx));
end
sigma=sigma';

for idx=1:1:length(row)
    sigma(idx)=logScales(sigma(idx)); % Copying sigma into radii
end
sigma=sigma./(2^(1.1));
toc


%% Show blobs by calling show_all_circles

fprintf('\n Show_all_circles : ');
tic
show_all_circles(original_image,col,row,sigma,'red',1.5);
toc;
