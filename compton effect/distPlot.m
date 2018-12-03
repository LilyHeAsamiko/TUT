load('croppedData.mat')

gaussDist = 'a*exp(-((x-b)/c)^2)+d';
cauchyDist = 'a*(c/((x-b)^2+c^2)+d)';
%laplaceDist = 'a*exp(-abs(x-b)/c)+d';

[fitGauss, gaussGoodness] = fit(angle_150_crop(:,1), angle_150_crop(:,2), gaussDist, 'Start', [1, 51.8, 2, 3]);
[fitCauchy, cauchyGoodness] = fit(angle_150_crop(:,1), angle_150_crop(:,2), cauchyDist, 'Start', [1, 51.8, 2, 3]);
%[fitLaplace, laplaceGoodness] = fit(angle_150_crop(:,1), angle_150_crop(:,2), laplaceDist, 'Start', [1, 51.8, 2, 3]);
%fitData150 = {fitGauss, fitCauchy, fitLaplace; gaussGoodness, cauchyGoodness, laplaceGoodness};
fitData150 = {fitGauss, fitCauchy; gaussGoodness, cauchyGoodness};

xLeftBound = angle_150_crop(1,1);
xRightBound = angle_150_crop(end,1);

figure
hold on
grid on
grid minor
set(gca,'XLim',[xLeftBound xRightBound]);
scatter(angle_150_crop(:,1), angle_150_crop(:,2), '.', 'k');
plot(fitGauss, 'r');
plot(fitCauchy, 'g');
%plot(fitLaplace, 'b');
%legend({'Experimental data', 'Gaussian fit', 'Cauchy fit', 'Laplace fit'})
legend({'Experimental data', 'Gaussian fit', 'Cauchy fit'})
xlabel('Energy (keV)')
ylabel('Counts')
title('Spectrum data model fitting (150 degrees)')