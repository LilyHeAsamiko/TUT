%**************************************************************
%
%ARGUMENTS:   n = number of sensors
%             mesh_size = mesh size
%             sigma = noise standard deviation
%             particle = particle coordinates (polar)
%
%RETURNS:     posterior_values = posterior function values
%                                 in the mesh points.
%
%**************************************************************
function [posterior_values] = p_posterior(n, mesh_size, sigma, particle)


%sensor coordinates:
sensors_space = 2*pi/n;
sensors_phi = [0 : sensors_space : 2*pi-sensors_space];
sensors = [ ones(1, n) ; sensors_phi];

%mesh:
r = [0 : 1/mesh_size : 1];
phi = [0 : 2*pi/mesh_size : 2*pi];
[R, Phi] = meshgrid(r, phi);

%data (exact):
distances = sqrt(sum(([ cos(sensors(2, :)) ; sin(sensors(2, :))] ...
    - particle(1)*repmat([ cos(particle(2)) ;  sin(particle(2))], 1, n)...
    ).^2));
y = 1./distances; 

posterior_values = zeros(size(r, 2),size(phi, 2));
%posterior function in the mesh points
for i = 1 : size(r, 2)
for j = 1 : size(phi, 2)
distances = sqrt(sum(([ cos(sensors(2, :)) ; sin(sensors(2, :))] ... 
    - r(i)*repmat([ cos(phi(j)) ;  sin(phi(j))], 1, n)).^2));
posterior_values(i, j) = exp( -sum((y - 1./distances).^2)/(2*sigma^2) );
end 
end

posterior_values = abs(100*posterior_values/abs(max(posterior_values(:))));

%plotting
figure(1); clf;
pcolor(R.*cos(Phi), R.*sin(Phi), posterior_values');
shading flat;
c_map = colormap('gray');
colormap(flipud(c_map));
hold on;
set(gca,'ylim',[-1.1 1.1]);
set(gca,'xlim',[-1.1 1.1]);
plot(cos([0:0.002:2*pi]), sin([0:0.002:2*pi]),'linewidth',10);
plot( cos(sensors(2, :)), sin(sensors(2, :)), 'ro','markersize',24, ...
    'linewidth',10)
plot( particle(1)*cos(particle(2)), particle(1)*sin(particle(2)),'mo','markersize',24, ...
    'linewidth',5)
set(gca,'visible','off');
colorbar('vertical','fontsize',24);
axis equal;
hold off;
