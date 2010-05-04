function [vote uniqnn counts I] = knn(test, pts, labels, k)
% Do K-nearest neighbor classification

dists = sum((repmat(test, size(pts)./size(test)) - pts).^2, 2);
[s order] = sort(dists);

I = order(1:k);
nn = labels(I);
uniqnn = unique(nn);
counts = zeros(size(uniqnn));
for i=1:length(uniqnn)
    for j=1:k
        if strcmp(nn{j}, uniqnn{i}), counts(i)=counts(i)+1; end
    end
end

% pick winner, breaking ties by lexicographic order
[counts nnorder] = sort(counts(:), 1, 'descend');
uniqnn = uniqnn(nnorder);
vote = uniqnn{1};