
% start program with getting reference image (very first one) and pick hearts
dir = '../../realtimeTest/test_1/Pos0/';
n_fish = 18;

heart_coordinates = [];

ref_image_name = ['img_', sprintf('%09d', 0) ,'_Default_', sprintf('%03d', 0) ,'.tif'];
ref_img = imread([dir, ref_image_name]);
imshow(ref_img, [0 30]); % some sort of auto adjust is important
for f = 1:n_fish
    ['Defining heart coords for fish ', int2str(f),'/',int2str(n_fish),'...']
    xy = ginput(1);
    xy = ceil(xy);
    heart_coordinates = [heart_coordinates; xy];
end
pause(1)
close all
pause(1)
'loading optimizer'
%load and setup register optimizer
[optimizer, metric] = imregconfig('multimodal');
optimizer.InitialRadius = 0.001;
optimizer.Epsilon = 1e-4;
optimizer.GrowthFactor = 1.02;
optimizer.MaximumIterations = 300;


fps = 10;
radius = 10; % ROI heart radius
cmap = jet;
burst_size = 600; % 0..599 files
curr_time_point = 0;
scan_delay = 60; % re-scan directory every 60 seconds, avg resolution of acquisition (600 frames@10fps, 2min interval between first frames)
timelapse_data = [];
while true
	% scan _dir_ for file curr_time_point___(burst_size-1).tif
	burst_end_filename = ['img_', sprintf('%09d', curr_time_point) ,'_Default_', sprintf('%03d', burst_size-1) ,'.tif'];
	if exist([dir, burst_end_filename]) > 0
        'New burst detected!'
        % cycle throught all images to get timelapses
        
        for j=0:burst_size-1
            filename = ['img_', sprintf('%09d', curr_time_point) ,'_Default_', sprintf('%03d', j) ,'.tif'];
            img = imread([dir, filename]);
            if j==0 % register only 1st image from burst, because in 1 min movement is minimal
                'set new tform'
                %tform = imregtform(img, ref_img, 'rigid', optimizer, metric);
            end
            %img = imwarp(img, tform, 'OutputView',imref2d(size(first_t_img)));
            
            % extract heart data
            
            fishes_signal = [];
            for f = 1:n_fish
                xy = [heart_coordinates(f, 2), heart_coordinates(f, 1)];
                fishes_signal = [fishes_signal, get_avg_signal(xy, img, radius)];
            end
            timelapse_data = [timelapse_data;fishes_signal];
        end
        
        'extracted heart beats'
        
        curr_time_point = curr_time_point + 1;
        if exist([dir, 'saves/'], 'dir')==0
            mkdir(dir, 'saves');
        end
        save([dir, 'saves/','RTAnalysis_',datestr(clock,30),'.mat']); % save workspace
        'Going to sleep'
        pause(scan_delay); %sleep for a while 
	end
        % optionally delete all files with time <= curr_time_point
end