%figure(1)

sample_i = 0;
sample_ps = 1:length(time_points);%0:10:273+1; % should be subset of (time_points+1)
time_step = 1; % min
fps_per_time = 10;%ones(size(sample_ps))*10; % fps

intensity_raw = [intensity; intensity(end)];

fcmap = jet(length(sample_ps));


weight_max_freqs= [];
max_freqs = [];
weight_max_freqs24Hz = [];
burst_size = 600;
plot3d_spectra = zeros(burst_size/2, length(sample_ps));

for sample_p = sample_ps % number of time points
    
    
    
    sample_i = sample_i + 1;

    fs = fps_per_time;
    dt = 1/fs;
    
    sample_p = sample_p - 1;
    data = intensity_raw((sample_p*burst_size+1):(burst_size*sample_p+burst_size));
    samples_n = 1;

    t=((0:length(data)-1)')*dt;

    % building spectra
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
    X_mags_sm = X_mags(1:N_2,1:samples_n);
    % smooth via moving average@15 bins
    X_mags_sm(:, 1) = smooth(fax_Hz(1:N_2), X_mags_sm(:, 1), 15);    
   
    %figure(3);
    X_mags_sm = X_mags_sm-min(X_mags_sm);
    X_mags_sm = X_mags_sm/max(X_mags_sm);
    plot3d_spectra(:,sample_i) = X_mags_sm;
    
    

end
%h = figure;
%plot(fax_Hz(1:N_2), plot3d_spectra)
surf(time_points, fax_Hz(1:N_2), plot3d_spectra);
%imagesc(time_points, (fax_Hz(1:N_2)), plot3d_spectra);
view(2)
shading('flat')

%saveas(h,['../', datestr(clock,30),'_',sprintf('%09d', k),'.fig'])

