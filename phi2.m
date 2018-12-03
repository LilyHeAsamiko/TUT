function y = phi2(t)
    L = 1;
    w = 1;
    hbar = 1;
    m = 1;
    w1 = (pi*hbar)^2/(2*m*L);
    w2 = 4* w1;
    y = exp(-i*w2*t);
end