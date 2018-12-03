I2=Ih+randn(size(Ih),'like',normpdf(Ih,0,50));
subplot(1,3,1);
imshow(I2);
I_2=fft2(I2);
I_2=fftshift(I_2);
k=40;
H2=exp(-k*((u-row/2)^2+(v-col/2)^2)^5/6);
G2=H.*I_2;
g2=ifft2(fftshift(G2));
g2=real(g2);
subplot(1,3,2);
imshow(g2,[0,255]);
S=var(I_2*conj(I_2))+mean(I_2)'*conj(mean(I_2));
N=var(fftshift(fft2(normpdf(Ih,0,50)))*conj(fftshift(fft2(normpdf(Ih,0,50)))))+mean(fftshift(fft2(normpdf(Ih,0,50))))'*conj(mean(fftshift(fft2(normpdf(Ih,0,50)))));
F=1./H2*(H2*conj(H2)./(H2*conj(H2))+N/S)*G2;
f=ifft2(fftshift(F));
f=real(f);
subplot(1,3,3);
imshow(f,[0,255]);

F1=1./H2*(H2*conj(H2)./(H2*conj(H2))+ones(length(I2)))*G2;
f1=ifft2(fftshift(F1));
f1=real(f1);
figure;
imshow(f1,[0,255]);
F2=1./H2*(H2*conj(H2)./(H2*conj(H2))+randn(length(I2)))*G2;
f2=ifft2(fftshift(F2));
f2=real(f2);
figure;
imshow(f2,[0,255]);


