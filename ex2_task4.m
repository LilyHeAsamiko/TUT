t=1790:10:2000
p=197273000./(1.+exp(-0.03134.*(t-1913.25)));
disp(['The value of p is ',num2str(p)])
p_2=1000.*[3929,5308,7240,9638,12866,17069,23192,31443,38558,50156,62948,75995,91972,105711,122775,131669,150697]
plot(t,p,'b-',1790:10:1950,p_2,'o');
axis([1750,2000,0,200000000])
legend('logistic model','acrtual data')
xlabel('Time');
ylabel('Population');
title('population against time')

