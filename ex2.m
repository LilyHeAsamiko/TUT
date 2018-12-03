clear all
x = 0:1e-3:1;
y = 0:1e-3:1;
figure()
[x,y]= meshgrid(x,y);
zs = psiSymm(x,y)
contour(x,y,zs)
title('Symmetric wavefunction')

figure()
za = psiAntisymm(x,y)
contour(x,y,za)
title('Antisymmetric wavefunction')