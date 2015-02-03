% extract heart beat traces from huge sequences
%save workspace here:
ws_file_name = 'SecondDay_3Fish_10Tstep';

n_fish = 6;
fps = 10;
radius = 8; % ROI heart radius
cmap = jet;
folder_name = '../Pos0/';
%time_points = (0:20); % physical file behind that
burst_size = 600;
% file names: img_(time)_Default_(3, burst_position).tif
cc = [1 0 0];
timelapse_data = zeros(length(time_points)*burst_size, n_fish);
heart_coordinates = [];

for time_i = 1:length(time_points)
    tic
    % open image 0 from time stack
    [time_i length(time_points)]
    time_id = time_points(time_i);
    filename = ['img_', sprintf('%09d', time_id) ,'_Default_', sprintf('%03d', 0) ,'.tif'];
    img = imread([folder_name, filename]);
    img_m = img;
    toc
    
    if time_i==1
        c = 'Yes';
    else
        c = 'Auto';%questdlg('Refine heart positions?', 'Q', 'Yes', 'No','Yes');
    end
    
    
    
    switch c
        case 'Yes'
            heart_coordinates = [];
            imshow(img_m);
            for f = 1:n_fish
                
                ['Defining heart coords for fish ', int2str(f),'/',int2str(n_fish),'...']
                xy = ginput(1);
                ['Defined']
                xy = ceil(xy);
                heart_coordinates = [heart_coordinates; xy];
                
                %timelapse_data(time_i*burst_size+1, f) = get_avg_signal(xy, img, radius);
            end
            close all
            pause(1)
        case 'Auto'
            for f = 1:n_fish
                heart_coordinates(f,:) = heart_coordinates(f,:) + ref_positions1(time_i,:);
            end
    end
    toc
    
    % extract intensity from picked hearts ROIs
    for j = 0:burst_size-1
        filename = ['img_', sprintf('%09d', time_id) ,'_Default_', sprintf('%03d', j) ,'.tif'];
        img = imread([folder_name, filename]);
        for f = 1:n_fish
            xy = [heart_coordinates(f, 2), heart_coordinates(f, 1)];
            timelapse_data((time_i-1)*burst_size+j+1, f) = get_avg_signal(xy, img, radius);
        end
        if rand > 0.999
            toc
        end
    end % for j = 1:burst_size-1
    save([ws_file_name,'_',datestr(clock,30),'.mat'])
    toc
end % for time_i = time_points
