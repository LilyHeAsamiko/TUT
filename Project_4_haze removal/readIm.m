function im = readIm(image)
%cd 'Dataset'
im = imread(image);

% normalize
im=imresize(im,.5);
im = double(im);
im = im./255;