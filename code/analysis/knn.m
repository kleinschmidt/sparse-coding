function [vote votes kdists I] = knn(test, pts, labels, k)
% function [vote votes kdists I] = knn(test, pts, labels, k)

[npts, ndim] = size(pts);

dists = sum((repmat(test, size(pts)./size(test)) - pts).^2, 2);
[dsort dorder] = sort(dists);

% find the k nearest neighbors
votes = labels(dorder(1:k));
kdists = dists(dorder(1:k));
I = dorder(1:k);

uniquenn = unique(votes);
nncount = zeros(size(uniquenn));

% count the votes
for i=1:length(votes)
    for j=1:length(uniquenn)
        if strcmp(uniquenn{j},votes{i})
            nncount(j) = nncount(j)+1;
        end
    end
end

%for i=1:length(uniquenn), fprintf('%4s %d\n', uniquenn{i}, nncount(i)); end

% pick winner, breaking ties randomly as necessary
vote = uniquenn(nncount==max(nncount));
if length(vote)>1
    r = randperm(length(vote));
    vote = vote(r(1));
end
