N = 64;
sigma = 0.005;
alpha = 20;
n_iter = 10000;
burn_in = 1000;

pixel_ind_vec = [25 39];

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

figure(1); clf; imagesc(image_exact); colormap('gray'); set(gca,'visible','off'); axis equal; 
drawnow;

y = A*image_exact(:);
y = y + sigma*randn(size(y));
figure(2); clf; imagesc(reshape(y,N,N)); colormap('gray'); set(gca,'visible','off'); axis equal;
drawnow;

t_res = 20;
t_tol = 7;

x = zeros(size(ind_vec));
x_cm = zeros(size(x));
x_history = zeros(length(pixel_ind_vec), n_iter);
ind_vec_2 = find(sum(A(:,ind_vec),2));
A_aux = full(A(ind_vec_2,ind_vec));
y = y(ind_vec_2);
n_dimensions = length(x);

tic;
for i = 1 : n_iter
    i
    aux_0 = A_aux*x;
for j = 1 : n_dimensions
    aux_1 = A_aux(:,j);
    x_old = x(j);
    aux_ind = find(aux_1);
    aux_1 = full(aux_1(aux_ind));
    y_aux = y(aux_ind) - aux_0(aux_ind) + aux_1*x_old;
    t_max = (sum(y_aux.*aux_1) - alpha*sigma.^2)/sum(aux_1.*aux_1);
    t_int = sigma*sqrt(2*t_tol/sum(aux_1.^2));
    if t_max >= 0
    d_1 = max(0,t_max - t_int);
    d_2 = t_max + t_int;
    aux_2 = (y_aux - aux_1*t_max);
    aux_2 = (1/(2*sigma.^2))*sum(aux_2.*aux_2) + alpha*t_max;
    else
    d_1 = 0;
    d_2 = t_max + sqrt(t_max^2 + 2*sigma^2*t_tol/sum(aux_1.^2));
    aux_2 = y_aux;
    aux_2 = (1/(2*sigma.^2))*sum(aux_2.*aux_2);   
    end    
    t = [d_1 : (d_2 - d_1)/(t_res-1) : d_2];
    y_aux = y_aux(:,ones(1,t_res));
    aux_3 = y_aux - aux_1(:,ones(t_res,1)).*t(ones(size(aux_ind)),:);  
    p = cumsum(exp(aux_2 -(1/(2*sigma^2))*sum(aux_3.*aux_3) - alpha*t));
    p = p/p(end);
    rand_val = rand(1);
    rand_ind = find( p > rand_val, 1);
    if isempty(rand_ind)
    rand_ind = 1;
    end
    x(j) = t(rand_ind);
    aux_0(aux_ind) = aux_0(aux_ind) + aux_1*(x(j)-x_old);
%     plot(t,exp(aux_2 -(1/(2*sigma^2))*sum(aux_3.*aux_3) - alpha*t))
%     pause;
end
x_history(pixel_ind_vec,i) = x(pixel_ind_vec);
if i > burn_in
x_cm = x_cm + x;
end
end
t = toc

x_history_burn_in = x_history(:,1:burn_in);
x_history = x_history(:,burn_in+1:end);
x_cm = x_cm/(n_iter - burn_in);

x_image = zeros(N);
x_image(ind_vec) = x_cm;
figure(3); clf; imagesc(x_image); colormap('gray'); set(gca,'visible','off'); axis equal; 
drawnow;

for k = 1 : length(pixel_ind_vec)
figure(k+3); clf;
plot(x_history(pixel_ind_vec(k),:)','linewidth',2);
hold on;
std_val = std(x_history(pixel_ind_vec(k),:));
h_line = line([1 size(x_history,2)], image_exact(ind_vec(pixel_ind_vec(k)))*[1 1]);
set(h_line,'linewidth',5,'color','m','linestyle','--');
h_line = line([1 size(x_history,2)], x_cm(pixel_ind_vec(k))*[1 1]);
set(h_line,'linewidth',5,'color','g','linestyle','--');
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
set(h_line,'linewidth',5,'color','m','linestyle','--');
h_line = line(x_cm(pixel_ind_vec(k))*[1 1],[0 y_lim(2)]);
set(h_line,'linewidth',5,'color','g','linestyle','--');
h_line = line(x_cm(pixel_ind_vec(k))*[1 1] + 2*std_val,[0 y_lim(2)]);
set(h_line,'linewidth',5,'color','k','linestyle','--');
h_line = line(x_cm(pixel_ind_vec(k))*[1 1] - 2*std_val,[0 y_lim(2)]);
set(h_line,'linewidth',5,'color','k','linestyle','--');
set(gca,'linewidth',5);
set(gca,'box','on');
hold off;
end 

aux_length = burn_in;

for k = 1 : length(pixel_ind_vec)
figure(k + 2*length(pixel_ind_vec) + 3); clf;
plot(x_history_burn_in(pixel_ind_vec(k),:)','linewidth',5);
hold on;
std_val = std(x_history(pixel_ind_vec(k),:));
h_line = line([1 size(x_history,2)], image_exact(ind_vec(pixel_ind_vec(k)))*[1 1]);
set(h_line,'linewidth',5,'color','m','linestyle','--');
h_line = line([1 size(x_history,2)], x_cm(pixel_ind_vec(k))*[1 1]);
set(h_line,'linewidth',5,'color','g','linestyle','--');
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