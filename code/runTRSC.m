%% Preprocess and run the temporal coherence model.

cd(sparse_coding_dir);
if ~exist('filestruct', 'var'), load('clips/whitened_auds.mat'); end
fs = filestruct;

%% randomly pick files/starting points
% size of time lag, in frames
dt = 5; %= 40 ms
npatches = 10000;
patchlen = 16;

t_inds = zeros(2,0);
for i=1:length(fs),
    aud_len = size(fs(i).aud, 1);
    ts = dt+1:aud_len-patchlen;
    t_inds = [t_inds, [repmat(i,1,aud_len-dt-patchlen); ts]];
end

randts = randperm(size(t_inds, 2));

%% extract and reshape patches into matrix X

nchan = size(fs(1).aud, 2);

X = zeros(patchlen*nchan, npatches);
Xlag = zeros(size(X));

for i=1:npatches
    fn = t_inds(1,randts(i));
    t = t_inds(2,randts(i));
    aud = fs(fn).aud;
    % extract and normalize patch
    pt = aud((1:patchlen)+t, :);
    pdt = aud((1:patchlen)+t-dt, :);
    X(:,i) = pt(:);
    Xlag(:,i) = pdt(:);
end

%% Normalization
for i=1:npatches
    X(:,i) = X(:,i)-mean(X(:,i));
    X(:,i) = X(:,i) / norm(X(:,i));
    Xlag(:,i) = Xlag(:,i)-mean(Xlag(:,i));
    Xlag(:,i) = Xlag(:,i) / norm(Xlag(:,i));
end


%% PCA whitening.
% calculate the covariance matrix for all observations
Cx = cov([X Xlag]');
% eigenvalue decomposition:
[E,D] = eig(Cx);

% dimension reduction and decorrelation (whitening)
ndim = 256;
%%
[dummy,order] = sort(diag(-D));
E = E(:,order(1:ndim));
d = diag(D); 
d = real(d.^(-0.5));
D = diag(d(order(1:ndim)));

whiten = D*E';
dewhiten = E*D^(-1);

Z = whiten*X;
Zlag = whiten*Xlag;

% TO CONVERT WHITENED BASIS FUNCTIONS TO UNWHITENED:
% W = U*whiten;
% (since y = U*Z = U*whiten*X = W*X)


%% Run the model:

global U Z Zlag
p = struct(...
    'alpha', .5, ...
    'tol', 0, ...
    'outfn', [sparse_coding_dir 'output/trsc_' date() '.csv'], ...
    'maxIter', 1000, ...
    'displayEvery', 1, ...
    'plotfcn', @(W) display_trsc(W,whiten), ...
    'updateAlphaEvery', 5);

fprintf('starting temporal coherence model\nwriting output to %s\n', p.outfn);
maxTRSC(p);