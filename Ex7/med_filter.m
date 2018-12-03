function O=med_filter(I,size_)
%I=I2;
%size_=5;
[m1,n1]=size(I);
I=cat(1,I(1,:),I(2,:),I,I(m1-1,:),I(m1,:));
I=cat(2,I(:,1),I(:,2),I,I(:,n1-1),I(:,n1));
for i=3:m1+2
    for j=3:n1+2
        for p=1:size_
            for q=1:size_
            Im(p,q)=I(i-(size_-1)/2+p-1,j-(size_-1)/2+q-1);
            end
        end    
        O(i-(size_-1)/2,j-(size_-1)/2)=median(Im(:));
        %j=j+1;
    end
end
%imshow(O,[0,255])
end
    
