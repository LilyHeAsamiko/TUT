h = 6.626*10^(-34);
c = 3*10^(8);
m =  9.1091*10^(-31)
lambda = 2426*10^(-12)
E1 = h*c/lambda;
i = 1;
for theta = 110/180*pi:0.01:150/180*pi;
E2(i) = E1./(1+(1-cos(theta).*E1./m./c^2));
i = i+1;
end
plot(theta,E2)