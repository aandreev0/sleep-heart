img_m = img;
for f = 1:n_fish
    x = heart_coordinates(f,2);
    y = heart_coordinates(f,1);
    roi_rangeX = (x-radius):(x+radius);
    roi_rangeY = (y-radius):(y+radius);

    img_m(roi_rangeX, y - radius) = 10*img_m(roi_rangeX, y - radius);
    img_m(roi_rangeX, y + radius) = 10*img_m(roi_rangeX, y + radius);
    img_m(x-radius,   roi_rangeY) = 10*img_m(x-radius,   roi_rangeY);
    img_m(x+radius,   roi_rangeY) = 10*img_m(x+radius,   roi_rangeY);
end 

imshow(img_m,[0 50])
