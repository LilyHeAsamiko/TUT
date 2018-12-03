% the a parameter(mu here in the code) is to avoid the denominator to be 0 when ?u(n)?
%is very close to zero which will make w to infinite.
clear all;
S1=audioread('clear_speech.wav');
S2_1=audioread('speech_and_noise_through_room_1.wav');
S2_2=audioread('speech_and_noise_through_room_2.wav');
sound(S1);
pause(4);
sound(S2_1);
pause(4);
sound(S2_2);
e1=NLMS_(S1,S2_1,1,length(S1),0.1);
e2=NLMS_(S1,S2_2,1,length(S1),0.1);
ed1=ASE(S1,e1);
ed2=ASE(S1,e2);
for i=0.1:0.1:1.9
    e1(:,int8(10*i))=NLMS_(S1,S2_1,i,1000,0.1);
    e2(:,int8(10*i))=NLMS_(S1,S2_2,i,1000,0.1);
    ed1(int8(10*i))=ASE(S1,e1(:,int8(10*i)));
    ed2(int8(10*i))=ASE(S1,e2(:,int8(10*i)));
end
[m1,k1]=min(ed1(:));
mu1=k1/10;
[m2,k2]=min(ed2(:));
mu2=k2/10;
% The best mu is the smallest one. It's not different with different
% inputs. Because the larger the mu is, the larger the nominator will be
% and the larger the error will be.

n=length(S1);
for i=60:n
    w1_60(i-59)=NLMS_C(S1,S2_1,1,i,0.1);
    w2_60(i-59)=NLMS_C(S1,S2_2,1,i,0.1);
end
for i=180:n
    w1_180(i-179)=NLMS_C(S1,S2_1,1,i,0.1);
    w2_180(i-179)=NLMS_C(S1,S2_1,1,i,0.1);
end
plot(w1_60,'b',w1_180,'r');
figure(2);
plot(w1_60,'b',w1_180,'r');

