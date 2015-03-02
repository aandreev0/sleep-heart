% extract heart beat traces from huge sequences
%save workspace here:
ws_file_name = 'SecondDay_3Fish_10Tstep';

n_fish = 16;
fps = 10;
radius = 10; % ROI heart radius
cmap = jet;
folder_name = '../../timelapse-2min_int_600framesBurst_1/Pos0/';
%time_points = (0:20); % physical file behind that
burst_size = 600;
% file names: img_(time)_Default_(3, burst_position).tif
cc = [1 0 0];
timelapse_data = zeros(length(time_points)*burst_size, n_fish);
%heart_coordinates = [];



%register optimizer
[optimizer, metric] = imregconfig('multimodal');
optimizer.InitialRadius = 0.001;
optimizer.Epsilon = 1e-4;
optimizer.GrowthFactor = 1.02;
optimizer.MaximumIterations = 300;


filename = ['img_', sprintf('%09d', 0) ,'_Default_', '000.tif'];
first_t_img = imread([folder_name, filename]);

for time_i = 1:length(time_points)
    tic
    % open image 0 from time stack
    [time_i length(time_points)]
    time_id = time_points(time_i);
    filename = ['img_', sprintf('%09d', time_id) ,'_Default_', sprintf('%03d', 0) ,'.tif'];
    img = imread([folder_name, filename]);
    toc
    %register and store tform
    tic
    'registering...'
    toc
    %
    
    
    toc
    
    % extract intensity from picked hearts ROIs
    tform = imregtform(img, first_t_img, 'rigid', optimizer, metric);
    img = imwarp(img, tform,'OutputView',imref2d(size(first_t_img)));
    
    for j = 0:burst_size-1
        filename = ['img_', sprintf('%09d', time_id) ,'_Default_', sprintf('%03d', j) ,'.tif'];
        img = imread([folder_name, filename]);
        img = imwarp(img, tform, 'OutputView',imref2d(size(first_t_img)));

        
        for f = 1:n_fish
            xy = [heart_coordinates(f, 2), heart_coordinates(f, 1)];
            timelapse_data((time_i-1)*burst_size+j+1, f) = get_avg_signal(xy, img, radius);
        end
        
        
    end % for j = 1:burst_size-1
    if rand>0.9
        save(['logs/',ws_file_name,'_',datestr(clock,30),'.mat'])
    end
    %prev_t_img = img;
    toc
    


end % for time_i = time_points


  save(['logs/',ws_file_name,'_',datestr(clock,30),'.mat'])
