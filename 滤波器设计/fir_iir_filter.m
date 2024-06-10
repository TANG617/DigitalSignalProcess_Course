% 读取音频信号
[dhexian, Fs] = audioread('Ddiaohexian.wav');

% 1. 设计IIR数字滤波器

% 1.1 确定IIR数字滤波器的设计指标
Wp = 2*440/Fs; % 通带截止频率
Ws = 2*370/Fs; % 阻带截止频率
Rp = 1; % 通带最大衰减(dB)
Rs1 = 20; % 阻带最小衰减(dB)
Rs2 = 40;
Rs3 = 50;

% 1.2 设计CBI型IIR数字滤波器
[n1, Wn1] = cheb1ord(Wp, Ws, Rp, Rs1);
[b1, a1] = cheby1(n1, Rp, Wn1);

[n2, Wn2] = cheb1ord(Wp, Ws, Rp, Rs2);
[b2, a2] = cheby1(n2, Rp, Wn2);

[n3, Wn3] = cheb1ord(Wp, Ws, Rp, Rs3);
[b3, a3] = cheby1(n3, Rp, Wn3);

% 绘制CBI型IIR数字滤波器的频率响应并保存图像
figure;
[H1, f] = freqz(b1, a1, 1024, Fs);
plot(f, 20*log10(abs(H1)));
title('CBI型IIR滤波器 (Rs=20 dB) 的频率响应');
xlabel('频率 (Hz)');
ylabel('幅度 (dB)');
saveas(gcf, 'CBI_IIR_20dB.png');

figure;
[H2, f] = freqz(b2, a2, 1024, Fs);
plot(f, 20*log10(abs(H2)));
title('CBI型IIR滤波器 (Rs=40 dB) 的频率响应');
xlabel('频率 (Hz)');
ylabel('幅度 (dB)');
saveas(gcf, 'CBI_IIR_40dB.png');

figure;
[H3, f] = freqz(b3, a3, 1024, Fs);
plot(f, 20*log10(abs(H3)));
title('CBI型IIR滤波器 (Rs=50 dB) 的频率响应');
xlabel('频率 (Hz)');
ylabel('幅度 (dB)');
saveas(gcf, 'CBI_IIR_50dB.png');

% 1.3 设计BW型、CBI型、CBII型和椭圆型IIR数字滤波器 (满足指标1)
[n_bw, Wn_bw] = buttord(Wp, Ws, Rp, Rs1);
[b_bw, a_bw] = butter(n_bw, Wn_bw);

[n_cbi, Wn_cbi] = cheb1ord(Wp, Ws, Rp, Rs1);
[b_cbi, a_cbi] = cheby1(n_cbi, Rp, Wn_cbi);

[n_cbii, Wn_cbii] = cheb2ord(Wp, Ws, Rp, Rs1);
[b_cbii, a_cbii] = cheby2(n_cbii, Rs1, Wn_cbii);

[n_elip, Wn_elip] = ellipord(Wp, Ws, Rp, Rs1);
[b_elip, a_elip] = ellip(n_elip, Rp, Rs1, Wn_elip);

% 绘制各类型IIR滤波器的零极点分布图并保存图像
figure;
zplane(b_bw, a_bw);
title('BW型IIR滤波器的零极点分布图');
saveas(gcf, 'BW_IIR_Zplane.png');

figure;
zplane(b_cbi, a_cbi);
title('CBI型IIR滤波器的零极点分布图');
saveas(gcf, 'CBI_IIR_Zplane.png');

figure;
zplane(b_cbii, a_cbii);
title('CBII型IIR滤波器的零极点分布图');
saveas(gcf, 'CBII_IIR_Zplane.png');

figure;
zplane(b_elip, a_elip);
title('椭圆型IIR滤波器的零极点分布图');
saveas(gcf, 'Ellip_IIR_Zplane.png');

% 1.4 比较不同滤波器的阶数和零极点分布特点
% 阶数比较
disp(['BW型IIR滤波器的阶数: ', num2str(n_bw)]);
disp(['CBI型IIR滤波器的阶数: ', num2str(n_cbi)]);
disp(['CBII型IIR滤波器的阶数: ', num2str(n_cbii)]);
disp(['椭圆型IIR滤波器的阶数: ', num2str(n_elip)]);

% 2. 设计FIR数字滤波器

% 2.1 确定FIR数字滤波器的设计参数
N = 100; % 滤波器阶数
Wn = 440/(Fs/2); % 截止频率

% 2.2 使用窗函数法设计FIR数字滤波器
b_hann = fir1(N, Wn, hann(N+1));
b_hamming = fir1(N, Wn, hamming(N+1));
b_blackman = fir1(N, Wn, blackman(N+1));

% 绘制不同窗函数设计的FIR滤波器的频率响应并保存图像
figure;
[H_hann, f] = freqz(b_hann, 1, 1024, Fs);
plot(f, 20*log10(abs(H_hann)));
title('使用汉宁窗设计的FIR滤波器的频率响应');
xlabel('频率 (Hz)');
ylabel('幅度 (dB)');
saveas(gcf, 'Hann_FIR.png');

figure;
[H_hamming, f] = freqz(b_hamming, 1, 1024, Fs);
plot(f, 20*log10(abs(H_hamming)));
title('使用汉明窗设计的FIR滤波器的频率响应');
xlabel('频率 (Hz)');
ylabel('幅度 (dB)');
saveas(gcf, 'Hamming_FIR.png');

figure;
[H_blackman, f] = freqz(b_blackman, 1, 1024, Fs);
plot(f, 20*log10(abs(H_blackman)));
title('使用布莱克曼窗设计的FIR滤波器的频率响应');
xlabel('频率 (Hz)');
ylabel('幅度 (dB)');
saveas(gcf, 'Blackman_FIR.png');

% 2.3 使用凯泽窗和Parks-McClellan算法设计FIR滤波器
b_kaiser = fir1(N, Wn, kaiser(N+1, 0.5));
% 修改频带定义，确保频带间隔
b_pm = firpm(N, [0 Wn-0.01 Wn+0.01 1], [1 1 0 0]);

% 绘制凯泽窗和Parks-McClellan设计的FIR滤波器的频率响应并保存图像
figure;
[H_kaiser, f] = freqz(b_kaiser, 1, 1024, Fs);
plot(f, 20*log10(abs(H_kaiser)));
title('使用凯泽窗设计的FIR滤波器的频率响应');
xlabel('频率 (Hz)');
ylabel('幅度 (dB)');
saveas(gcf, 'Kaiser_FIR.png');

figure;
[H_pm, f] = freqz(b_pm, 1, 1024, Fs);
plot(f, 20*log10(abs(H_pm)));
title('使用Parks-McClellan算法设计的FIR滤波器的频率响应');
xlabel('频率 (Hz)');
ylabel('幅度 (dB)');
saveas(gcf, 'Parks_McClellan_FIR.png');

% 3. 比较IIR和FIR数字滤波器

% 3.1 比较相同指标IIR和FIR数字滤波器的阶数
disp(['IIR滤波器阶数: ', num2str(n_cbi)]);
disp(['FIR滤波器阶数: ', num2str(N)]);

% 3.2 绘制IIR和FIR数字滤波器的相位响应并保存图像
figure;
subplot(2, 1, 1);
phasez(b_cbi, a_cbi, 1024, Fs);
title('IIR滤波器的相位响应');
saveas(gcf, 'IIR_Phase_Response.png');

subplot(2, 1, 2);
phasez(b_hann, 1, 1024, Fs);
title('FIR滤波器的相位响应');
saveas(gcf, 'FIR_Phase_Response.png');

% 4.应用滤波器

% 应用IIR滤波器
filtered_signal_iir = filter(b_cbi, a_cbi, dhexian);

% 应用FIR滤波器
filtered_signal_fir = filter(b_hann, 1, dhexian);

% 绘制原始信号和滤波后信号的频谱并保存图像
figure;
subplot(3, 1, 1);
pwelch(dhexian, [], [], [], Fs);
title('原始信号的频谱');
saveas(gcf, 'Original_Signal_Spectrum.png');

subplot(3, 1, 2);
pwelch(filtered_signal_iir, [], [], [], Fs);
title('IIR滤波后信号的频谱');
saveas(gcf, 'IIR_Filtered_Spectrum.png');

subplot(3, 1, 3);
pwelch(filtered_signal_fir, [], [], [], Fs);
title('FIR滤波后信号的频谱');
saveas(gcf, 'FIR_Filtered_Spectrum.png');