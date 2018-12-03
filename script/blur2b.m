N = 64;
sigma = 0.005;
alpha = 20;
n_iter = 5;
A = full(A);

for i = 1 : 2

 image_exact = zeros(N); 
    
 if i == 1    
    
  fn = 'pieces';
  
  image_exact(14:24,14:24) = 1;
  image_exact(17:21,17:21) = 0.5;
  image_exact(29:32,35:40) = 0.7;
  image_exact(29:41,31:35) = 0.7;
  image_exact(37:41,26:31) = 0.7;
  image_exact(38:48,14:19) = 0.5;
  image_exact(14:24,43:48) = 0.5;
  image_exact(43:50,43:50) = 0.8;

 elseif i == 2
  
  fn = 'constellation';
  
  positions = [ 15 45 23 12 38 51 30 ; 7 12 35 56 28 50 32 ];
  intensities = [1 0.5 0.7 0.8 0.9 1 0.6];
  
  for j = 1 : length(positions)

   pos_x = positions(1,j); 
   pos_y = positions(2,j);
   image_exact(pos_y-2:pos_y+2,pos_x) = intensities(j);
   image_exact(pos_y,pos_x-2:pos_x+2) = intensities(j);

  end
  
 end


 figure(1); clf; imagesc(image_exact); colormap('gray');
 axis equal;
 set(gca,'visible','off');
 drawnow;
 print(1, '-r300', '-dpng', [fn '_exact.png']);

 y = A*image_exact(:);
 figure(2); clf; imagesc(reshape(y,N,N)); colormap('gray');
 axis equal;
 set(gca,'visible','off');
 drawnow;
 print(2, '-r300', '-dpng', [fn '_blurred.png']);

 y = y + sigma*randn(size(y));
 figure(3); clf; imagesc(reshape(y,N,N)); colormap('gray');
 axis equal;
 set(gca,'visible','off');
 drawnow;
 print(3, '-r300', '-dpng', [fn '_noisy.png']);

 x = ones(size(A,1),1);
 A_d = A;

 for k = 1 : n_iter
  k
  
  d = sqrt(abs(x));  
  A_d = A*diag(d);

  x = A_d'*(( A_d * A_d' + (2*sigma^2*alpha)*eye(size(A_d,1),size(A_d,1)))\y);
  x = d.*x;
  
  figure(4); clf; imagesc(reshape(x,N,N)); colormap('gray');
  axis equal
  set(gca,'visible','off');
  drawnow;
  
  if k == 1
  print(4, '-r300', '-dpng', [fn '_L2.png']);
  elseif k == n_iter
  print(4, '-r300', '-dpng', [fn '_L1.png']);    
  end
  
 end;
 
end