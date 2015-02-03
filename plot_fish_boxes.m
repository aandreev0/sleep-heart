for f = 1:n_fish
    x = heart_coordinates(f,2);
    y = heart_coordinates(f,1);
    roi_rangeX = (x-radius):(x+radius);
    roi_rangeY = (y-radius):(y+radius);
    %{
    img_m(roi_rangeX, y - radius) = 125;%ones(length(roi_rangeX), length(y-radius));
    img_m(roi_rangeX, y + radius) = 125;%ones(length(roi_rangeX), length(y+radius));
    img_m(x-radius,   roi_rangeY) = 125;%ones(length(x-radius),   length(roi_rangeY));
    img_m(x+radius,   roi_rangeY) = 125;%ones(length(x+radius),   length(roi_rangeY));
    %}
    img_m(roi_rangeX, y - radius) = 2*img_m(roi_rangeX, y - radius);%ones(length(roi_rangeX), length(y-radius));
    img_m(roi_rangeX, y + radius) = 2*img_m(roi_rangeX, y + radius);%ones(length(roi_rangeX), length(y+radius));
    img_m(x-radius,   roi_rangeY) = 2*img_m(x-radius,   roi_rangeY);%ones(length(x-radius),   length(roi_rangeY));
    img_m(x+radius,   roi_rangeY) = 2*img_m(x+radius,   roi_rangeY);%ones(length(x+radius),   length(roi_rangeY));
end 

if dont_plot==0
    imshow(img_m)
end