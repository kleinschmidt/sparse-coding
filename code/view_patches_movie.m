function M = view_patches_movie(u)

figure(1002);
[nt, nf, nA] = size(u);

% using 16x16 patches and 8ms window for the AUDs
fps = 7.8125;

ncolor = 256;
map = gray(ncolor);
minu = quantile(u(:), 0.02);
maxu = quantile(u(:), 0.98);

ucol = ceil((u-minu)/(maxu-minu)*ncolor);
ucol(ucol<1) = 1;
ucol(ucol>ncolor) = ncolor;

zoom = ones(5);

for t=1:nt
    M(t) = im2frame(kron(reshape(ucol(t,:,:), nf,nA), zoom), map);
end

clf
axes('Position', [0 0 1 1]);
movie(M, 10, fps);