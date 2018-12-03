
clear all;
[c,fs]=audioread('clear_speech.wav');
c=c';
v=audioread('noise_source.wav');
v_=audioread('structured_noise_source.wav');
s1=audioread('speech_and_noise_through_room_1.wav');
s2=audioread('speech_and_noise_through_room_2.wav');
s1_=audioread('speech_and_structured_noise_through_room_1.wav');
s2_=audioread('speech_and_structured_noise_through_room_2.wav');
t=length(c);

%% NLMS

for mu=0.05:0.05:1.95
    i=int8(mu*20);
    [e1(i,:),~]=NLMS_(s1,v,mu,200,1);
    [e2(i,:),~]=NLMS_(s2,v,mu,200,1);
    [e1_(i,:),~]=NLMS_(s1_,v_,mu,200,1);
    [e2_(i,:),~]=NLMS_(s2_,v_,mu,200,1);
    ASE1(i)=ASE(c,e1(i,:));
    
    ASE2(i)=ASE(c,e2(i,:));

    ASE1_(i)=ASE(c,e1_(i,:));
  
    ASE2_(i)=ASE(c,e2_(i,:));
  
end

mu=0.05:0.05:1.95;
cSE1=ASE(c,s1');
cSE2=ASE(c,s2');
cSE1_=ASE(c,s1_');  
cSE2_=ASE(c,s2_');   
figure;
plot(mu,ASE1,'b',mu,cSE1*ones(1,length(mu)),'r');
ylabel('Average square error NLMS for room1');
xlabel('mu');
legend('nlms residual','e=s');
[~,i1]=min(ASE1);
display('minimum ASE1 is at mu=',num2str(i1/20));

figure;
plot(mu,ASE2,'b',mu,cSE2*ones(1,length(mu)),'r');
ylabel('Average square error NLMS for room2');
xlabel('mu');
legend('nlms residual','e=s');
[~,i2]=min(ASE2);
display('minimum ASE is at mu=',num2str(i2/20));

figure;
plot(mu,ASE1_,'b',mu,cSE1_*ones(1,length(mu)),'r');
ylabel('Average square error NLMS for room1 with structed noise');
xlabel('mu');
legend('nlms residual','e=s');
[~,i1_]=min(ASE1_);
display('minimum ASE is at mu=',num2str(i1_/20));

figure;
plot(mu,ASE2_,'b',mu,cSE2_*ones(1,length(mu)),'r');
ylabel('Average square error NLMS for room2 with structed noise');
xlabel('mu');
legend('nlms residual','e=s');
[~,i2_]=min(ASE2_);
display('minimum ASE is at mu=',num2str(i2_/20));

%%
figure;
subplot(3,1,1)
plot(c);
title('Origin signal(to be recovered)');
ylabel('room1 audio data');
axis([1,t,-0.2,0.2]);

subplot(3,1,2)
plot(s1);
title('Input signal');
ylabel('room1 audio data');

subplot(3,1,3)
plot(e1(i1,:));
title('Recovered signal');
ylabel('room1 audio data');
xlabel('time t');
axis([1,t,-0.2,0.2]);

figure;
subplot(3,1,1)
plot(c);
title('Origin signal(to be recovered)');
ylabel('room1 audio structured_noise_data');
axis([0,t,-0.2,0.2]);

subplot(3,1,2)
plot(s1_);
title('Input signal');
ylabel('room1 audio structured_noise_data');

subplot(3,1,3)
plot(e1_(i1_,:));
title('Recovered signal');
ylabel('room1 audio structured_noise_data');
xlabel('time t');
axis([1,t,-0.2,0.2]);

figure;
subplot(3,1,1)
plot(c);
title('Origin signal(to be recovered)');
ylabel('room2 audio data');
axis([1,t,-0.2,0.2]);

subplot(3,1,2)
plot(s2);
title('Input signal');
ylabel('room2 audio data');

subplot(3,1,3)
plot(e2(i2,:));
title('Recovered signal');
ylabel('room2 audio data');
xlabel('time t');
axis([1,t,-0.2,0.2]);

figure;

subplot(3,1,1)
plot(c);
title('Origin signal(to be recovered)');
ylabel('room2 audio structured_noise_data');
axis([1,t,-0.2,0.2]);

subplot(3,1,2)
plot(s2_);
title('Input signal');
ylabel('room2 audio structured_noise_data');

subplot(3,1,3)
plot(e2_(i2_,:));
title('Recovered signal');
ylabel('room2 audio structured_noise_data');
xlabel('time t');
axis([1,t,-0.2,0.2]);
%% RLS

    ff=0.999:0.0001:1
for i=1:length(ff)
    delta = 100;
    % finish the implementation of RLS_alg()
    [e21,~]=RLS_alg(s1,v,200,ff(i),delta);
    [e22,~]=RLS_alg(s2,v,200,ff(i),delta);
    [e21_,~]=RLS_alg(s1_,v_,200,ff(i),delta);
    [e22_,~]=RLS_alg(s2_,v_,200,ff(i),delta);
    ASE21(i)=ASE(c,e21');
    ASE22(i)=ASE(c,e22');
    ASE21_(i)=ASE(c,e21_');
    ASE22_(i)=ASE(c,e22_');
end
    AS21=ASE(c,s1');
    AS22=ASE(c,s2');
    AS21_=ASE(c,s1_');
    AS22_=ASE(c,s2_');

figure;
plot(ff,ASE21,'b',ff,AS21*ones(1,length(ff)),'r');
ylabel('Average square error RLS for room1');
xlabel('ff');
legend('rls residual','e=s');
[~,i21]=min(ASE21);
display('minimum ASE is at ff= ',num2str(ff(i21)));

figure;
plot(ff,ASE22,'b',ff,AS22*ones(1,length(ff)),'r');
ylabel('Average square error RLS for room2');
xlabel('ff');
legend('rls residual','e=s');
[~,i22]=min(ASE22);
display('minimum ASE is at ff=',num2str(ff(i22)));

figure;
plot(ff,ASE21_,'b',ff,AS21_*ones(1,length(ff)),'r');
ylabel('Average square error RLS for room1 with structed noise');
xlabel('ff');
legend('rls residual','e=s');
[~,i21_]=min(ASE21_);
display('minimum ASE is at ff=',num2str(ff(i21_)));

figure;
plot(ff,ASE22_,'b',ff,AS22_*ones(1,length(ff)),'r');
ylabel('Average square error RLS for room2 with structed noise');
xlabel('ff');
legend('rls residual','e=s');
[~,i22_]=min(ASE22_);
display('minimum ASE is at ff=',num2str(ff(i22_)));


%%
figure;
subplot(3,1,1)
plot(c);
title('Origin signal(to be recovered)');
ylabel('room1 audio data');
axis([0 t -0.2,0.2]);
subplot(3,1,2)
plot(s1);
title('Input signal');
ylabel('room1 audio data');
subplot(3,1,3)
plot(e21);
title('Recovered signal');
ylabel('room1 audio data');
xlabel('time t');
axis([0 t -0.2,0.2]);

figure;
subplot(3,1,1)
plot(c);
title('Origin signal(to be recovered)');
ylabel('room1 audio structured_noise_data');
axis([0 t -0.2,0.2]);
subplot(3,1,2)
plot(s1_);
title('Input signal');
ylabel('room1 audio structured_noise_data');
subplot(3,1,3)
plot(e21_);
title('Recovered signal');
ylabel('room1 audio structured_noise_data');
xlabel('time t');
axis([0 t -0.2,0.2]);

figure;
subplot(3,1,1)
plot(c);
title('Origin signal(to be recovered)');
ylabel('room2 audio data');
axis([0 t -0.2,0.2]);
subplot(3,1,2)
plot(s2);
title('Input signal');
ylabel('room2 audio data');
subplot(3,1,3)
plot(e22);
title('Recovered signal');
ylabel('room2 audio data');
xlabel('time t');
axis([0 t -0.2,0.2]);

figure;
subplot(3,1,1)
plot(c);
title('Origin signal(to be recovered)');
ylabel('room2 audio structured_noise_data');
axis([0 t -0.2, 0.2]);
subplot(3,1,2)
plot(s2_);
title('Input signal');
ylabel('room2 audio structured_noise_data');
subplot(3,1,3)
plot(e22_);
title('Recovered signal');
ylabel('room2 audio structured_noise_data');
xlabel('time t');
axis([0 t -0.2,0.2]);

%% segment and Ls

    
for seg=1:10
    [e31,~]=SegLS(s1,v,200,seg);
    [e32,~]=SegLS(s2,v,200,seg);
    [e31_,~]=SegLS(s1_,v_,200,seg);
    [e32_,~]=SegLS(s2_,v_,200,seg);
    ASE31(seg)=ASE(c,e31(end-length(v)+1:end)');
    ASE32(seg)=ASE(c,e32(end-length(v)+1:end)');
    ASE31_(seg)=ASE(c,e31_(end-length(v)+1:end)');
    ASE32_(seg)=ASE(c,e32_(end-length(v)+1:end)');
end
    AS31=ASE(c,s1');
    AS32=ASE(c,s2');
    AS31_=ASE(c,s1_');
    AS32_=ASE(c,s2_');
    
seg=1:10
[~,i31]=min(ASE31);
display('minimum ASE is at seg= ',num2str(seg(i31)));
figure;
plot(seg,ASE31,'b',seg,AS31*ones(1,length(seg)),'r');
ylabel('Average square error LS for room1');
xlabel('seg');
legend('ls residual','e=s');

figure;
plot(seg,ASE32,'b',seg,AS32*ones(1,length(seg)),'r');
ylabel('Average square error LS for room2');
xlabel('seg');
legend('ls residual','e=s');
[~,i32]=min(ASE32);
display('minimum ASE is at seg=',num2str(seg(i32)));

figure;
plot(seg,ASE31_,'b',seg,AS31_*ones(1,length(seg)),'r');
ylabel('Average square error LS for room1 with structed noise');
xlabel('seg');
legend('ls residual','e=s');
[~,i31_]=min(ASE31_);
display('minimum ASE is at seg=',num2str(seg(i31_)));

figure;
plot(seg,ASE32_,'b',seg,AS32_*ones(1,length(seg)),'r');
ylabel('Average square error RLS for room2 with structed noise');
xlabel('seg');
legend('ls residual','e=s');
[~,i32_]=min(ASE32_);
display('minimum ASE is at seg=',num2str(sg(i32_)));


%%
figure;
subplot(3,1,1)
title('Origin signal(to be recovered)');
ylabel('room1 audio data');
axis([0 t -0.5,0.5]);
plot(c);
subplot(3,1,2)
title('Input signal');
ylabel('room1 audio data');
plot(s1);
subplot(3,1,3)
plot(e31);
title('Recovered signal');
ylabel('room1 audio data');
xlabel('time t');
axis([0 t -0.5,0.5]);

figure;
subplot(3,1,1)
title('Origin signal(to be recovered)');
ylabel('room1 audio structured_noise_data');
axis([0 t -0.5,0.5]);
plot(c);
subplot(3,1,2)
title('Input signal');
ylabel('room1 audio structured_noise_data');
plot(s1_);
subplot(3,1,3)
plot(e31_);
title('Recovered signal');
ylabel('room1 audio structured_noise_data');
xlabel('time t');
axis([0 t -0.5,0.5]);

figure;
subplot(3,1,1)
title('Origin signal(to be recovered)');
ylabel('room2 audio data');
axis([0 t -0.5,0.5]);
plot(c);
subplot(3,1,2)
title('Input signal');
ylabel('room2 audio data');
plot(s2);
subplot(3,1,3)
plot(e32);
title('Recovered signal');
ylabel('room2 audio data');
xlabel('time t');
axis([0 t -0.5,0.5]);

figure;
subplot(3,1,1)
title('Origin signal(to be recovered)');
ylabel('room2 audio structured_noise_data');
axis([0 t -0.5,0.5]);
plot(c);
subplot(3,1,2)
title('Input signal');
ylabel('room2 audio structured_noise_data');
plot(s2_);
subplot(3,1,3)
plot(e32_);
title('Recovered signal');
ylabel('room2 audio structured_noise_data');
xlabel('time t');
axis([0 t -0.5,0.5]);

%% choose the order
M = 150:25:300;

mu = 0.3;
ff =  0.9998;
delta = 100;
a = 1;
K = length(M);
FPE_eval_nlms = zeros(1, K);
AIC_eval_nlms = zeros(1, K);
MDL_eval_nlms = zeros(1, K);
FPE_eval_rls = zeros(1, K);
AIC_eval_rls = zeros(1, K);
MDL_eval_rls = zeros(1, K);

NrOfTrails = 10;
FPE_nlms = zeros(NrOfTrails, 1);
AIC_nlms = zeros(NrOfTrails, 1);
MDL_nlms = zeros(NrOfTrails, 1);

FPE_rls = zeros(NrOfTrails, 1);
AIC_rls = zeros(NrOfTrails, 1);
MDL_rls = zeros(NrOfTrails, 1);
N1 = length(s1);

EE_nlms = [];
EE_rls = [];

% here choose  desired and input signal respectively(I here only test the not structured noise, can change them into s_ and v_ for constructed noise rooms)  
d1=s1;
d2=s2;
d_1=s1_;
d_2=s2_;
u1=v;
u2=v_;

% order estimation using three different ways
for k=1:K

    [e_nlms1,~] = NLMS_(d1, u1, mu, M(k), a);
    [e_nlms2,~] = NLMS_(d2, u1, mu, M(k), a);
    E_nlms1(k) = var(e_nlms1);
    E_nlms2(k) = var(e_nlms2);

    FPE_eval_nlms1(k) = (N1 + M(k))/(N1 - M(k))*E_nlms1(k);
    FPE_eval_nlms2(k) = (N1 + M(k))/(N1 - M(k))*E_nlms2(k);
    AIC_eval_nlms1(k) = N1 * log(E_nlms1(k)) + 2*M(k);
    AIC_eval_nlms2(k) = N1 * log(E_nlms2(k)) + 2*M(k);
    MDL_eval_nlms1(k) = N1 * log(E_nlms1(k)) + M(k)*log(N1);
    MDL_eval_nlms2(k) = N1 * log(E_nlms2(k)) + M(k)*log(N1);


    [e_rls1, ~] = RLS_alg(d1, u1, M(k), ff, delta);
    [e_rls2, ~] = RLS_alg(d2, u1, M(k), ff, delta);
    E_rls1(k) = var(e_rls1);
    E_rls2(k) = var(e_rls2);
    FPE_eval_rls1(k) = (N1 + M(k))/(N1 - M(k))*E_rls1(k);
    FPE_eval_rls2(k) = (N1 + M(k))/(N1 - M(k))*E_rls2(k);
    AIC_eval_rls1(k) = N1 * log(E_rls1(k)) + 2*M(k);
    AIC_eval_rls2(k) = N1 * log(E_rls2(k)) + 2*M(k);    
    MDL_eval_rls1(k) = N1 * log(E_rls1(k)) + M(k)*log(N1);
    MDL_eval_rls2(k) = N1 * log(E_rls2(k)) + M(k)*log(N1);
end
%%

[~, id1] = min(FPE_eval_nlms1)
optimal_M_for_s1 = M(id1);
[~, id2] = min(FPE_eval_nlms2)
optimal_M_for_s2 = M(id2);
[~, id21] = min(AIC_eval_nlms1)
optimal_M_for_s1 = M(id21);
[~, id22] = min(AIC_eval_nlms2)
optimal_M_for_s2 = M(id22);
[~, id31] = min(MDL_eval_nlms1)
optimal_M_for_s1 = M(id31);
[~, id32] = min(MDL_eval_nlms2)
optimal_M_for_s2 = M(id32);
[~, ID1] = min(FPE_eval_rls1)
optimal_M_for_s1 = M(ID1);
[~, ID2] = min(FPE_eval_rls2)
optimal_M_for_s2 = M(ID2);
[~, ID21] = min(AIC_eval_rls1)
optimal_M_for_s1 = M(ID21);
[~, ID22] = min(AIC_eval_rls2)
optimal_M_for_s2 = M(ID22);
[~, ID31] = min(MDL_eval_rls1)
optimal_M_for_s1 = M(ID31);
[~, ID32] = min(MDL_eval_rls2)
optimal_M_for_s2 = M(ID32);

figure,
subplot 311,
plot(M,FPE_eval_nlms1)
title('NLMS FPE');
xlabel('The order M')
ylabel('FPE evaluation')
subplot 312,
plot(M,AIC_eval_nlms1)
title('NLMS AIC');
xlabel('The order M')
ylabel('AIC evaluation')
subplot 313,
plot(M, MDL_eval_nlms1)
title('NLMS MDL');
xlabel('The order M')
ylabel('MDL evaluation')
suptitle('speech and noise through room 1');

figure,
subplot 311,
plot(M,FPE_eval_nlms2)
title('NLMS FPE');
xlabel('The order M')
ylabel('FPE evaluation')
subplot 312,
plot(M,AIC_eval_nlms2)
title('NLMS AIC');
xlabel('The order M')
ylabel('AIC evaluation')
subplot 313,
plot(M, MDL_eval_nlms2)
title('NLMS MDL');
xlabel('The order M')
ylabel('MDL evaluation')
suptitle('speech and noise through room 2');


figure,
subplot 311,
plot(M,FPE_eval_rls1);
title('RLS FPE');
xlabel('The order M')
ylabel('FPE evaluation')

subplot 312,
plot(M,AIC_eval_rls1)
title('RLS AIC');
xlabel('The order M')
ylabel('AIC evaluation')

subplot 313,
plot(M,MDL_eval_rls1)
title('RLS MDL');
xlabel('The order M')
ylabel('MDL evaluation')
suptitle('speech and noise through room 1');

figure,
subplot 311,
plot(M,FPE_eval_rls2);
title('RLS FPE');
xlabel('The order M')
ylabel('FPE evaluation')

subplot 312,
plot(M,AIC_eval_rls2)
title('RLS AIC');
xlabel('The order M')
ylabel('AIC evaluation')

subplot 313,
plot(M,MDL_eval_rls2)
title('RLS MDL');
xlabel('The order M')
ylabel('MDL evaluation')
suptitle('speech and noise through room 2');


%% spectral estimation

mu = 0.3; 
a = 1;
M = 200;
nfft = 1024;

[e1, w1] = NLMS_(s1, v, mu, M, a);
[e2, w2] = NLMS_(s2, v, mu, M, a);
[e3, w3] = NLMS_(s1_, v_, mu, M, a);
[e4, w4] = NLMS_(s2_, v_, mu, M, a);

delta = 100;
ff = 0.9998;
[e_1, w_1] = RLS_alg(s1, v, M, ff, delta);
[e_2, w_2] = RLS_alg(s2, v, M, ff, delta);
[e_3, w_3] = RLS_alg(s1_, v_, M, ff, delta);
[e_4, w_4] = RLS_alg(s2_, v_, M, ff, delta);


% plot the spectrogram of all the signals here I only plot the effect for
% nlms, change the e to e_ then you can get the one for rls

figure
subplot 131
spectrogram(c, M, M/2, nfft, fs)
title('clear speech');
colorbar('EastOutside')

subplot 132
spectrogram(v, M, M/2, nfft, fs)
title('noise source');
colorbar('EastOutside')

subplot 133
spectrogram(v_, M, M/2, nfft, fs)
title('structured noise source');
colorbar('EastOutside')

subplot 221
spectrogram(s1, M, M/2, nfft, fs)
title('speech and noise through room 1');
colorbar('EastOutside')

subplot 222
spectrogram(s2, M, M/2, nfft, fs)
title('speech and noise through room 2');
colorbar('EastOutside')

subplot 223
spectrogram(e1, M, M/2, nfft, fs)
title('filtered speech and noise throughroom 1');
colorbar('EastOutside')

subplot 224
spectrogram(e2, M, M/2, nfft, fs)
title('filtered speech and noise throughroom 2');
colorbar('EastOutside')

figure
subplot 221
spectrogram(s1_, M, M/2, nfft, fs)
title('speech and structured noise through room 1');
colorbar('EastOutside')

subplot 222
spectrogram(s2_, M, M/2, nfft, fs)
title('speech and structured noise through room 2');
colorbar('EastOutside')

subplot 223
spectrogram(e3, M, M/2, nfft, fs)
title('filtered speech and structured noise through room 1');
colorbar('EastOutside')

subplot 224
spectrogram(e4, M, M/2, nfft, fs)
title('filtered speech and structured noise through room 2');
colorbar('EastOutside')

%% for real song and crickets
[cricket, ~] = audioread('crickets.wav');
[song, fs] = audioread('recorded_song.wav');
for mu=0.05:0.05:1.95
    i=int32(mu*20);
    [enlms(i,:),~]=NLMS_(song,cricket,mu,200,1);
end

M=150:25:300
for i=1:length(M)
    [erls(i,:),~]=RLS_alg(song, cricket, M, 0.99998,50);
end
%after trying, I choose the mu as 0.2 , a=1, ff as 0.99998, delta as 50
[enlms,~]=NLMS_(song,cricket,0.2,200,1);
[erls,~]=RLS_alg(song,cricket,200,0.99998,50);

figure
subplot 131
spectrogram(song, 200, 100, 1024, fs)
title('orginal noised song');
subplot 132
spectrogram(enlms, 200, 100, 1024, fs)
title('NLMS filtered song');
subplot 133
spectrogram(erls, 200, 100, 1024, fs)
title('RLS filtered song');

%% YW
M = 200;

nfft  = 1024;
N = 0:nfft-1;
f = 2*pi*N/nfft;
d1 = s1;
d2 = s2;
% here I only test the unstructured  noise room 2

denom = zeros(1,nfft);

figure
[A,sigma] = YW(d2,M);

for k = 1:length(A)
    denom = A(k)*exp(j*k*f) + denom;
end
absdenom = abs(denom).^2;
P_AR = sigma ./ absdenom;

plot(f(1:end/2),log10(P_AR(1:end/2)));
hold on;

% by using matlab built-in function aryule and freqz
[A2,E2] = aryule(d2,M);
[H, W]=freqz(1,A2);
plot(W, log10(abs(H).^2));
title('speech and noise through room 2');
xlabel('angular frequency')
ylabel('dB')
legend('Yule Walker','Freqz + aryule');

figure
subplot 121
spectrogram(P_AR(1:end/2), M, M/2, nfft, fs)
title('YW');
subplot 122
spectrogram(log10(abs(H).^2), M, M/2, nfft, fs)
title('matlab');

%% sparse
M = 200;
t = length(c);
n = t/2;
A = prewindow(v, M);
mm = [5:25 80];
d=s2;
% again choose room 2 with noise
for i =1:length(mm)
    m = mm(i);
    [A_hat, ~, Aa, e] = order(A, d, m);
    ASE(i) = ASE(c,e)
end

figure,
plot(mm,ASE)
xlabel('sparsity levels M')
ylabel('Average square error of order choises')
title('speech and noise through room 2');


mu = 0.3;
a = 1;

% calculate the indxes of nonzeros coefficients of the filter
[A_hat, idx, Aa, e] = order(A, d, 25);
fprintf('The modified NLMS: \n');
% calculate the time and ASE of modified NLMS function
tic
[e1, w1] = NLMS_2(d, v, mu , M, a,idx);
toc
ASE_1 = ASE(c,e1');

% calculate the time and ASE of orginal NLMS function
fprintf('The original NLMS');
tic
[e2, W2] = NLMS_(d, v, mu , M, a);
toc  
ASE_2 = ASE(c,e2');

M=[5:25,80]
for i=1:length(M)
   [e3(i,:), w1] = NLMS_2(d, u, mu , M(i), a,idx);
end
ASEM=ASE(c,e3');

   
 

