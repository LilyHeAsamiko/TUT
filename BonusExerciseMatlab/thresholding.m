% Load reference image
load ('refImg.mat');

refImg = uint8(refImg/256);
refImg = im2double(refImg);

x1 = zeros(size(refImg(:,:,1)));
y1 = double(refImg(:,:,1)); 
x1 = y1 + 0.15*((max(y1(:))-min(y1(:))))*rand(size(y1));
x2 = zeros(size(refImg(:,:,2)));
y2 = double(refImg(:,:,2)); 
x2 = y2 + 0.15*((max(y2(:))-min(y2(:))))*rand(size(y2));
x3 = zeros(size(refImg(:,:,3)));
y3 = double(refImg(:,:,3)); 
x3 = y3 + 0.15*((max(y3(:))-min(y3(:))))*rand(size(y3));
x=cat(3,x1,x2,x3);

[thr,sorh,keepapp] = ddencmp('den','wv',x);
thr
k=1
for i =0:0.05:0.25
ys = wdencmp('gbl',x,'sym4',2,i,'s',keepapp);
yh = wdencmp('gbl',x,'sym4',2,i,'h',keepapp);
peaksnrs(k) = psnr(uint8(ys),im2uint8(refImg));
peaksnrh(k) = psnr(uint8(yh),im2uint8(refImg));
k=k+1;
end
figure
plot(0:0.05:0.25,peaksnrs,'r',0:0.5:0.25,peaksnrh,'b');
figure
subplot(3,1,1)
imshow(x);
subplot(3,1,2)
imshow(ys);
subplot(3,1,3)
imshow(yh);