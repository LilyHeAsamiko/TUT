L = 1;
w = 1;
hbar = 1;
m = 1;
w1 = (pi*hbar)^2/(2*m*L);
w2 = 4* w1;
A = sqrt(2/L);

x = 0:1e-2:1;
t = 0:8*pi/w/100:8*pi/w;

for i = 1:length(t)
    yp = PsiPo(x,t(i));
    plot(x,yp)
%     yn = PsiNeg(x,t(i));
%     plot(x,yn)
    drawnow
    F(i) = getframe;
end
