%% KNN Analysis -- classify segments using KNN in acoustic PCA and ICA
%% spaces

%% Acoustic stuff
[npts ndim] = size(score1);

maxdim = 200;
k = 10;
votes = cell(npts, 1);
allvotes = cell(npts, k);

fprintf('    ');

for i=1:npts
    fprintf('\b\b\b\b%4d', i);
    inds = [1:i-1, i+1:npts];
    [v vs] = knn(score1(i,1:maxdim), score1(inds,1:maxdim), labs(inds), k);
    votes(i) = v;
    allvotes(i,:) = vs;
end

%% write some output
outf = fopen('output/knn_aud_only.csv', 'w');
header = ['real,winv' sprintf(',v%d', 1:k) '\n'];
fprintf(outf, header);

formstr = ['%s,%s' repmat(',%s', [1,k]) '\n'];

for i=1:npts
    fprintf(outf, formstr, labs{i}, votes{i}, allvotes{i,:});
end

fclose(outf);


%% Sparse-coding stuff
[npts ndim] = size(score);

maxdim = 200;
k = 10;
votesSC = cell(npts,1);
allvotesSC = cell(npts,k);

fprintf('    ');

for i=1:npts
    fprintf('\b\b\b\b%4d', i);
    inds = [1:i-1, i+1:npts];
    [v vs] = knn(score(i,1:maxdim), score(inds,1:maxdim), labs(inds), k);
    votesSC(i) = v;
    allvotesSC(i,:) = vs;
end

%% write some output
outf = fopen('output/knn_sc.csv', 'w');
header = ['real,winv' sprintf(',v%d', 1:k) '\n'];
fprintf(outf, header);

formstr = ['%s,%s' repmat(',%s', [1,k]) '\n'];

for i=1:npts
    fprintf(outf, formstr, labs{i}, votesSC{i}, allvotesSC{i,:});
end

fclose(outf);


%% Temporal-coherence stuff
% these variables can be loaded from output/pca_coded_segs_trsc.mat

[npts ndim] = size(trsc_seg_pc);
maxdim = 400;
k = 10;
votesTRSC = cell(npts,1);
allvotseTRSC = cell(npts,k);

fprintf('KNN analysis (k=%d) on TRSC-projected\n  using first %d PCs\n', k, maxdim);
fprintf('  processing segment no. %4d', 0);

for i=1:npts
    fprintf('\b\b\b\b%4d', i);
    inds = [1:i-1, i+1:npts];
    [v vs] = knn(trsc_seg_pc(i,1:maxdim), trsc_seg_pc(inds,1:maxdim), labs(inds), k);
    votesTRSC(i) = v;
    allvotesTRSC(i,:) = vs;
end
    
    
    
    