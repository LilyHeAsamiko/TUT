N = 64;
sigma = 0.005;
theta0 = 0.001;
beta = 2.5;
kappa = beta + 1.5;

decay_val_hyperprior = 4;
nbins_hyperprior = 12;

image_exact = zeros(N); 
positions = [ 15 45 23 12 38 51 30 ; 7 12 35 56 28 50 32 ];
intensities = [1 0.5 0.7 0.8 0.9 1 0.6];
Ind_mat = reshape([1:N^2]',N,N);
ind_vec = [];
for i = 1 : length(positions)
pos_x = positions(1,i); 
pos_y = positions(2,i);
image_exact(pos_y-2:pos_y+2,pos_x) = intensities(i);
image_exact(pos_y,pos_x-2:pos_x+2) = intensities(i);
ind_vec_aux = Ind_mat(pos_y-3:pos_y+3,pos_x-3:pos_x+3);
ind_vec = [ind_vec ; ind_vec_aux(:)];
end
ind_vec = unique(ind_vec);
n = length(ind_vec);

figure(1); clf; imagesc(image_exact); colormap('gray'); set(gca,'visible','off');
drawnow;

y = A*image_exact(:);
y = y + sigma*randn(size(y));
figure(2); clf; imagesc(reshape(y,N,N)); colormap('gray'); set(gca,'visible','off');
drawnow;

m_max = 1000;
n_iter = 1000;
t_res = 20;
t_tol = 7;
burn_in = 100;

%x = y;
x = zeros(size(ind_vec));
%x(ind_vec) = image_exact(ind_vec);
x_cm = zeros(size(x));
x_cm_ind = 0;
x_history = zeros(10, n_iter);
ind_vec_2 = find(sum(A(:,ind_vec),2));
A_aux = A(ind_vec_2,ind_vec);
y_aux = y(ind_vec_2);
theta = theta0*ones(size(ind_vec));
tic;


for i = 1 : n_iter
    i
    inv_d = 1./theta;
    x = (A_aux'*A_aux + sigma^2*diag(inv_d))\(A_aux'*(y_aux + sigma*randn(size(y_aux))) + sigma^2*sqrt(inv_d).*randn(size(x)));  
    
    for j = 1 : length(theta)
            xj = abs(x(j));
            p_max_th = kappa/(theta0+0.5*xj^2);
            thmin = eps;
            second_derivative_abs = abs(-kappa/(p_max_th^2));
            thmax = p_max_th + sqrt(2*decay_val_hyperprior/second_derivative_abs);
            thmax = thmax - (0.5*xj^2*p_max_th + theta0*p_max_th - kappa*log(p_max_th) + decay_val_hyperprior - 0.5*xj^2*thmax - theta0*thmax + kappa*log(thmax))/(-0.5*xj^2 - theta0 + kappa/thmax);
            thmax = thmax - (0.5*xj^2*p_max_th + theta0*p_max_th - kappa*log(p_max_th) + decay_val_hyperprior - 0.5*xj^2*thmax - theta0*thmax + kappa*log(thmax))/(-0.5*xj^2 - theta0 + kappa/thmax);
            thmax = thmax - (0.5*xj^2*p_max_th + theta0*p_max_th - kappa*log(p_max_th) + decay_val_hyperprior - 0.5*xj^2*thmax - theta0*thmax + kappa*log(thmax))/(-0.5*xj^2 - theta0 + kappa/thmax);
            if (thmax-thmin)/(nbins_hyperprior-1) > 2*p_max_th
                thmin = p_max_th;
                step_length = (thmax-thmin)/(nbins_hyperprior-1);
            else
            step_length = (p_max_th-thmin)/ceil((p_max_th-thmin)*nbins_hyperprior/(thmax-thmin));
            end
            tj = [thmin : step_length : thmax];
            p = exp(-0.5*xj^2*tj - theta0*tj + (kappa-2)*log(tj));
            Phi = cumsum(p);  
            tau = Phi(end)*rand;
            aux_ind = find(Phi>=tau);
            indj = aux_ind(1);
            theta(j) = 1./tj(indj);
%               figure(2); clf; plot(tj,p);
%               pause(0.2);
    end
        
if i > burn_in
x_cm = x_cm + x;
x_cm_ind = x_cm_ind + 1;
end
x_history(:,i) = x(10:10:100);
end
t = toc

x_image = zeros(N);
x_image(ind_vec) = x_cm;
figure(3); clf; imagesc(x_image); colormap('gray'); set(gca,'visible','off');
drawnow;
drawnow;

%figure(4); plot(x_history'); 