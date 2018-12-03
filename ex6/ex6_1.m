A=0.5*ones(128);
A1=zeros(20);
A2=A(1:(128-20)/2,:);
A3=A(((128-20)/2+1):((128-20)/2+20),1:(128-20)/2);
A=cat(1,A2,cat(2,A3,A1,A3),A2);
B_1=0:1/127:1;
B=repmat(B_1,128,1);
C=zeros(128);
C(128/2,128/2)=1;
D1=cos(0:2*pi/(128/4-1):2*pi);
[X1,Y1]=meshgrid(D1,D1);
D=cos(X1+Y1);
D=repmat(D,4,4);

subplot(4,2,1)
imshow(A);
subplot(4,2,2)
imshow(filth(A));
subplot(4,2,3)
imshow(B);
subplot(4,2,4)
imshow(filth(B));
subplot(4,2,5)
imshow(C);
subplot(4,2,6)
imshow(filth(C));
subplot(4,2,7)
imshow(D);
subplot(4,2,8)
imshow(filth(D));




