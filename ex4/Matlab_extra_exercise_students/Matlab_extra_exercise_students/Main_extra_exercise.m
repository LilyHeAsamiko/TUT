clear; close all; clc;

%% Load RGB image

rgb = imread('lena512.tiff');
figure
imshow(rgb);


%% Encoder
%----------------------------------------------------------
% Color transform and Chroma subsampling: 
%----------------------------------------------------------

% TASK: implement color transform function 
[Y,U,V] = ColorTransform(rgb);

% Double precision plus center values around 0 (shifted block / 
%level shift)
YCh = double(Y) - 128;

%----------------------------------------------------------
% Forward Discret Cosine Transform: 

% - The discrete cosine transform(DCT) of NxN image blocks 
%(T = H * F * H_transposed), where H is the matrix containing the DCT 
%coefficients (NxN matrix) and F is an NxN image block.  
%----------------------------------------------------------

blockSize = 8;

% DCT coefficients (create NxN DCT matrix) %H = dct(eye(8));
H = dctmtx(blockSize);

% Compute DCT for every block of the image
%fun = @(block_struct) dct2(block_struct.data);
fun = @(block_struct) H * block_struct.data * H';
Y_dct = blockproc(YCh, [blockSize blockSize], fun);

%-----------------------------------------------------------
% Quantization of the DCT coefficients: page 
%
% - Standard JPEG quantization table that represents a quality of 50%
%-----------------------------------------------------------
Q_table_Y = [16 11 10 16 24 40 51 61;
             12 12 14 19 26 58 60 55;
             14 13 16 24 40 57 69 56;
             14 17 22 29 51 87 80 62; 
             18 22 37 56 68 109 103 77;
             24 35 55 64 81 104 113 92;
             49 64 78 87 103 121 120 101;
             72 92 95 98 112 100 103 99];
                 
Q_table_UV = [17 18 24 47 99 99 99 99;
              18 21 26 66 99 99 99 99;
              24 26 56 99 99 99 99 99;
              47 66 99 99 99 99 99 99;
              99 99 99 99 99 99 99 99;
              99 99 99 99 99 99 99 99;
              99 99 99 99 99 99 99 99;
              99 99 99 99 99 99 99 99];
          
fun = @(block_struct) round(block_struct.data ./ Q_table_Y);
Y_quant = blockproc(Y_dct, [blockSize blockSize], fun);

%% Decoder 
%-----------------------------------------------------------
% Dequantization of DCT Coefficients
%-----------------------------------------------------------
fun = @(block_struct) block_struct.data .* Q_table_Y;
Y_dequant = blockproc(Y_quant, [blockSize blockSize], fun); 

%-----------------------------------------------------------
% Inverse Discrete Cosine Transform:
%
% - T = H * F * H_transposed --> F = inv(H) * T * H
%-----------------------------------------------------------
fun = @(block_struct) H' * block_struct.data * H;
Y_rec = blockproc(Y_dequant, [blockSize blockSize], fun);

%----------------------------------------------------------
% Shifted Block and precision
%----------------------------------------------------------
Y_rec = uint8(Y_rec + 128);
rgb = ColorTransform(Y_rec,U,V);
%----------------------------------------------------------
%Display of Results
imshow(rgb);
%----------------------------------------------------------
psnr = psnr(Y_rec, Y);
    