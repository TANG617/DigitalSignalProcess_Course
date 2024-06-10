clear all
clc
warning off
[x,Fs] = audioread('D:\我的坚果云\教学\数字信号处理\DFT分析\小星星_中.wav'); %音乐读取，Fs为采样率
N_downsample = 1; %采样率降低倍数
Fs = Fs/N_downsample; %降低采样率
x_mat = reshape(x,N_downsample,[]);
x = x_mat(1,:);
T = 1/Fs; %采样周期
t = 0:T:(length(x)-1)*T; %经历时间
f = Fs*t/((length(x)-1)*T); %频率
%% 音乐声音波形图展示与重建播放
% figure(1)
% plot(t,x); %声音波形图
% xlabel('时间（秒）')
% ylabel('波形')
% Frec = max(2*Fs,1000); %重建速率
% sound(x,Frec); %声音播放
%% 计算时域离散音乐信号的DFT频谱
% X = fft(x); %利用fft计算时域离散音乐信号的DFT频谱
% figure(2)
% plot(f,abs(X))
% xlabel('频率（Hz）')
% ylabel('幅度谱')
%% 计算第一个音调的DFT频谱，时域加窗
% x1 = x(1:length(x)/32); %第一个音调
% t1 = 0:T:(length(x1)-1)*T; %经历时间
% figure(3)
% plot(t1,x1); %声音波形图
% xlabel('时间（秒）')
% ylabel('波形')
% X1 = fft(x1); %对第一个音调的时域信号进行DFT得其频谱
% f1 = Fs*t1/((length(x)-1)*T); %频率
% figure(4)
% plot(f1,abs(X1))
% xlabel('频率（Hz）')
% ylabel('幅度谱')
%% 加窗对谐波信号进行频域加窗滤波
X = fft(x); %利用fft计算时域离散音乐信号的DFT频谱
rect_win = ones(1,length(X)); %低通滤波器设计，滤掉谐波频率，C大调谐波频率均在550Hz以上
rect_win(round(length(X)*(550/Fs))+1:length(X) - round(length(X)*(551.25/Fs))) = 0;
X_win = X.*rect_win;
x_win = ifft(X_win);
Frec = max(Fs,1000); %重建速率
sound(abs(x_win),Frec); %声音播放
figure(5)
plot(t,x_win); %声音波形图
xlabel('时间（秒）')
ylabel('波形')
%% 计算谐波滤波后第一个音调的DFT频谱，时域加窗
x1_win = x_win(1:length(x_win)/32); %第一个音调
t1 = 0:T:(length(x1_win)-1)*T; %经历时间
figure(6)
plot(t1,x1_win); %声音波形图
xlabel('时间（秒）')
ylabel('波形')
X1_win = fft(x1_win); %对第一个音调的时域信号进行DFT得其频谱
f1 = Fs*t1/((length(x1_win)-1)*T); %频率
figure(7)
plot(f1,abs(X1_win))
xlabel('频率（Hz）')
ylabel('幅度谱')