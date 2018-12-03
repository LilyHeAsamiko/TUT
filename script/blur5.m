N = 64;
sigma = 0.005;
theta0 = 0.001;
beta = 1.5;
eta = beta - 1.5;
kappa = beta + 1.5;
hypermodel = 'Gamma';

pixel_ind_vec = [25 39 67 256];
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
x_history = zeros(length(pixel_ind_vec), n_iter-burn_in);
ind_vec_2 = find(sum(A(:,ind_vec),2));
A_aux = full(A(ind_vec_2,ind_vec));
y = y(ind_vec_2);
theta = theta0*ones(size(ind_vec));
n_dimensions = length(x);

tic;


for i = 1 : n_iter
    i
    inv_d = 1./theta;
    x = (A_aux'*A_aux + sigma^2*diag(inv_d))\(A_aux'*(y + sigma*randn(size(y))) + sigma^2*sqrt(inv_d).*randn(size(x)));  
    
    if strcmp(hypermodel,'Gamma')

        for j = 1 : n_dimensions

            xj = abs(x(j));
            p_max_th = theta0*(eta +sqrt((1/(2*theta0))*xj^2 + eta^2));
            thmin = eps;
            second_derivative_abs = abs(xj^2/(p_max_th^3) + eta/(p_max_th^2));
            p_max_abs = abs(-0.5*(xj^2)./p_max_th - (p_max_th/theta0) + eta*log(p_max_th));
            thmax = p_max_th + sqrt(2*decay_val_hyperprior/second_derivative_abs);
            thmax = thmax - (p_max_abs + decay_val_hyperprior -0.5*(xj^2)./thmax - (thmax/theta0) + eta*log(thmax))/(0.5*(xj^2)./thmax^2 - 1/theta0 + eta/thmax);             
            thmax = thmax - (p_max_abs + decay_val_hyperprior -0.5*(xj^2)./thmax - (thmax/theta0) + eta*log(thmax))/(0.5*(xj^2)./thmax^2 - 1/theta0 + eta/thmax);             
            thmax = thmax - (p_max_abs + decay_val_hyperprior -0.5*(xj^2)./thmax - (thmax/theta0) + eta*log(thmax))/(0.5*(xj^2)./thmax^2 - 1/theta0 + eta/thmax);             
            if (thmax-thmin)/(nbins_hyperprior-1) > 2*p_max_th
                thmin = p_max_th;
                step_length = (thmax-thmin)/(nbins_hyperprior-1);
            else
            step_length = (p_max_th-thmin)/ceil((p_max_th-thmin)*nbins_hyperprior/(thmax-thmin));
            end
            tj = [thmin : step_length : thmax];
            aux_vec = -0.5*(xj^2)./tj; 
            aux_vec = aux_vec - (tj/theta0);  
            aux_vec = aux_vec + eta*log(tj);
            p = exp(aux_vec);
             figure(2); clf; plot(tj,p);
             pause(0.2);
            Phi = cumsum(p);
            tau = Phi(end)*rand;
            aux_ind = find(Phi>=tau);
            indj = aux_ind(1);
            theta(j) = tj(indj);

        end

    elseif strcmp(hypermodel,'InverseGamma')


     if strcmp(hypermodel,'Gamma')

        for j = 1 : n_dimensions

            xj = abs(x(j));
            p_max_th = theta0*(eta +sqrt((1/(2*theta0))*xj^2 + eta^2));
            thmin = eps;
            second_derivative_abs = abs(xj^2/(p_max_th^3) + eta/(p_max_th^2));
            p_max_abs = abs(-0.5*(xj^2)./p_max_th - (p_max_th/theta0) + eta*log(p_max_th));
            thmax = p_max_th + sqrt(2*decay_val_hyperprior/second_derivative_abs);
            thmax = thmax - (p_max_abs + decay_val_hyperprior -0.5*(xj^2)./thmax - (thmax/theta0) + eta*log(thmax))/(0.5*(xj^2)./thmax^2 - 1/theta0 + eta/thmax);             
            thmax = thmax - (p_max_abs + decay_val_hyperprior -0.5*(xj^2)./thmax - (thmax/theta0) + eta*log(thmax))/(0.5*(xj^2)./thmax^2 - 1/theta0 + eta/thmax);             
            thmax = thmax - (p_max_abs + decay_val_hyperprior -0.5*(xj^2)./thmax - (thmax/theta0) + eta*log(thmax))/(0.5*(xj^2)./thmax^2 - 1/theta0 + eta/thmax);             
            if (thmax-thmin)/(nbins_hyperprior-1) > 2*p_max_th
                thmin = p_max_th;
                step_length = (thmax-thmin)/(nbins_hyperprior-1);
            else
            step_length = (p_max_th-thmin)/ceil((p_max_th-thmin)*nbins_hyperprior/(thmax-thmin));
            end
            tj = [thmin : step_length : thmax];
            aux_vec = -0.5*(xj^2)./tj; 
            aux_vec = aux_vec - (tj/theta0);  
            aux_vec = aux_vec + eta*log(tj);
            p = exp(aux_vec);
%             figure(2); clf; plot(tj,p);
%             pause(0.2);
            Phi = cumsum(p);
            tau = Phi(end)*rand;
            aux_ind = find(Phi>=tau);
            indj = aux_ind(1);
            theta(j) = tj(indj);

        end

    elseif strcmp(hypermodel,'InverseGamma')


        for j = 1 : n_dimensions

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
%              figure(2); clf; plot(tj,p);
%               pause(0.2);
        end

    end

    end
        
if i > burn_in
x_cm = x_cm + x;
x_history(pixel_ind_vec,i-burn_in) = x(pixel_ind_vec);
end
end
t = toc

x_cm = x_cm/(n_iter - burn_in);

x_image = zeros(N);
x_image(ind_vec) = x_cm;
figure(3); clf; imagesc(x_image); colormap('gray'); set(gca,'visible','off');
drawnow;

for k = 1 : length(pixel_ind_vec)
figure(k+3); clf;
plot(x_history(pixel_ind_vec(k),:)','linewidth',2);
hold on;
std_val = std(x_history(pixel_ind_vec(k),:));
h_line = line([1 size(x_history,2)], image_exact(ind_vec(pixel_ind_vec(k)))*[1 1]);
set(h_line,'linewidth',5,'color','g','linestyle','--');
h_line = line([1 size(x_history,2)], x_cm(pixel_ind_vec(k))*[1 1]);
set(h_line,'linewidth',5,'color','m','linestyle','--');
h_line = line([1 size(x_history,2)], x_cm(pixel_ind_vec(k))*[1 1] + 2*std_val);
set(h_line,'linewidth',5,'color','k','linestyle','--');
h_line = line([1 size(x_history,2)], x_cm(pixel_ind_vec(k))*[1 1] - 2*std_val);
set(h_line,'linewidth',5,'color','k','linestyle','--');
set(gca,'xlim',[1 size(x_history,2)]);
set(gca,'xtick',[1 round(size(x_history,2)/2) size(x_history,2)]);
set(gca,'xticklabel',{'1',int2str(round(size(x_history,2)/2)),int2str(size(x_history,2))});
xlabel(['STD = ' num2str(std_val)],'fontsize',35);
set(gca,'ylim',[-0.5 2.5]);
set(gca,'ytick',[0 1 2]);
set(gca,'linewidth',5);
set(gca,'fontsize',36);
pbaspect([2 1 1]); 
hold off;
end

for k = 1 : length(pixel_ind_vec)
figure(k + length(pixel_ind_vec) + 3); clf;
set(gcf, 'Renderer', 'painters'); 
pbaspect([2 1 1]); 
hold on;
std_val = std(x_history(pixel_ind_vec(k),:));
res_aux = 30;
t_vec = [-1 : 2/(res_aux-1) : 3];
[hist_vec_1 hist_vec_2] = hist(x_history(pixel_ind_vec(k),:),t_vec);
hist_vec_1 = hist_vec_1/sum(hist_vec_1*2/(res_aux-1));
h_bar = bar(hist_vec_2,hist_vec_1,1);
set(h_bar,'facecolor','b','linewidth',5);
set(gca,'fontsize',36);
set(gca,'xtick',[0 1 2]);
set(gca,'xlim',[-0.5 2.5]);
y_lim = get(gca,'ylim');
set(gca,'ytick',[0 round(5*y_lim(2))/10 y_lim(2)]);
h_line = line(image_exact(ind_vec(pixel_ind_vec(k)))*[1 1],[0 y_lim(2)]);
set(h_line,'linewidth',5,'color','g','linestyle','--');
h_line = line(x_cm(pixel_ind_vec(k))*[1 1],[0 y_lim(2)]);
set(h_line,'linewidth',5,'color','m','linestyle','--');
h_line = line(x_cm(pixel_ind_vec(k))*[1 1] + 2*std_val,[0 y_lim(2)]);
set(h_line,'linewidth',5,'color','k','linestyle','--');
h_line = line(x_cm(pixel_ind_vec(k))*[1 1] - 2*std_val,[0 y_lim(2)]);
set(h_line,'linewidth',5,'color','k','linestyle','--');
set(gca,'linewidth',5);
set(gca,'box','on');
hold off;
end

aux_length = 250;

for k = 1 : length(pixel_ind_vec)
figure(k + 2*length(pixel_ind_vec) + 3); clf;
plot(x_history(pixel_ind_vec(k),1:aux_length)','linewidth',2);
hold on;
std_val = std(x_history(pixel_ind_vec(k),:));
h_line = line([1 size(x_history,2)], image_exact(ind_vec(pixel_ind_vec(k)))*[1 1]);
set(h_line,'linewidth',5,'color','g','linestyle','--');
h_line = line([1 size(x_history,2)], x_cm(pixel_ind_vec(k))*[1 1]);
set(h_line,'linewidth',5,'color','m','linestyle','--');
h_line = line([1 size(x_history,2)], x_cm(pixel_ind_vec(k))*[1 1] + 2*std_val);
set(h_line,'linewidth',5,'color','k','linestyle','--');
h_line = line([1 size(x_history,2)], x_cm(pixel_ind_vec(k))*[1 1] - 2*std_val);
set(h_line,'linewidth',5,'color','k','linestyle','--');
set(gca,'xlim',[1 aux_length]);
set(gca,'xtick',[1 round(aux_length/2) aux_length]);
set(gca,'xticklabel',{'1',int2str(round(aux_length/2)),int2str(aux_length)});
xlabel(['STD = ' num2str(std_val)],'fontsize',35);
set(gca,'ylim',[-0.5 2.5]);
set(gca,'ytick',[0 1 2]);
set(gca,'linewidth',5);
set(gca,'fontsize',36);
pbaspect([2 1 1]); 
hold off;
end


for k = 1 : 3 + 3*length(pixel_ind_vec)
print(k,'-r300','-dpng',['pic_' int2str(k) '.png']);
end