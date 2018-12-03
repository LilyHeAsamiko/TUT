N = 64;
blur_mask = zeros(7);
n = (length(blur_mask)-1)/2;
sigma_mask = n/2;
for i = 1 : length(blur_mask)
 for j = 1 : length(blur_mask)
 blur_mask(i,j) = exp( - ((n+1-i)^2 + (n+1-j)^2)/(2*sigma_mask^2) );
 end
end
blur_mask = blur_mask/sum(blur_mask(:));
Ind_mat = reshape([1 : N^2]',N,N); 

figure(1); clf;
h_surf = surf(blur_mask);
set(h_surf, 'edgecolor', 'none','diffusestrength',0.5,'ambientstrength',0.5,'specularstrength',0.3,'specularexponent',0.3);
set(gca,'visible','off');
shading interp;
lighting phong;
camlight right;
colormap gray;
view(5,35);
drawnow;
print(1,'-r300','-dpng','blur_mask.png');

A = sparse(N^2,N^2);

for i = n + 1 : N - n
    for j = n + 1 : N - n 
        
        for k = 1 : length(blur_mask)
        for l = 1 : length(blur_mask)
            A(Ind_mat(i-n+k-1,j-n+l-1),Ind_mat(i,j)) = blur_mask(k,l);
        end
        end
    end
end