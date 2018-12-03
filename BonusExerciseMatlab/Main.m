%--------------------------------------------------------------------------
% Bonus exercise - Bayer Filter Demosaic
%
%
%--------------------------------------------------------------------------
clear; close all; clc;

% Load raw image 
load ('RawBayerImage12bitrggb.mat');

% Load reference image
load ('refImg.mat');

% Demosaic
rgb = BayerDemosaic (rawImg);
a=rgb-rawImg
% Display results
imshow(rgb);