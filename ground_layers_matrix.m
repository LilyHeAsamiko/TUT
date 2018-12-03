clear;
clear all;

res = 64;
m_res = 64;
cube_size = 1;
radius_val = res/2 - 3;

t = [0 : res/(m_res-1) : res];
rec_pos_aux{1} = [res*ones(size(t)) ; t ; 0*t];
rec_pos_aux{2} = [zeros(size(t)) ; t ; 0*t];
for k_1 = 1 : 2 
    for k_2 = 1 : 9
tr_pos_aux{k_1,k_2} = [64*(k_1-1);8*(k_2-1);0];
    end
end

h = waitbar(0,'A matrix.');

A_aux =[];

for k_1 = 1 : 2 
    for k_2 = 1 : 9

tr_pos = tr_pos_aux{k_1,k_2};
rec_pos=rec_pos_aux{k_1};

iter_num = 0;
n_iter = res.^2;
aux_vec = zeros(n_iter,1);

t_val = now;

X = zeros(res);
Y = X;

directions = rec_pos - tr_pos(:,ones(1,size(rec_pos,2)));
A = zeros(m_res, n_iter);
for j = 1 : res
for i = 1 : res
        
cube_center = [cube_size*j-0.5;cube_size*i-0.5;0];    
iter_num = iter_num + 1;    
X(iter_num) = cube_center(1);
Y(iter_num) = cube_center(2);
A(:,iter_num) = line_integrals(tr_pos, directions, cube_center, cube_size);
if mod(iter_num,ceil(n_iter/50)) == 0
waitbar(iter_num/n_iter,h,['A matrix. Ready approx: ' datestr((n_iter/iter_num - 1)*(now - t_val) + now)])
end 

end
end

A_aux = [A_aux ; A];

    end
end

A = A_aux;

close(h);







