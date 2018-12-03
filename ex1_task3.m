tic
sum=0;
for i=(1:1000)
    sum=sum+i^2;
end
sum
toc

clear sum
tic
x=[1:1000];
sum(x.^2)
toc

tic
sum=0;
for i=(1:2:1003)
    if mod(i,4) == 1
        sum=sum+1/i;
    else
        sum=sum-1/i;
    end
end
sum
toc

clear sum
tic
x1=(1:4:999);
x2=(3:4:1003);
sum(1./x1)-sum(1./x2)
toc

tic
sum=0;
for n=(1:500)
    sum=sum+1/((2*(n-1)+1)^2*(2*n+1)^2);
end
sum
toc

clear sum
tic
x1=(1:2:2*500-1);
sum(1./(x.^2.*(x+2).^2))
toc

x = 3 > 2
x = 2 > 3
x = -4 <= -3
x = 1 < 1
x = 2~= 2
x = 3 == 3
x = 0 < 0.5 < 1
