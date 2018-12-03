function [A,sigma] =YW(s , order)
r = xcorr(s,order);
r = r(order+1:end);
T = toeplitz(r);
tmp_T = T(1:end-1,1:end-1);
A = -(tmp_T\T(2:end,1));
A = [1; A];
sigma = T(1,:)*A;
end