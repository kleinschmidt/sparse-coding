
% load patches from saved auds
global X;
[X, whiteningMatrix, dewhiteningMatrix] = aud_data(50000, 16, 160);

outfn = [sparse_coding_dir '/output/hoyer_ica.mat']

p.seed = 1;
p.write = 5;
p.model = 'ica';
p.algorithm = 'fixed-point';
p.components = 160;
  
estimate( whiteningMatrix, dewhiteningMatrix, outfn, p );

