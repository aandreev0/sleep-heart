%reg using imregister
tic
folder_name = '../../timelapse-2min_int_600framesBurst_1/Pos0/';
filename0 = ['img_', sprintf('%09d', 0) ,'_Default_', sprintf('%03d', 0) ,'.tif'];
%img0 = imread([folder_name, filename0]);

filename433 = ['img_', sprintf('%09d', 433) ,'_Default_', sprintf('%03d', 0) ,'.tif'];
%img433 = imread([folder_name, filename433]);

filename433_last = ['img_', sprintf('%09d', 433) ,'_Default_', sprintf('%03d', 599) ,'.tif'];
%img433_last = imread([folder_name, filename433_last]);


toc
tic
[optimizer, metric] = imregconfig('multimodal');
optimizer.InitialRadius = 0.001;
optimizer.Epsilon = 1e-4;
optimizer.GrowthFactor = 1.02;
optimizer.MaximumIterations = 300;
toc
tic
tform0_433 = imregtform(img433, img0, 'rigid', optimizer, metric);
toc
tic
img433_reg = imwarp(img433,tform0_433,'OutputView',imref2d(size(img0)));
img433_last_reg = imwarp(img433_last,tform0_433,'OutputView',imref2d(size(img0)));


toc
figure(1)
imshowpair(img0*10, img433_last_reg*10)
figure(2)
imshowpair(first_t_img*10, img*10)
