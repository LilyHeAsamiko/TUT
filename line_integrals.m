function [int_vec] = line_integrals(origin, directions, cube_center, cube_size)

ones_vec = ones(1,size(directions,2));
if size(origin,2) == 1
    origin = origin(:,ones_vec);
end

int_vec = zeros(1,size(directions,2))';

cube_size = cube_size/2;

c_f_ind = [ 3 2 1 ]; 
v_f_ind = [ 1 3 2; 2 1 3];

int_p_ind = zeros(1,size(directions,2));
int_p_vec = zeros(6,size(directions,2));

for i = 1 : 3
for j = 1 : 2

aux_val = cube_center(c_f_ind(i))+(-1)^j*cube_size;    
t = (aux_val(:,ones_vec)-origin(c_f_ind(i),:))./directions(c_f_ind(i),:);
aux_vec = origin + t([1 1 1]',:).*directions; 
I = find( aux_vec(v_f_ind(1,i),:) >= cube_center(v_f_ind(1,i)) - cube_size & aux_vec(v_f_ind(1,i),:) < cube_center(v_f_ind(1,i)) + cube_size & ...
    aux_vec(v_f_ind(2,i),:) >= cube_center(v_f_ind(2,i)) - cube_size & aux_vec(v_f_ind(2,i),:) < cube_center(v_f_ind(2,i)) + cube_size);
I_aux_1 = find(int_p_ind==0);
I_aux_2 = intersect(I,I_aux_1);
I_aux_3 = setdiff(I,I_aux_2);
int_p_ind(I_aux_2) = 1;
int_p_ind(I_aux_3) = 2;
int_p_vec(1:3,I_aux_2) = aux_vec(:,I_aux_2);
int_p_vec(4:6,I_aux_3) = aux_vec(:,I_aux_3);

end
end

I=find(int_p_ind==2);
int_vec(I) = sqrt(sum((int_p_vec(4:6,I)-int_p_vec(1:3,I)).^2))';
