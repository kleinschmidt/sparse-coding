function view_patches_by_freq(u)

figure(1001);
[nt, nf, nA] = size(u);

u = u.^2;

% rescale u to span colormap, chopping off the most extreme 2% of u's
ncolor = length(colormap());
minu = quantile(u(:), 0.02);
maxu = quantile(u(:), 0.98);
cscale = @(x) (x-minu)/(maxu-minu)*ncolor;

for i=1:nf
    subplot(nf,1,i);
    image(reshape(cscale(u(:,i,:)), nt,nA));
end