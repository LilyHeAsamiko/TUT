

image_exact = zeros(N); 
image_exact(18:28,18:28) = 1;
image_exact(21:25,21:25) = 0.5;
image_exact(30:34,40:45) = 0.7;
image_exact(30:42,36:40) = 0.7;
image_exact(38:42,31:36) = 0.7;
image_exact(36:46,15:20) = 0.5;
image_exact(15:25,43:48) = 0.5;
image_exact(45:52,45:52) = 0.8;
figure(1); clf; imagesc(image_exact); colormap('gray');
axis equal;
set(gca,'visible','off');

image_y = A*image_exact(:);
image_y = reshape(image_y,N,N);
figure(2); clf; imagesc(image_y); colormap('gray');
axis equal;
set(gca,'visible','off');
image_y = image_y + 0.02*randn(size(image_y));
figure(3); clf; imagesc(image_y); colormap('gray');
axis equal;
set(gca,'visible','off');

f = image_y(:);

x = ones(size(A,1),1);

for k = 1 : 10
k
    
m_max = 1000;
alpha = 0.1;
tol = 1e-20;
u = zeros(size(A,1),1);
r = f;
p = r;
norm_f = norm(f);
diag_w = abs(x);  

m = 0;
while( (norm(r)/norm_f > tol) & (m < m_max))
  aux_vec = p'*A;
  aux_vec = diag_w.*aux_vec';
  aux_vec = A*aux_vec;
  a = aux_vec + alpha*p;
  a_dot_p = a' * p;
  aux_val = (r' * p);
  lambda = aux_val ./ a_dot_p;
  u = u + lambda * p;
  r = r - lambda * a;
  aux_val = (r' * a);
  p = r - (aux_val ./ a_dot_p) * p;
  m=m+1;
end
x = u;
m
aux_vec = A'*x;
x = diag_w.*aux_vec;

end

image_x = reshape(x,N,N);
figure(4); clf; imagesc(image_x); colormap('gray');
axis equal
set(gca,'visible','off');
