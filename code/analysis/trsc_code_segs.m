function [proj nr nc sz numbases] = code_segs(segs, W, sz, outfn)
% function projected = code_segs(segs, W, sz[, outfn])
%
% Codes the segments in segs by breaking them into patches and projecting
% those patches into the basis-space described by basis.


fprintf('Coding segments into TRSC basis space.\n');

numsegs = length(segs);
[numbases dummy] = size(W);
[ps nr nc] = strobe_patches(segs(1).aud, sz);
proj = zeros(nr*nc*numbases, numsegs);

fprintf('  input size: %d %d-by-%d patches for each of %d segments\n', ...
    nr*nc, sz, numsegs);
fprintf('  output size: %d-by-%d matrix of projections into basis space\n', ...
    size(proj));

fprintf('  processing segment no.%4d', 0);

for i=1:numsegs
    fprintf('\b\b\b\b%4d (strobing)', i);
    [ps nr nc] = strobe_patches(segs(i).aud, sz);
    % subtract local mean and normalize to have unit norm
    fprintf([repmat('\b', size(' (strobing)')), ' (normalizing)']);
    ps = ps - ones(size(ps,1),1)*mean(ps);
    ps = ps ./ (ones(size(ps,1),1)*sqrt(sum(ps.^2)));
    fprintf([repmat('\b', size(' (normalizing)'))]);
    % convolve with basis functions
    y = W*ps;
    proj(:,i) = y(:);
end

% % print output to file if a name is specified
% if nargin > 3
%     fid = fopen(outfn, 'w');
%     fprintf('  writing output to file %s\n', outfn);
%     % print header
%     fprintf(fid, 'phn');
%     for c=1:nc
%         for r=1:nr
%             for a=1:numbasis
%                 fprintf(fid, ',a%d-t%d-f%d', a, r, c);
%             end
%         end
%     end
%     fprintf(fid, '\n');
%     
%     lineformat = ['%s', repmat(',%g', [1,nr*nc*numbasis]), '\n'];
%     fprintf(['   line ' repmat(' ', [1 2*digits+7])]);
%     for i=1:size(projected, 1)
%         fprintf(str, i);
%         fprintf(fid, lineformat, segs(i).phn, projected(i,:));
%     end
%     fprintf('done\n');
%     
%     fclose(fid);
% end
