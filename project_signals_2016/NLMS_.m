function [e,W]=NLMS_(d,u,mu,M,a)
n_max=length(d);
if (n_max ~= length(u)) return; end
u=[zeros(M-1, 1);u];
w=zeros(M,1);
y=zeros(n_max,1);
e=zeros(n_max,1);
for n=1:n_max
    uu= u(n+M-1:-1:n);
    y(n)=w'*uu;
    e(n)=d(n)-y(n);
    w=w+mu*e(n)*uu/(a+uu'*uu);
    W(:,n)=w;
end
end