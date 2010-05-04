% classify points using knn.
% this is bad. remember kids: using training data for testing is BAD

[npts ndim] = size(pts);
k = 20;
ndim = 800;

knnlabs = cell(size(labels));
uniqlabs = unique(labels);

fprintf('\n\n    ');

for i=1:npts
    fprintf('\b\b\b\b%4d', i);
    %if mod(i,100)==0, fprintf('.'); end
    testinds = [1:i-1, i+1:npts];
    [vote uniqnn counts] = knn(pts(i,1:ndim), pts(testinds, 1:ndim), labels(testinds), k);
    knnlabs{i} = vote;
end

fprintf('\n\n');

%% confusion table

%confusions = zeros(length(uniqlabs));
