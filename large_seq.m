% extract heart beat traces from huge sequences
dont_plot = 1;
clear img_prev
n_fish = 1;
fps = 10;
radius = 12; % ROI heart radius
radius2 = 15;
cmap = jet;
folder_name = 'Pos0/';
time_points = 1:10; %(0:20);
burst_size = 600;
% file names: img_(time)_Default_(3, burst_position).tif
cc = [1 0 0];
timelapse_data = zeros(length(time_points)*burst_size, n_fish);
heart_coordinates = [];

for time_i = time_points
    
    % open image 0 from time stack
    time_i;
    filename = ['img_', sprintf('%09d', time_i) ,'_Default_', sprintf('%03d', 0) ,'.tif'];
    img = imread([folder_name, filename]);
    
    % let user pick hearts
    img_m = img;%ind2rgb(img, jet);
    
    % modify img to highlight hearts from prev picking
    if time_i==time_points(1)
        dont_plot = 0;
        figure(1)
        imshow(img)

        %plot_fish_boxes;
    end
    %h = msgbox(['Click on the plot to select '  n_fish ' fish hearts'])
    if time_i==time_points(1)
        c = 'Yes';
    else
        c = 'Auto';%questdlg('Refine heart positions?', 'Q', 'Yes', 'No','Auto','Yes');
    end
    c
    switch c
        case 'Yes'
            heart_coordinates = [];
            for f = 1:n_fish
                ['Defining heart coords for fish ', int2str(f),'...']
                xy = ginput(1);
                ['Defined']
                xy = ceil(xy);
                heart_coordinates = [heart_coordinates; xy];
                
            end
        case 'Auto'
            new_heart_coordinates = [];
            for f = 1:n_fish
                ['Auto heart position adjustment'];
                
                step = 2;
                epsi = 0.001;
                gradius = 20;
                image_1 = prev_img;
                image_2 = img;
                xy_start = heart_coordinates(f,:);
                
                gradlurk
                
                prev_coord = xy_2;
                
                new_heart_coordinates = [new_heart_coordinates; prev_coord];
               
            end
            heart_coordinates = new_heart_coordinates;
    end
    
    
    % extract intensity from picked hearts ROIs
    ['Work on #', int2str(time_i), ' time point']
    for j = 0:burst_size-1
        %if rand > 0.998
        %    [j time_i];
        %end
        filename = ['img_', sprintf('%09d', time_i) ,'_Default_', sprintf('%03d', j) ,'.tif'];
        img = imread([folder_name, filename]);
        %scan across fishes
        for f = 1:n_fish
            xy = [heart_coordinates(f, 2), heart_coordinates(f, 1)];
            timelapse_data(time_i*burst_size+j+1, f) = get_avg_signal(xy, img, radius);
        end
    end % for j = 1:burst_size-1
    
    clf
    prev_img = img;
    heart_coordinates
end % for time_i = time_points


img_m = img;
plot_fish_boxes;
imshow(img_m);
