%--------------------------------------------------------------------------
% Demosaic
%
% There are 4 different cases that can be used for R and B channels ...
%creation (Bayer pattern):
%
% a) 'grbg' -  G  R  G      
%              B  G  B 
%              G  R  G 
%              
%
% b) 'gbrg' -  G  B  G
%              R  G  R
%              G  B  G
%
%
% c) 'rggb' -  R  G  R
%              G  B  G
%              R  G  R
%
%
% d) 'bggr' -  B  G  B
%              G  R  G
%              B  G  B   
%
% Task:
% - Demosaic "rawImg" using case c). You can implement the simplest method
%of demosaicing - linear method with independent interpolation of each 
%color plane [1]. You can also implement any other method described in [1] 
%or develop your own. You are not allowed to use "demosaic" function of 
%Matlab in this task. You must describe in few sentences the bayer 
%principle and the method used for demosaicing. 
%You can compare your result with the reference image.  
%
% [1] - A. Lukin, and D. Kubasov, "An Improved Demosaicing Algorithm", 
%Graphicon, 2004.
%--------------------------------------------------------------------------
function rgb = BayerDemosaic (rawImg)
[m, n] = size(rawImg);
rawImg = cat(1, zeros(2,n),rawImg, zeros(2,n));
rawImg = cat(2, zeros(m+4,2),rawImg, zeros(m+4,2));

for i = 5:2:m+1
    for j = 5:2:n+1
        G(i-1, j-2) = rawImg(i-1, j-2);
        G(i-1, j) = rawImg(i-1, j);
        G(i-2, j-1) = rawImg(i-2, j-1);
        G(i, j-1) = rawImg(i, j-1);        
        G(i-1, j-1) = (rawImg(i-2, j-1) + rawImg(i, j-1) + rawImg(i-1, j-2) + rawImg(i-1, j))/4;
        G(i-2, j-2) = (rawImg(i-3, j-2) + rawImg(i-1, j-2) + rawImg(i-2, j-1) +rawImg(i-2, j-3))/4;
        G(i, j-2) = (rawImg(i-1, j-2) + rawImg(i+1, j-2) + rawImg(i, j-3) +rawImg(i, j-1))/4;
        G(i-2, j) = (rawImg(i-3, j-2) + rawImg(i-1, j-2) + rawImg(i-2, j-1) +rawImg(i-2, j+1))/4;
        G(i, j) = (rawImg(i-1, j) + rawImg(i+1, j) + rawImg(i, j-1) +rawImg(i, j+1))/4;
                
        R(i-2, j-2) = rawImg(i-2, j-2);
        R(i-2, j) = rawImg(i-2, j);
        R(i, j-2) = rawImg(i, j-2);
        R(i, j) = rawImg(i, j);
        R(i-2, j-1) = (rawImg(i-2, j-2) + rawImg(i-2, j))/2;
        R(i-1, j-2) = (rawImg(i-2, j-2) + rawImg(i, j-2))/2;
        R(i-1, j) = (rawImg(i-2, j) + rawImg(i, j))/2;
        R(i, j-1) = (rawImg(i, j-2) + rawImg(i, j))/2;        
        R(i-1, j-1) = (rawImg(i-2, j-2) + rawImg(i, j-2) + rawImg(i-2, j) + rawImg(i, j))/4;
        
        B(i-2, j-2) = (rawImg(i-3, j-2) + rawImg(i-1, j-2) + rawImg(i-2, j-3) + rawImg(i-2, j-1))/4;
        B(i, j-2) = (rawImg(i-1, j-3) + rawImg(i+1, j-3) + rawImg(i-1, j-1) + rawImg(i+1, j-1))/4;
        B(i, j) = (rawImg(i-1, j-1) + rawImg(i-1, j-1) + rawImg(i+1, j-3) + rawImg(i+1, j-1))/4;
        B(i-2, j) = (rawImg(i-1,j-1) + rawImg(i+1, j-1) + rawImg(i-1, j+1) + rawImg(i+1,j+1))/4;
        B(i-2, j-1) = (rawImg(i-1, j-1) + rawImg(i-3, j-1))/2;
        B(i-1, j-2) = (rawImg(i-1, j-3) + rawImg(i-1, j-1))/2;
        B(i, j-1) = (rawImg(i-1, j-1) + rawImg(i+1, j-1))/2;
        B(i-1, j) = (rawImg(i-1, j-1) + rawImg(i-1, j+1))/2;
        B(i-1, j-1) = rawImg(i-1, j-1);
    end
end
rgb = uint16(zeros(m,n,3));
rgb(:,:,1) = uint16(R(m,n));
rgb(:,:,2) = uint16(G(m,n));
rgb(:,:,3) = uint16(B(m,n));

%A bayer filter mosaic is a color filter array for arranging RGB color
%filters on a square grid. It's pattern is 50% greeb, 25% red and 25% blue,
%hence is also called BGGR, RGBG, RGGB. It's based on using twise as many
%green(luminance-sensitive) elements as red or blue(chrominance-sensitive) 
%to mimic the physiology of the human eye. 
%Sample values after interpolation become image pixels. 



















end