function [e,w]=SegLS(v,d,M,seg)
% d - desired signal to the filter
% v - input signal to the filter
% M - the length of filter
% seg - the number of segements

% e - error signal of the filter

    N = length(v);
    n= floor(N/seg);
    w=[];
    e=[];
    n=floor(N/seg);
    
    for i=1:seg 
    %       equal sized segments  
        if n * ceil(N/seg) <= N
            A_seg(n,:) = v(n*(i-1)+1 : n * i);
%       build the matrix A by using prewindowing method
            A = prewindow(A_seg(i,:),M);
            d_seg = d(n*(i-1)+1 : n * i);
            w_seg = A\d_seg;
            y_hat = A * w_seg;
            e = [e; d_seg - y_hat]; 
            w = [w,w_seg];       
        else
%       unequal sized segement with rest part of the signal    
            A_rest = d(n*(i-1)+1 : end);
            A = prewindow(A_rest,M);
            d_rest = d(n*(i-1)+1 : end);
            w_rest = A\d_rest;
            y_hat = A * w_rest;
            e = [e; d_rest - y_hat]; 
            w = [w,w_rest];
        end
    end

end





    