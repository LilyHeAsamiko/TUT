function A2  = prewindow(A,M)
% construct the matrix by using prewindowing method

% A - the vector data
% M - the length of the matrix

    N=length(A);
    A2=zeros(N,M);

    for m=1:M
        col=[zeros(m,1);A(:)];
        A2(:,m)=col(2:N+1);
    end
end

