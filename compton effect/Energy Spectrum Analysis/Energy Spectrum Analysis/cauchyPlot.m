load('croppedData.mat')
data = angle_150_crop;

cauchyDist = 'a*(c/((x-b)^2+c^2)+d)';

fitCauchy = fit(data(:,1), data(:,2), cauchyDist, 'Start', [1, 51.8, 2, 3]);
coeff = coeffvalues(fitCauchy);

xLeftBound = data(1,1);
xRightBound = data(end,1);

figure
hold on
grid on
grid minor
set(gca,'XLim',[xLeftBound xRightBound]);
scatter(data(:,1), data(:,2), '.', 'k');
plot(fitCauchy, 'b');
vline = line([coeff(2) coeff(2)], [0 60]);
vline.Color = 'r';
vline.LineWidth = 2;
legend({'Experimental data', 'Cauchy fit', 'Center of symmetry'})
xlabel('Energy (keV)')
ylabel('Counts')
title('Around the Spike')