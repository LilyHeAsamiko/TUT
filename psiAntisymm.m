function z=psiAntisymm(x,y)
    L=1;
    psiA =@(x)sin(pi*x/L);
    psiB =@(x)sin(2*pi*x/L);
    z=abs(psiA(x).*psiB(y) - psiB(x).*psiA(y)).^2;
end