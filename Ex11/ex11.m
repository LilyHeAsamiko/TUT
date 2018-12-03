
clear;
load('yuvdata.mat');
cols*rows
yy_=reshape(yy,[cols,rows]);
uu_=reshape(uu,[cols/2,rows/2]);
vv_=reshape(vv,[cols/2,rows/2]);
yy_=imresize(yy_,0.25);
uu_=imresize(uu_,0.5);
vv_=imresize(vv_,0.5);
subplot(1,3,1)
imshow(yy_,[0 255]);
subplot(1,3,2)
imshow(uu_,[0 255]);
subplot(1,3,3)
imshow(vv_,[0 255]);
uu_=uu_-127;
vv_=vv_-127;
YUV=cat(2,yy_(:),uu_(:),vv_(:));
YuvToRgb=[1 0 1.402;1 -0.34413 -0.71414;1 1.772 0];
RGB=YuvToRgb*YUV';
R_=reshape(RGB(1,:),[120,120]);
G_=reshape(RGB(2,:),[120,120]);
B_=reshape(RGB(3,:),[120,120]);
figure;
imshow(uint8(cat(3,R_,G_,B_)));

%%
clear;
I=imread('lena.tiff');
R=I(:,:,1);
G=I(:,:,2);
B=I(:,:,3);
I_=rgb2ycbcr(I);
y=I_(:,:,1);
cb=I_(:,:,2);
cr=I_(:,:,3);
subplot(1,3,1)
imshow(y,[0 255]);
subplot(1,3,2)
imshow(cb,[0 255]);
subplot(1,3,3)
imshow(cr,[0 255]);
n=length(I_);
for i=0:n/2-1
    cb_(:,i+1)=cb(:,2*i+1);
    cr_(:,i+1)=cr(:,2*i+1);
end
cb_=imresize(cb_,[n,n]);
cr_=imresize(cr_,[n,n]);
I_1=cat(3,y,cb_,cr_);

for i=0:n/4-1
    cb_(:,i+1)=cb(:,4*i+1);
    cr_(:,i+1)=cr_(:,4*i+1);
end
cb_=imresize(cb,[n,n]);
cr_=imresize(cr,[n,n]);
I_2=cat(3,y,cb_,cr_);

for i=0:n/2-1
    cb_(i+1,i+1)=(cb_(2*i+1,2*i+2)+cb_(2*i+2,2*i+2))/2;
    cr_(i+1,i+1)=(cr_(2*i+1,2*i+2)+cr_(2*i+2,2*i+2))/2;
end
cb_=imresize(cb,[n,n]);
cr_=imresize(cr,[n,n]);
I_3=cat(3,y,cb_,cr_);

for i=0:n/2-1
    G_(i+1,i+1)=(G(2*i+1,2*i+2)+G(2*i+2,2*i+2))/2;
    B_(i+1,i+1)=(B(2*i+1,2*i+2)+B(2*i+2,2*i+2))/2;
end
G_=imresize(cb,[n,n]);
B_=imresize(cr,[n,n]);
I_4=cat(3,R,G_,B_);

figure
subplot(1,5,1)
imshow(I);
subplot(1,5,2)
imshow(ycbcr2rgb(I_1));
subplot(1,5,3)
imshow(ycbcr2rgb(I_2));
subplot(1,5,4)
imshow(ycbcr2rgb(I_3));
subplot(1,5,5)
imshow(ycbcr2rgb(I_4));
e1=immse(I,I_1)
e2=immse(I,I_2)
e3=immse(I,I_3)
e4=immse(I,I_4)
