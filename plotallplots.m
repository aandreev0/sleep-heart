for kkk=1:n_fish
    intensity = joined_timelapse(:,kkk);
    intensity = diff(intensity);
    subplot(4,4,kkk);
    spectr_plots;
    
    set(gca, 'XTickLabel', {'8pm', '1am', '6am', '11am', '4pm', '9pm', '2am', '7am', '12pm'});
    set(gca, 'XTick', (0:100:840));
    ylabel 'Frequency, Hz';
    xlim([0 840]);

end

