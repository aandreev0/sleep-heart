sample_i = 0;

sample_ps = 1:1;
fps_per_time = 10;

intensity_raw = [intensity; intensity(end,:)];
fcmap = jet(length(sample_ps));

weight_max_freqs= [];
max_freqs = [];
weight_max_freqs24Hz = [];


for sample_p = sample_ps
    sample_i = sample_i + 1;

    fs = fps_per_time;
    dt = 1/fs;
    
    sample_p = sample_p - 1;
    data = intensity_raw(:, sample_i);
    samples_n = 1;

    t=((0:length(data)-1)')*dt;

    norm_data = data - repmat(mean(data), length(t), 1);
    norm_data = norm_data./repmat(max(norm_data), length(t), 1);
    
   
    % building spectra
    
    figure(33);
    %clf

    signal = data(:,:);
    % HAMMING
    %signal = (hamming(length(signal))-0.08).*signal;
    
    N = length(signal);
    fnyquist = fs/2; %Nyquist frequency

    X_mags = (abs(fft(signal)));

    X_mags = X_mags ./ repmat(sum(X_mags), length(t), 1);
    bin_vals = [0 : N-1]';
    fax_Hz = bin_vals*fs/N;
    N_2 = ceil(N/2);

    X_mags = X_mags(1:N_2, 1:samples_n);

    X_mags_sm = smooth(fax_Hz(1:N_2), X_mags, 11);    
    
    plot(fax_Hz(1:N_2), X_mags_sm,'-r')
    colorbar
    %caxis(([min(sample_ps) max(sample_ps)]))
    
    xlabel('Frequency, Hz')
    ylabel('Magnitude, a.u.');
    title('Single-sided Magnitude spectrum (Hertz)');
    hold on
    
    %plotAVI = addframe(plotAVI,spectr_fig);


end

xlim