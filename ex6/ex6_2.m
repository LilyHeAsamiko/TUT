I=imread('cameraman.tif');
fl=BWLPfilter(I,2,2);

ftl=fft2(I);
fl_=fftshift(ftl);
figure;
imshow(log(abs(fl_)+0.0001));
fl_1=fl.*fl_;
gl=ifft2(ifftshift(fl_1));
gl=real(gl);
figure;
imshow(gl,[0,255]);
fh=BWHPfilter(I,2,2);

fth=fft2(I);
fh_=fftshift(fth);
figure;
imshow(log(abs(fh_)+0.0001));
fh_1=fh.*fh_;
gh=ifft2(ifftshift(fh_1));
gh=real(gh);
figure;
imshow(gh,[0,255]);
