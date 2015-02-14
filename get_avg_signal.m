function s=get_avg_signal(qq, img, radius)
    roi_rangeX = round((qq(1)-radius):(qq(1)+radius));
    roi_rangeY = round((qq(2)-radius):(qq(2)+radius));
    
    
    
    s = mean(mean(img(roi_rangeX, roi_rangeY)));
end