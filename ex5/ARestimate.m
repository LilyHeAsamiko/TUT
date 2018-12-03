clear;
N = 50000;
N1 = 1000; 
N2= N-N1+1; 
nK = 20; 
nKs = 10; 
% NK star, to generate data with 
NrOfTrials = 256;
FPE_order = zeros(NrOfTrials, 1);
AIC_order = zeros(NrOfTrials, 1); 
MDL_order = zeros(NrOfTrials, 1); 
FPE_val = zeros(1, nK); 
AIC_val = zeros(1, nK); 
MDL_val = zeros(1, nK); 
omega = pi*[0.90 0.70 0.50 0.30 0.10]; 
rho = [0.75 0.95 0.85 0.80 0.90]; 
npairs = length(omega); 
roots_ = zeros(2*npairs,1); 
roots_(1:npairs) = rho.*exp(1i*omega); 
roots_(npairs+1:end) = conj(roots_(1:npairs)); 
a_ar = poly(roots_); 
wstar = -a_ar(2:(nKs+1))'; 
% w star 
for i=1:NrOfTrials 
% One realization of AR process. 
e = randn(N,1); 
y = filter(1, a_ar, e);
% Order estimation loop. 
for k = 1:nK
    A = zeros( N1, k ); 

% --------- EDIT HERE ------------------- 
    N2=N-N1+1;
    d=zeros(N1,k);
    for l=N2-1:N-1
        for j=1:k
%        A(l-N2+2,j)=A(l-N2+2,j)+y(l-j+1);
        A(l-N2+2,j)=y(l-j+1);
        end
    end 
d(:,k)=A*wstar(1:k)+e(N2:N);
w1=zeros(1,k);
w1(:)=eye(k)/(A'*A)*A'*d(:,k);
w2=zeros(1,k);
w2(:)=A\d(:,k);
dhat1(:,k)=A*w1(:);
err1(:,k)=d(:,k)-dhat1(:,k);
dhat2(:,k)=A*w2(:);
err2(:,k)=d(:,k)-dhat2(:,k);
sigmasquare1=zeros(1,k);
sigmasquare2=zeros(1,k);
sigmasquare1(:)=var(err1(:,:));
sigmasquare2(:)=var(err2(:,:));
FPE_val1 = zeros(k,1); 
FPE_val2 = zeros(k,1); 
AIC_val1 = zeros(k,1);
AIC_val2 = zeros(k,1);
MDL_val1 = zeros(k,1);
MDL_val2 = zeros(k,1);

FPE_val1(:) = (N+k)/(N-k)*sigmasquare1(:); 
FPE_val2(:) = (N+k)/(N-k)*sigmasquare2(:); 
AIC_val1(:) = N*log(sigmasquare1(:,k));
AIC_val2(:) = N*log(sigmasquare2(:,k));
MDL_val1(:) = N*log(sigmasquare1(:,k))+k*log(N);
MDL_val2(:) = N*log(sigmasquare2(:,k))+k*log(N);
% --------------------------------------- 
end 
% What is done here? 
% To choose the order according to different estimation, minimizing the
% error.
[~,FPE_order1(i)] = min( FPE_val1 ); 
[~,AIC_order1(i)] = min( AIC_val1 ); 
[~,MDL_order1(i)] = min( MDL_val1 ); 

[~,FPE_order2(i)] = min( FPE_val2 ); 
[~,AIC_order2(i)] = min( AIC_val2 ); 
[~,MDL_order2(i)] = min( MDL_val2 ); 
end
% Plot results. What is shown? 
% Explain the results. 
figure(1);
subplot(311) 
hist(FPE_order1,(1:nK));
title('FPE criterion','Fontsize',12);
xlabel('order k^*','Fontsize',12);
ylabel('Trials','Fontsize',12);
subplot(312)
hist(AIC_order1,(1:nK));
title('AIC criterion','Fontsize',12);
xlabel('order k^*','Fontsize',12);
ylabel('Trials','Fontsize',12);
subplot(313)
hist(MDL_order1,(1:nK));
title('MDL criterion','Fontsize',12);
xlabel('order k^*','Fontsize',12);
ylabel('Trials','Fontsize',12);

figure(2);
subplot(311) 
hist(FPE_order2,(1:nK));
title('FPE criterion','Fontsize',12);
xlabel('order k^*','Fontsize',12);
ylabel('Trials','Fontsize',12);
subplot(312)
hist(AIC_order2,(1:nK));
title('AIC criterion','Fontsize',12);
xlabel('order k^*','Fontsize',12);
ylabel('Trials','Fontsize',12);
subplot(313)
hist(MDL_order2,(1:nK));
title('MDL criterion','Fontsize',12);
xlabel('order k^*','Fontsize',12);
ylabel('Trials','Fontsize',12);