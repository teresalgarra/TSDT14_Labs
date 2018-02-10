clear;
clc;
close all;

N = 16;
Ts = 1;
dt = Ts/2^N;
fs = 1/dt;
x=randn(1,2^N);
X = (1/N)*fft(x);
Rx = 1;
T = Ts/2^N; %sampling length.
fc  = 1; %Si no funciona algo, igual aquí es 10
wc = 0.1;
fc_hd  = 1;

w = linspace(0,1,2^N);
n = linspace(0,2^N,2^N);

f = linspace(0,Ts,2^N);
t = linspace(0,Ts,2^N);

%Theoretical Calculations

%Ideal filter (rectangle)
space = linspace(0,99.99,10000);
H_th = zeros(size(X));
H_th(abs(space)<fc_hd) = 1;
h_th = ifft(H_th, 'symmetric');

%Filtered signal
Y_th = X.*H_th;
y_th = ifft(Y_th,'symmetric');

%First PSD
R_th = zeros(1,N);
R_th(abs(w) <wc ) = 1;
R_th(abs(w) >1-wc ) = 1;

%First System's PSD
R_th_1 = rectpuls((w-1/2)/(2*wc));

%Second System's PSD
R_th_2 = 1/4*(rectpuls((w-1/2)/(2*wc))) + 1/4*(rectpuls(w/(2*wc))+rectpuls((w-1)/(2*wc)));

%%Estimated functions%%

%10th degree filter
wc = 2*pi*fc;
[b,a] = butter(10,2*wc,'s');
H_es = (polyval(b,f)./polyval(a,f));
h_es = ifft(H_es, 'symmetric');

%Filtered signal
Y_es = X.*H_es;
y_es = ifft(Y_es,'symmetric');

%Systems
s1 = cos(pi*t);
s2 = cos(pi*t/2).*cos(pi*t/2);

%First System
y_es_1 = y_es.*s1;
Y_es_1 = abs(fft(y_es_1));

r_es_1_ba = es_bartlett(y_es_1);
R_es_1_ba = abs(fft(r_es_1_ba));

r_es_1_bl = es_blackman(y_es_1);
R_es_1_bl = abs(fft(r_es_1_bl));

%Second System
y_es_2 = y_es.*s2;
Y_es_2 = abs(fft(y_es_2));

r_es_2_ba = es_bartlett(y_es_2);
R_es_2_ba = abs(fft(r_es_2_ba));

r_es_2_bl = es_blackman(y_es_2);
R_es_2_bl = abs(fft(r_es_2_bl));

%%Smoothed Calculations%%

%First System%

%Rectangular window
r_es_1_ba_re = window_re(r_es_1_ba);
R_es_1_ba_re = abs(fft(r_es_1_ba_re));

r_es_1_bl_re = window_re(r_es_1_bl);
R_es_1_bl_re = abs(fft(r_es_1_bl_re));

%Triangular window
r_es_1_ba_tr = window_tr(r_es_1_ba);
R_es_1_ba_tr = abs(fft(r_es_1_ba_tr));

r_es_1_bl_tr = window_tr(r_es_1_bl);
R_es_1_bl_tr = abs(fft(r_es_1_bl_tr));

%Hamming window
r_es_1_ba_ha = window_ha(r_es_1_ba);
R_es_1_ba_ha = abs(fft(r_es_1_ba_ha));

r_es_1_bl_ha = window_ha(r_es_1_bl);
R_es_1_bl_ha = abs(fft(r_es_1_bl_ha));

%Bartlett window
r_es_1_ba_ba = window_ba(r_es_1_ba);
R_es_1_ba_ba = abs(fft(r_es_1_ba_ba));

r_es_1_bl_ba = window_ba(r_es_1_bl);
R_es_1_bl_ba = abs(fft(r_es_1_bl_ba));

%Blackmanharris window
r_es_1_ba_bl = window_bl(r_es_1_ba);
R_es_1_ba_bl = abs(fft(r_es_1_ba_bl));

r_es_1_bl_bl = window_bl(r_es_1_bl);
R_es_1_bl_bl = abs(fft(r_es_1_bl_bl));

%Second System%

%Rectangular window
r_es_2_ba_re = window_re(r_es_2_ba);
R_es_2_ba_re = abs(fft(r_es_2_ba_re));

r_es_2_bl_re = window_re(r_es_2_bl);
R_es_2_bl_re = abs(fft(r_es_2_bl_re));

%Triangular window
r_es_2_ba_tr = window_tr(r_es_2_ba);
R_es_2_ba_tr = abs(fft(r_es_2_ba_tr));

r_es_2_bl_tr = window_tr(r_es_2_bl);
R_es_2_bl_tr = abs(fft(r_es_2_bl_tr));

%Hamming window
r_es_2_ba_ha = window_ha(r_es_2_ba);
R_es_2_ba_ha = abs(fft(r_es_2_ba_ha));

r_es_2_bl_ha = window_ha(r_es_2_bl);
R_es_2_bl_ha = abs(fft(r_es_2_bl_ha));

%Bartlett window
r_es_2_ba_ba = window_ba(r_es_2_ba);
R_es_2_ba_ba = abs(fft(r_es_2_ba_ba));

r_es_2_bl_ba = window_ba(r_es_2_bl);
R_es_2_bl_ba = abs(fft(r_es_2_bl_ba));

%Blackmanharris window
r_es_2_ba_bl = window_bl(r_es_2_ba);
R_es_2_ba_bl = abs(fft(r_es_2_ba_bl));

r_es_2_bl_bl = window_bl(r_es_2_bl);
R_es_2_bl_bl = abs(fft(r_es_2_bl_bl));

%%%PLOT ZONE%%%

%%Theoretical Calculations%%

%%Systems%%

%Filter
figure;     %1
plot(w,H_es, 'm');
%Filter absolute value
figure;     %2
plot(w,abs(H_es), 'b');
%Filter in time domain
figure;     %3
plot(t,h_es, 'c');

%Filtered signal
figure;     %4
plot(f,Y_th, 'm');
%Filtered signal absolute value
figure;     %5
plot(f,abs(Y_th), 'b');
%Filtered signal in time domain
figure;     %6
plot(t,y_th, 'c');

%Initial PSD
figure;     %7
plot(w, R_th_1, 'm'); xlim([0,1]);

%First System PSD
figure;     %8
plot(w, R_th_1, 'm'); xlim([0,1]);

%Second System PSD
figure;     %9
plot(w, R_th_2, 'b'); xlim([0,1]);

%%Estimated Calculations%%

%Filtered signal
figure;     %10
plot(f,Y_es), 'm';
%Filtered signal absolute value
figure;     %11
plot(f,abs(Y_es), 'b');
%Filtered signal in time domain
figure;     %12
plot(t,y_es, 'c');
%First System in time domain
figure;     %13
plot(t,y_es_1, 'm');
%First System
figure;     %14
plot(t,Y_es_1, 'm');
%First System absolute value
figure;     %15
plot(t,abs(Y_es_1), 'm');
%Second System in time domain
figure;     %16
plot(t,y_es_2, 'm');
%Second System
figure;     %17
plot(t,Y_es_2, 'm');
%Second System absolute value
figure;     %18
plot(t,abs(Y_es_2), 'm');

%First System PSD
figure;     %19
plot(w, R_es_1_ba, 'b'); xlim([0,1]);
figure;     %20
plot(w, R_es_1_bl, 'c'); xlim([0,1]);

%Second System PSD
figure;     %21
plot(w, R_es_2_ba, 'b'); xlim([0,1]);
figure;     %22
plot(w, R_es_2_bl, 'c'); xlim([0,1]);

%%Smoothed Calculations%%

%%Smoothed Calculations%%

%First System PSD%

%Rectangular window
figure;     %23
plot(w, R_es_1_ba_re, 'm'); xlim([0,1]);
figure;     %24
plot(w, R_es_1_bl_re, 'b'); xlim([0,1]);

%Triangular window
figure;     %25
plot(w, R_es_1_ba_tr, 'm'); xlim([0,1]);
figure;     %26
plot(w, R_es_1_bl_tr, 'b'); xlim([0,1]);

%Hamming window
figure;     %27
plot(w, R_es_1_ba_ha, 'm'); xlim([0,1]);
figure;     %28
plot(w, R_es_1_bl_ha, 'b'); xlim([0,1]);

%Bartlett window
figure;     %29
plot(w, R_es_1_ba_ba, 'm'); xlim([0,1]);
figure;     %30
plot(w, R_es_1_bl_ba, 'b'); xlim([0,1]);

%Blackmanharris window
figure;     %31
plot(w, R_es_1_ba_bl, 'm'); xlim([0,1]);
figure;     %32
plot(w, R_es_1_bl_bl, 'b'); xlim([0,1]);

%Second System PSD%

%Rectangular window
figure;     %33
plot(w, R_es_2_ba_re, 'm'); xlim([0,1]);
figure;     %34
plot(w, R_es_2_bl_re, 'b'); xlim([0,1]);

%Triangular window
figure;     %35
plot(w, R_es_2_ba_tr, 'm'); xlim([0,1]);
figure;     %36
plot(w, R_es_2_bl_tr, 'b'); xlim([0,1]);

%Hamming window
figure;     %37
plot(w, R_es_2_ba_ha, 'm'); xlim([0,1]);
figure;     %38
plot(w, R_es_2_bl_ha, 'b'); xlim([0,1]);

%Bartlett window
figure;     %39
plot(w, R_es_2_ba_ba, 'm'); xlim([0,1]);
figure;     %40
plot(w, R_es_2_bl_ba, 'b'); xlim([0,1]);

%Blackmanharris window
figure;     %41
plot(w, R_es_2_ba_bl, 'm'); xlim([0,1]);
figure;     %42
plot(w, R_es_2_bl_bl, 'b'); xlim([0,1]);
