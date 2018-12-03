load('energyData.mat')
load('confInt.mat')

E_inc = 59.5409;
m_e = 0.5109989461e3;
angle = (100/180)*pi:pi/1000:(160/180)*pi;

E_prime = @(theta) E_inc./(1 + (1 - cos(theta))*(E_inc/m_e));
yneg = energyData(:,2)' - confInt(1,:) + hwhm';
ypos = confInt(2,:) - energyData(:,2)' + hwhm';

figure;
hold on
grid on
grid minor
title('Energy-scattering v.s. angle');
plot(angle*(180/pi), E_prime(angle), 'Color', 'b');
errorbar(energyData(:,1), energyData(:,2), yneg, ypos, 0.8*ones(1,9), 0.8*ones(1,9), 'Color', 'r');
xlabel('Angle (degrees)');
ylabel('Energy of the scattered photon (keV)');
legend({'Theoretic', 'Experimental'});