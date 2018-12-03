I1=imread('fruits.jpg');
I2=imread('festia.jpg');
subplot(2,3,1)
imshow(I1);
subplot(2,3,2)
imshow(histequalization(I1));
subplot(2,3,3)
imshow(intensityeq(I1));
subplot(2,3,4)
imshow(I2);
subplot(2,3,5)
imshow(histequalization(I2));
subplot(2,3,6)
imshow(intensityeq(I2));


function I2=histequalization(I)
I2(:,:,1)=histeq(I(:,:,1),8);
I2(:,:,2)=histeq(I(:,:,2),8);
I2(:,:,3)=histeq(I(:,:,3),8);
end

function I_=intensityeq(I)
H=rgb2hsv(I);
P(:,:,1)=histeq(H(:,:,1),8);
P(:,:,2)=histeq(H(:,:,2),8);
P(:,:,3)=histeq(H(:,:,3),8);
I_=rgb2hsv(P);
end

