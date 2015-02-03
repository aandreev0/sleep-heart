% build trace from first to last image

time_points = 0:10:273; % filenames: 0:(tn-1)
radius = 20;
ref_positions1 = []; % [x0 y0;x1 y1...]
ref_positions2 = []; % [x0 y0;x1 y1...]
'Select fish heart and follow it'
folder_name = 'Pos0/';
for i = 1:length(time_points)
    time_id = time_points(i);
    filename = ['img_', sprintf('%09d', time_id) ,'_Default_', sprintf('%03d', 0) ,'.tif'];
    
    img = imread([folder_name, filename]);
    if i>1
        x = ref_positions1(i-1,2);
        y = ref_positions1(i-1,1);
        roi_rangeX = (x-radius):(x+radius);
        roi_rangeY = (y-radius):(y+radius);
        img(roi_rangeX, y - radius) = 125;%ones(length(roi_rangeX), length(y-radius));
        img(roi_rangeX, y + radius) = 125;%ones(length(roi_rangeX), length(y+radius));
        img(x-radius,   roi_rangeY) = 125;%ones(length(x-radius),   length(roi_rangeY));
        img(x+radius,   roi_rangeY) = 125;%ones(length(x+radius),   length(roi_rangeY));
        img(x, y) = 0;
    end
    %imshow(img(vis_rangex,vis_rangey))
    imshow(img)
    xy = round(ginput(1));
    ref_positions1 = [ref_positions1; xy];
    %xy = ginput(1);
    %ref_positions2 = [ref_positions2; xy];
    ['Carry on, mate!', int2str(i), '/',int2str(length(time_points))]
end

ref_positions1 = [[0 0];diff(ref_positions1)];
%ref_positions2 = round(ref_positions2);

%diff(ref_positions2)