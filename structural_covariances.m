%This is a script for Example 4. @ Sampsa Pursiainen, 2012.
N = 64;
Ind_mat = reshape([1 : N^2]',N,N); 

%(a)
figure(1); clf;
z = randn(N,N);
imagesc(z); axis equal; set(gca,'visible','off'); colormap('gray');
print(1,'-r300','-dpng','covariance_a.png');

%(b)
W_1 = 4*speye(N^2,N^2);

for i = 2 : N-1
    for j = 2 : N-1 
            W_1(Ind_mat(i,j),Ind_mat(i,j+1)) = W_1(Ind_mat(i,j),Ind_mat(i,j+1)) - 1;
            W_1(Ind_mat(i,j),Ind_mat(i-1,j)) = W_1(Ind_mat(i,j),Ind_mat(i-1,j)) - 1;
            W_1(Ind_mat(i,j),Ind_mat(i,j-1)) = W_1(Ind_mat(i,j),Ind_mat(i,j-1)) - 1;
            W_1(Ind_mat(i,j),Ind_mat(i+1,j)) = W_1(Ind_mat(i,j),Ind_mat(i+1,j)) - 1;
    end
end

figure(2); clf;
z_1 = randn(N,N);
x_1 = reshape((W_1)\z_1(:),N,N);
imagesc(x_1); axis equal; set(gca,'visible','off'); colormap('gray');
print(2,'-r300','-dpng','covariance_b.png');

%(c)
W_2 = W_1;
[X,Y] = meshgrid([1:N]);
I = find(sqrt((X - N/2).^2 + (Y - N/2).^2)<=10);
W_2(I) = W_2(I) + 3; 
figure(3); clf;
z_2 = randn(N,N);
x_2 = reshape((W_2)\z_2(:),N,N);
imagesc(x_2); axis equal; set(gca,'visible','off'); colormap('gray');
print(3,'-r300','-dpng','covariance_c.png');

%(d)
W_3 = speye(N^2,N^2);
phi = pi/4;

W_3 = cos(phi)*W_3 + sin(phi)*W_3;

for i = 2 : N
    for j = 1 : N-1 
            W_3(Ind_mat(i,j),Ind_mat(i,j+1)) = W_3(Ind_mat(i,j),Ind_mat(i,j+1)) - cos(phi);
            W_3(Ind_mat(i,j),Ind_mat(i-1,j)) = W_3(Ind_mat(i,j),Ind_mat(i-1,j)) - sin(phi);
    end
end

figure(4); clf;
z_3 = randn(N,N);
x_3 = reshape((W_3)\z_3(:),N,N);
imagesc(x_3); axis equal; set(gca,'visible','off'); colormap('gray');
print(4,'-r300','-dpng','covariance_d.png');


