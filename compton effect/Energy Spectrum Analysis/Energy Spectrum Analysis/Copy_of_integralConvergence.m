load('fitData.mat')
crop = angle_150_crop;
fit = fitData150{1,2};
xmin = crop(1,1);
xmax = crop(end,1);
simpsAccuracy = [];
trapzAccuracy = [];
i = 2:1:30;

analInt = integrate(fit, xmax, xmin);
for n = i
    x = xmin:(xmax - xmin)/(n-1):xmax;
    simps = simpsons(fit(x), xmin, xmax, []);
    trap = trapz(x, fit(x));
    simpsAccuracy = [simpsAccuracy; n simps];
    trapzAccuracy = [trapzAccuracy; n trap];
end

figure
title('Integral with numerical rules at 150 degrees')
hold on
grid on
grid minor
plot(i, analInt*ones(size(i)), 'r', 'LineWidth', 1)
plot(simpsAccuracy(:,1), simpsAccuracy(:,2), 'g')
plot(trapzAccuracy(:,1), trapzAccuracy(:,2), 'b')
xlabel('Number of sample points')
ylabel('Value of the integral')
legend({'Analytical result', 'Simpsons rule', 'Trapezoidal rule'})