t=1790:10:2000;
p=197273000./(1.+exp(-0.03134.*(t-1913.25)));
disp(['The value of p is ',num2str(p)]) 
plot(t,p,'b--*');
axis([1790,2000,0,200000000]);
xlabel('Time');
ylabel('Population');
title('population against time')

t_=1790:3100;
point=[];
p_1=197273000./(1.+exp(-0.03134.*(t_-1913.25)));
for i=1:length(t_)-1
    if p_1(i)==p_1(i+1)
        flag=1;
        point(i)=i+1789;
    else
        flag=0;
    end
end
if flag==1
    for i=1:length(point)
        if point(i)
           disp(['Steady sate point is ',num2str(point(i))]);
           break;
        end
    end
else
    disp('No steady state.')
end