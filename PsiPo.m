function y=PsiPo(x,t)
    L = 1;
    w = 1;
    hbar = 1;
    m = 1;
    w1 = (pi*hbar)^2/(2*m*L);
    w2 = 4* w1;
    A = sqrt(2/L);
    y=abs(sqrt(1/2)*(A *psi1(x).*phi1(t)+A *psi2(x).*phi2(t))).^2;
end