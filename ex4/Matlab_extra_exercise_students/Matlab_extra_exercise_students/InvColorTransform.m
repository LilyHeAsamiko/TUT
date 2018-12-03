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

function rgb = InVColorTransform(Y,U,V)
N = length(Y);
rgb = zeros(N,N,3);
R = zeros(N)
G = zeros(N)
B = zeros(N)
for i = 1:N
R(i,i)= Y(i,i)*mean([1.000  1.000  1.000]);
G(i,i) = U(i,i)*mean([0.000 -0.343  1.765]);
B(i,i) = V(i,i)*mean([1.400 -0.711  0.000]);

T = R
end