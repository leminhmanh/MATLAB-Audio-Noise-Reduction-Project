% === chon file am thanh ===
[file, path] = uigetfile('C:\Users\Admin\Downloads\noisy_audio', 'Chon file am thanh de xu ly');
if isequal(file, 0)
    error('Khong co file nao duoc chon!');
end

filename = fullfile(path, file);

[signal, fs] = audioread(filename); 
% Neu tin hieu là stereo, chuyen thanh mono
if size(signal, 2) == 2
    signal = mean(signal, 2);  
end

% Bien doi Fourier (FFT) 
N = length(signal);          
Y = fft(signal);            

% Tao vector tan so
f = (0:N-1)*(fs/N);         

% Lay biên do cua pho tan so
Y_mag = abs(Y);             

% Tim tan so có bien do lon nhat (tan so chinh)
[~, idx_max] = max(Y_mag);  % Tìm vi tri có biên do lon nhat
dominant_frequency = f(idx_max);  % Tan so chinh

% In ra tan so chinh
disp(['Tan so chinh cua tin hieu la: ', num2str(dominant_frequency), ' Hz']);

% Hien thi thong tin am thanh
disp(['Tan so mau (fs): ', num2str(fs), ' Hz']);
%isp(['Do dai tin hieu: ', num2str(length(signal) / fs), ' giay']);

% Hien thi tin hieu goc
t = (0:length(signal)-1) / fs; 

figure;

plot(t, signal);
title('Tin hieu goc');
xlabel('Thoi gian (s)');
ylabel('Bien do');
grid on;

% === Ap dung cac bo loc ===

% 1. Bo loc thong thap (Low-Pass Filter)
fc_low = 1000; % Tan so cat 
[b_low, a_low] = butter(6, fc_low / (fs/2), 'low'); % Thiet ke bo loc bac 6
signal_low = filter(b_low, a_low, signal); % Ap dung bo loc


% 2. Bo loc thong cao (High-Pass Filter)
fc_high = 100; % Tan so cat  Hz
[b_high, a_high] = butter(6, fc_high / (fs/2), 'high'); % Thiet ke bo loc bac 6
signal_high = filter(b_high, a_high, signal); % Ap dung bo loc



% 3. Bo loc chan dai (Notch Filter)
fc_notch = 50; % Tan so  (50 Hz)
Q = 30; % Chi so chat luong cua bo loc
wo = fc_notch / (fs/2); % Tan s goc chuan hoa
bw = wo / Q; 
[b_notch, a_notch] = iirnotch(wo, bw); % Thiet ke bo loc
signal_notch = filter(b_notch, a_notch, signal); % Ap dung bo loc


% === Ket hop các bo loc ===
signal_filtered = filter(b_low, a_low, filter(b_high, a_high, filter(b_notch, a_notch, signal)));

% Hien thi tin hieu da loc
figure;

plot(t, signal_filtered);
title('Tin hieu sau loc');
xlabel('Thoi gian (s)');
ylabel('Bien do');
grid on;
t = 0:1/fs:1; % Thoi gian
clean_signal = sin(2*pi*1000*t); % Sine wave v?i t?n s? 1000 Hz

% === Tinh cong suat tin hieu va nhieu ===
% Cong suat tin hieu sau loc
P_signal = sum(signal_filtered.^2) / length(signal_filtered);

% Tin hieu nhieu la phan chenh lech giua tin hieu goc va tin hieu sau loc
noise = signal - signal_filtered;

% Cong suat nhieu
P_noise = sum(noise.^2) / length(noise);

% === Tinh SNR ===
if P_noise == 0
    warning('Cong suat nhieu bang 0, khong the tinh SNR!');
else
    SNR = 10 * log10(P_signal / P_noise);
    disp(['SNR (tin hieu sau loc) la: ', num2str(SNR), ' dB']);
end

% === Luu tin hieu da loc ===
output_folder = uigetdir('C:\Users\Admin\Downloads\ESC-50-master\output');
if output_folder == 0
    error('Khong co thu muc nao duoc chon!');
end

% Tao ten file 
timestamp = datestr(now, 'yyyymmdd_HHMMSS');
output_filename = fullfile(output_folder, ['filtered_audio_' timestamp '.wav']);

audiowrite(output_filename, signal_filtered, fs);
disp(['Tin hieu da xu ly duoc luu tai: ', output_filename]);




