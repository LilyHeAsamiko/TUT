function sigma = DCS(theta)
theta = theta * (pi/180);
E_inc = 59.5409;
m_e = 0.5109989461e3;
alpha = 1/137.04;
r_c = 3.8616e-13;

P = 1./(1 + (1 - cos(theta))*(E_inc/m_e));
sigma = (alpha^2)*(r_c^2)*(P.^2).*(P + P.^(-1) - sin(theta).^2) / 2;
end