% % 读取音频文件
% [y, Fs] = audioread('yueyin2.wav'); % y是音频样本数据，Fs是采样率
% 
% % 选择一个通道（如果是立体声）
% y = y(:, 1);
% 
% % 计算FFT
% Y = fft(y);
% 
% % 计算频率轴（只绘制正频率部分）
% L = length(y); % 信号长度
% f = Fs * (0:(L/2)) / L; % 频率轴
% 
% % 计算双边频谱的幅度
% P2 = abs(Y / L);
% 
% % 获取单边频谱的幅度（由于信号为实数，其FFT是对称的）
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% 
% % 绘制频谱
% figure;
% plot(f, P1) 
% title('Single-Sided Amplitude Spectrum of y(t)')
% xlabel('Frequency (Hz)')
% ylabel('|P1(f)|')
% 
% % 打印基本的频谱信息
% disp('基本的频谱信息已显示。');


% 读取音频文件
[y, Fs] = audioread('yueyin2.wav');
y = y(:,1); % 取单声道

% 短时傅里叶变换（STFT）
win = 1024; % 窗口大小
overlap = 512; % 重叠样本数
nfft = 1024; % FFT点数
[S, F, T] = spectrogram(y, win, overlap, nfft, Fs);

% 显示频谱图
figure;
surf(T, F, 20*log10(abs(S)), 'EdgeColor', 'none');
axis tight;
view(0, 90);
xlabel('Time (Seconds)');
ylabel('Frequency (Hz)');
title('Spectrogram');
colorbar;

% 基频检测
pitch = pitch(y, Fs);
disp('检测到的基频：');
disp(pitch);

% 绘制基频随时间变化
figure;
plot(pitch);
title('Pitch Tracking');
xlabel('Frames');
ylabel('Frequency (Hz)');
