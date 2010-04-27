
% load patches from saved auds
global X;
[X, whiteningMatrix, dewhiteningMatrix] = aud_data(50000, 16, 160);

outfn = [sparse_coding_dir '/output/topo_ica.mat']

% set paramters
p.seed = 1;
p.write = 5;
p.model = 'tica';
p.algorithm = 'gradient';
p.xdim = 16;
p.ydim = 10;
p.maptype = 'torus';
p.neighborhood = 'ones3by3';
p.stepsize = 0.1;
p.epsi = 0.005;
estimate( whiteningMatrix, dewhiteningMatrix, outfn, p );

