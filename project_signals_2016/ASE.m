function ase=ASE(c,e)
t=length(c);
ase=(c(t/2+1:t)-e(t/2+1:t))*(c(t/2+1:t)-e(t/2+1:t))'/(c(t/2+1:t)*c(t/2+1:t)');
end