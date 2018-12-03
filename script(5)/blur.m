

image_exact = double(imread('layers.bmp','bmp')); 
image_exact(1:3,:) = 0;
image_exact(:,1:3) = 0;
image_exact(62:64,:) = 0;
image_exact(:,62:64) = 0;
figure(1); clf; imagesc(image_exact); colormap('gray');

image_y = A*image_exact(:);
image_y = image_y + 0.2*randn(size(image_y));
image_y = reshape(image_y,N,N);
figure(2); clf; imagesc(image_y); colormap('gray');

f = A'*image_y(:);
m_max = 1000;
alpha = 0.1;
tol = 1e-20;
u = zeros(size(A,1),1);
r = f;
p = r;
norm_f = norm(f);
  
m = 0;
while( (norm(r)/norm_f > tol) & (m < m_max))
  aux_vec = p'*A;
  aux_vec = aux_vec';
  %aux_vec = diag_w.*aux_vec';
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

image_x = reshape(x,N,N);
figure(3); clf; imagesc(image_x); colormap('gray');


