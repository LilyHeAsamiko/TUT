% LOWPASSFILTER - Constructs a low-pass butterworth filter.
%
% filter = 1 / [1 + C(R/Ro)^2n]
%
function f = BWHPfilter(image, cutoff, n)
    
[rows,cols] = size(image);
[u,v] = meshgrid(1:1:cols,1:1:rows);
D = sqrt( (u-cols/2).^2 + (v-rows/2).^2 );
f = 1-1./(1+((D./cutoff).^(2*n)));


% [rows,cols] = size(image);
% [u,v] = meshgrid(-cols/2+1:1:cols/2,-rows/2+1:1:rows/2);
% D = sqrt(u.^2+v.^2);
% f = 1./(1+(D)./cutoff.^(2*n));
