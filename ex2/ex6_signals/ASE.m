function errord=ASE(c,e)
N=length(e);
errord=sum((c(N/2:N)-e(N/2:N)).^2)/sum(c(N/2:N).^2);
end