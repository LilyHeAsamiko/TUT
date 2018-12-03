% RLS_alg - Conventional recursive least squares
%
% Usage: [e, w] = RLS(d,u,M,ff,delta)
%
% Inputs:
% d  - the vector of desired signal samples of size Ns,
% u  - the vector of input signal samples of size Ns,
% M  - the number of taps.
% ff - forgetting factor
% delta - initialization parameter for P
%
% Outputs:
% e - the output error vector of size Ns
% w - the last tap weights

function [e,w] = RLS_alg(d,v,M,ff,delta)
% input signal length
N = length(d);
w = zeros(M,N);
P = eye(M) * delta;
v = [zeros(M-1, 1); v];
for n = 1:N
    uu = v(n+M-1:-1:n);
    pi_ = uu' * P;
    gamma = ff + pi_ * uu;
    K = pi_' / gamma;
    e(n) = d(n) - w(:,n)' * uu;
    w(:,n+1) = w(:,n) + K * e(n);
    P_ = K * pi_;
    P = (P - P_)/ ff;

end
end
