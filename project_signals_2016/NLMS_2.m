
% NLMS_modified - only update the nonzeros coefficients of the filter


% Inputs:
% d  - the vector of desired signal samples of size Ns,
% u  - the vector of input signal samples of size Ns,
% mu - the constant parameter of controlling step size,
% M  - the number of taps.
% a  - constant to mitigate norm(u) ~ 0

% To overcome the possible numerical difficulties when norm(u(n)) is very close to zero, a constant a > 0 is used:
%
% Outputs:
% e - the output error vector of size Ns
% w - the last tap weights
% W - a matrix M x Ns containing the coefficients (thir evolution)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [e, W] = NLMS_modified(d, u, mu, M, a, indx)


    % Initialization
    N = length(d);
    if (N ~= length(u)) 
        help NLMS; 
        return; 
    end
    L = length(indx);
    u = [zeros(M-1, 1); u];
%     w = zeros(M,1);
    W = zeros(L, N);
    y = zeros(N,1);
    e = zeros(N,1);

    w = zeros(L,1);
    % The NLMS loop
    
    for n=1:N
    %     % a new data pair
         uu = u(n+M-1:-1:n);
    %     % update
    
        uu_ = uu(indx); % only update the most effective signal
         y(n) = w' * uu_;
         e(n) = d(n) - y(n);
%          w(indx) = mu * u_n(indx)
         w = w + mu * uu_ * e(n)/(a+norm(uu_,2).^2); % only update nonzero coefficients of filter
         W(:,n) = w;
    end

end