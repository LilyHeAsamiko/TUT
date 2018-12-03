load('intData.mat')
DCSfit = 'a*DCS(x)';

[fitDCS, DCSgoodness] = fit(intData(:,1), intData(:,4), DCSfit, 'Start', 3.43e31);

figure
title('integeral v.s. angle')
hold on
grid on
grid minor
scatter(intData(:,1), intData(:,4), 150, '.', 'r')
scatter(intData(:,1), intData(:,2), 100, '+', 'b')
scatter(intData(:,1), intData(:,3), 100, 'o', 'k')
plot(fitDCS)
xlabel('Angle (degrees)')
ylabel('Scattering probability (not normalized)')
legend({'Analytical values', 'Trapezoidal rule', 'Simpsons rule', 'fitline'}, 'Location', 'northwest')