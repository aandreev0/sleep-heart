window = 10; % 20 time samples are averaged

figure(1)
clf
mfreqs = zeros(16, 424);
for fish_n=1:16
    close all

	intensity = diff(timelapse_data(:,fish_n));
    spectr_plots; % tields plot3d_spectra
    max_freqs = [];
    s = size(plot3d_spectra);
    max_t  = s(2);
    for t = 1:max_t-window
        mf = mean(plot3d_spectra(:,t:(t+window)),2);
        freq_band = 175:N_2;
        w_avg_freq = sum(fax_Hz(freq_band).*mf(freq_band)) / sum(mf(freq_band));
        mf = w_avg_freq;
        %mf = fax_Hz(find(mf==max(mf)));
        max_freqs = [max_freqs, mf];
    end
    mfreqs(fish_n, :) = smooth(max_freqs, 50);
end

surf(1:424, 1:16, mfreqs)
%surf(1:423, 1:16, diff(mfreqs,1,2))
view(2)
shading flat

figure(2)
clf
diffs3d = diff(mfreqs,1,2);
%diffs3d(diffs3d>0) = 1;
%diffs3d(diffs3d<0) = -1;
%surf(1:423, 1:16, diffs3d)
colormap(cm1);
view(2)
shading flat

