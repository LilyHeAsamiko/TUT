y1 = normpdf(-10:0.01:10);
y11 = normcdf(-10:0.01:10);
y2 = normpdf(-10:0.01:10 ,1, 2.5);
y21 = normcdf(-10:0.01:10, 1, 2.5);
subplot(2,2,1)
plot(y1);
title('normal pdf of mu =0 , sigma = 1 ')
subplot(2,2,2)
plot(y11);
title('normal cdf of mu =0 , sigma = 1 ')
subplot(2,2,3)
plot(y2);
title('normal pdf of mu =1 , sigma = 2.5 ')
subplot(2,2,4)
plot(y21);
title('normal cdf of mu =1 , sigma = 2.5 ')

x=-10:0.01:10;
y3 = 1./(0.5*pi*(1+x.^2));
y31 = 1./pi*atan(x/0.5)+0.5;
figure
subplot(2,2,1)
plot(y3);
title('cauchy pdf of x0 =0 , gamma = 0.5 ')
subplot(2,2,2)
plot(y31);
title('cauchy cdf of x0 =0 , gamma = 0.5  ')
y4 = 1./(0.25*pi*(1+(x-1).^2));
y41 = 1./pi*atan((x-1)/0.25)+0.5;
subplot(2,2,3)
plot(y4);
title('cauchy pdf of x0 =1 , gamma = 0.25 ')
subplot(2,2,4)
plot(y41);
title('cauchy cdf of x0 =1 , gamma = 0.25 ')