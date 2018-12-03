load('errorStatistics.mat')

cauchyCumSum = cumsum(cauchyError(1,:));
gaussianCumSum = cumsum(gaussianError(1,:));
laplaceCumSum = cumsum(laplaceError(1,:));
angles = 110:5:150;

figure
hold on
grid on
grid minor
title('Cumulative sum of sum of squares due to error vs. measurement angle')
plot(angles, gaussianCumSum, 'Color', 'r');
plot(angles, cauchyCumSum, 'Color', 'g');
plot(angles, laplaceCumSum, 'Color', 'b');
xlabel('Angle (degrees)');
ylabel('Cumulative sse');
legend({'Gaussian', 'Cauchy', 'Laplace'}, 'Location', 'northwest');