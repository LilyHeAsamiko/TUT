function w=NLMS_C(d,u,mu,M,a)
n_max=length(d);
if (n_max ~= length(u)) return; end
w=zeros(M,1);
y=zeros(n_max,1);
e=zeros(n_max,1);
for n=M:n_max
    uu= u(n-M+1:n);
    y(n)=w'*uu;
    e(n)=d(n)-y(n);
    w=w+mu*e(n)*uu/(a+u'*u);
end
w=w(1)
M
end
