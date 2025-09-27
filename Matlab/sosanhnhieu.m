% === Ch?n file âm thanh s?ch ===
[file_clean, path_clean] = uigetfile('*.wav', 'Chon file am thanh sach');
if isequal(file_clean, 0)
    error('Khong co file am thanh sach nao duoc chon!');
end

filename_clean = fullfile(path_clean, file_clean);
[clean_signal, fs] = audioread(filename_clean); % ??c tín hi?u âm thanh s?ch

% === Ch?n file âm thanh b? nhi?u ===
[file_noisy, path_noisy] = uigetfile('*.wav', 'Chon file am thanh bi nhieu');
if isequal(file_noisy, 0)
    error('Khong co file am thanh nhieu nao duoc chon!');
end

filename_noisy = fullfile(path_noisy, file_noisy);
[noisy_signal, ~] = audioread(filename_noisy); % ??c tín hi?u âm thanh b? nhi?u

% V? tín hi?u âm thanh tr??c và sau khi thêm nhi?u
figure;

% V? tín hi?u âm thanh s?ch
subplot(2, 1, 1);
plot(clean_signal(1:fs*5)); % V? 5 giây ??u tiên c?a tín hi?u s?ch
title('Tin hieu am thanh sach');
xlabel('Mau');
ylabel('Bien do');
axis tight;

% V? tín hi?u âm thanh b? nhi?u
subplot(2, 1, 2);
plot(noisy_signal(1:fs*5)); % V? 5 giây ??u tiên c?a tín hi?u b? nhi?u
title('Tin hieu am thanh bi nhieu');
xlabel('Mau');
ylabel('Bien ?o');
axis tight;
