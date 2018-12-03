N = 64;
sigma = 0.1;

image_exact = zeros(N); 
image_exact(18:28,18:28) = 100;
image_exact(21:25,21:25) = 50;
Ind_mat = reshape([1:N^2]',N,N);
ind_vec = Ind_mat(15:31,15:31);
ind_vec = ind_vec(:);
n = length(ind_vec);

figure(1); clf; imagesc(image_exact); colormap('gray');

y = A*image_exact(:);
y = y + sigma*randn(size(y));
figure(2); clf; imagesc(reshape(y,N,N)); colormap('gray');

m_max = 1000;
alpha = 0.01;
n_iter = 200;
t_res = 50;
t_tol = 5;
burn_in = 0;

%x = y;
x = zeros(size(y));
%x(ind_vec) = image_exact(ind_vec);
x_cm = zeros(size(x));

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
    t_max = ((1/sigma.^2)*sum(y_aux.*aux_1))/((1/sigma.^2)*sum(aux_1.*aux_1) + alpha);
    aux_2 = (y_aux - aux_1*t_max);
    aux_2 = (1/(2*sigma.^2))*sum(aux_2.*aux_2) - alpha*t_max.^2;
    t_int = sqrt(t_tol/((1/(2*sigma.^2))*sum(aux_1.^2)));
    t = linspace(t_max - t_int,t_max + t_int, t_res);
    y_aux = y_aux(:,ones(1,t_res));
    aux_3 = y_aux - aux_1(:,ones(t_res,1)).*t(ones(size(aux_ind)),:); 
    p = cumsum(exp(aux_2 -(1/(2*sigma^2))*sum(aux_3.*aux_3) - alpha*t.^2));
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
end
end

figure(3); clf; imagesc(reshape(x_cm,N,N)); colormap('gray');


