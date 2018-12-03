function rgb = BayerDemosaic (rawImg)
[m, n] = size(rawImg);
rawImg = cat(1, rawImg, zeros(1,n));
rawImg = cat(2, rawImg, zeros(m+1,1));

for i = 3:m
    for j = 3:n
        G(i-1, j-2) = rawImg(i-1, j-2);
        G(i-1, j) = rawImg(i-1, j);
        G(i-2, j-1) = rawImg(i-2, j-1);
        G(i, j-1) = rawImg(i, j-1);        
        G(i-1, j-1) = (rawImg(i-2, j-1) + rawImg(i, j-1) + rawImg(i-1, j-2) + rawImg(i-1, j))/4;
        
        R(i-2, j-2) = rawImg(i-2, j-2);
        R(i-2, j) = rawImg(i-2, j);
        R(i, j-2) = rawImg(i, j-2);
        R(i, j) = rawImg(i, j);
        R(i-2, j-1) = (rawImg(i-2, j-2) + rawImg(i-2, j))/2;
        R(i-1, j-2) = (rawImg(i-2, j-2) + rawImg(i, j-2))/2;
        R(i-1, j-1) = (rawImg(i-2, j-2) + rawImg(i, j-2) + rawImg(i-2, j) + rawImg(i, j))/4;
        
        B(i, j-1) = (rawImg(i-1, j-1) + rawImg(i+1, j-1))/2;
        B(i-1, j) = (rawImg(i-1, j-1) + rawImg(i-1, j+1))/2;
        B(i-1, j-1) = rawImg(i-1, j-1) ;
    end
end
rgb = uint16(zeros(m,n,3));
rgb(:,:,1) = uint16(R(m,n));
rgb(:,:,2) = uint16(G(m,n));
rgb(:,:,3) = uint16(B(m,n));
