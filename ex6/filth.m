function g=filth(I)
%I=A;
F=fft2(I);
Fc=fftshift(F);
%figure;
g=log(abs(Fc)+0.0001);
%imshow(log(abs(Fc)+0.0001));
%H=eye(size(I));
%G=H.*Fc;
%gi=ifft2(ifftshift(G));
%g=real(gi);
end