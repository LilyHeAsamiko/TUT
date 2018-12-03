N = 64;
sigma = 0.005;
alpha = 20;

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
x = zeros(size(y));
%x(ind_vec) = image_exact(ind_vec);
x_cm = zeros(size(x));
x_cm_ind = 0;
x_history = zeros(10, n_iter);

tic;
for i = 1 : n_iter
    i
    aux_0 = full(A*x);
for j = 1 : n
    j_ind = ind_vec(j);
    aux_1 = A(:,j_ind);
    x_old = x(j_ind);
    aux_ind = find(aux_1);
    aux_1 = full(aux_1(aux_ind));
    y_aux = y(aux_ind) - aux_0(aux_ind) + aux_1*x_old;
    t_max = ((1/sigma.^2)*sum(y_aux.*aux_1)+(1/2)*alpha)/((1/sigma.^2)*sum(aux_1.*aux_1));
    aux_2 = (y_aux - aux_1*t_max);
    aux_2 = (1/(2*sigma.^2))*sum(aux_2.*aux_2) - alpha*t_max;
    t_int = sqrt(t_tol/((1/(2*sigma.^2))*sum(aux_1.^2)));
    t = linspace(t_max - t_int,t_max + t_int, t_res);
    y_aux = y_aux(:,ones(1,t_res));
    aux_3 = y_aux - aux_1(:,ones(t_res,1)).*t(ones(size(aux_ind)),:); 
    p = cumsum(exp(aux_2 -(1/(2*sigma^2))*sum(aux_3.*aux_3) - alpha*t));
    p = p/p(end);
    rand_val = rand(1);
    rand_ind = find( p > rand_val, 1);
    if isempty(rand_ind)
    rand_ind = 1;
    end
    x(j_ind) = t(rand_ind);
    aux_0(aux_ind) = aux_0(aux_ind) + aux_1*(x(j_ind)-x_old);
%     plot(t,p)
%     pause;
end
if i > burn_in
x_cm = x_cm + x;
x_cm_ind = x_cm_ind + 1;
end
x_history(10:10:100,i) = x(ind_vec(10:10:100));
end
t = toc

figure(3); clf; imagesc(reshape(x_cm,N,N)); colormap('gray'); set(gca,'visible','off');
drawnow;
drawnow;

figure(4); plot(x_history'); 