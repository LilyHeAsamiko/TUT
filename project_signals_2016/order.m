function [A_hat, Index, e, r] = OMP(A, d, m)
% OMP -  Orthogonal Matching Pursuit method
% Input: A - N x d matrix (input signal)
%        d -desired signal

% Output: r - N vector error 
%         N x m matrix A_hat 
%         m vector Loc (nonzeros index)
%         a - output signal
    r = d;
    A_hat = [];
    Index = [];
   for i = 1:m
       [M, N] = max(abs(A' * r));
       Index  = [Index N];
       A_hat = [A_hat A(:,N)];
        w = A_hat\d;
        a(:,i) = A_hat * w;
        e = d - a(:,i);
    end

end