%--------------------------------------------------------------------------
% The conversion of RGB colors into full-range YCbCr colors is ...
%described by the following equation:
%
% [Y ;      [0 ;     [ 0.299  0.587  0.114;    [R;
%  Cb;   =  128;  +   -0.169 -0.331  0.500; *   G;
%  Cr]      128]       0.500 -0.419 -0.081]     B];
%
%
% The other way round, to convert a full-range YCbCr color into RGB is ...
%described by the following equation:
%
% [R;      [ 1.000  0.000  1.400;      [    Y;
%  G;   =    1.000 -0.343 -0.711;   *    Cb - 128;
%  B]        1.000  1.765  0.000]        Cr - 128]
%
%--------------------------------------------------------------------------
function [Y, Cb, Cr] = ColorTransform(rgb)
R = rgb(:,:,1);
G = rgb(:,:,2);
B = rgb(:,:,3);
Y = 0+[0.299  -0.169  0.500]*R;
Cb =128+[0.587 -0.331  0.500]*G;
Cr =128+[0.114 -0.419 -0.081]*B;
end