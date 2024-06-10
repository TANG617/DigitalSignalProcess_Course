clear all
clc
[x,Fsam]=audioread('D:\我的坚果云\教学\数字信号处理\滤波器设计\Ddiaohexian.wav');%得到音频，Fsam为抽样频率
fp=440;
fs=370;           %高通滤波器指标
Ap=1;
As=20;
Wp=1/(2*pi*fp);
Ws=1/(2*pi*fs);   %转换为低通指标 
w=linspace(0,1000*pi*2,1000);
%滤波器1的CBII型
[N,Wc]=cheb2ord(Wp,Ws,Ap,As,'s');%N为得到的阶数，Wc=Wp
[num,den]=cheby2(N,As,Wc,'s');%利用参数N，Wc，Ap确定分子多项式系数num和分母多项式系数den，此时为低通
[numt,dent]=lp2hp(num,den,1);%低通变成高通

[h,w]=freqs(numt,dent,w);%得到频率响应,此时为设计出的模拟高通滤波器
figure(1)
plot(w/(2*pi),abs(h));
%开始由模拟滤波器转到数字滤波器，采用双线性变换
[numd,dend]=bilinear(numt,dent,Fsam);%双线性变换，Fsam为抽样频率，numd为分子,dend为分母
[H,W]=freqz(numd,dend);%得到数字滤波器
figure(2);
plot(W*Fsam/(2*pi),abs(H));
figure(3);
zplane(numd,dend);%得到零极点图
%开始滤波
y=filter(numd,dend,x);%分子numd，分母dend对x进行滤波
Y=fftshift(fft(y));%fft快速傅里叶变换，fftshift将零频分量移到中心
ws=2*pi*Fsam;
L=length(x);
w2=(-ws/2+(0:L-1)*ws/L)/(2*pi);%得到转换后的频率
figure(4)
plot(w2,abs(Y));%得到滤波后的频谱图
 axis([-600 600 0 2000]);