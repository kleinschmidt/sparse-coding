function [projected nr nc sz numbasis] = code_segs(segs, A, outfn)
% function projected = code_segs(segs, A[, outfn])
%
% Codes the segments in segs by breaking them into patches and projecting
% those patches into the basis-space described by A.

fprintf('Coding segments into basis space.\n');

numsegs = length(segs);
[sz numbasis] = size(A);
sz = sqrt(sz);
[p nr nc] = make_patches(segs(1).wht, sz);
% put all the row- (time-) padding at the front to cut off lead-in
padding = [mod(size(segs(1).wht,1),nr), 0];

fprintf('  using %d*%d=%d patches (%d-by-%d) for %d segments\n', ...
    nr, nc, nr*nc, sz, sz, numsegs);

projected = zeros(numsegs, nr*nc*numbasis);


digits = length(num2str(numsegs));
fprintf(['  processing segment ' repmat(' ', [1 2*digits+7])]);
str = [repmat('\b', [1, 2*digits+7]) ...
       '%' num2str(digits) 'd of ' num2str(numsegs) '...'];
for i=1:numsegs
    fprintf(str, i);
    seg = segs(i);
    ps = make_patches(seg.wht, sz, padding);
    proj = A'*ps;
    projected(i,:) = proj(:)';
end
fprintf('done\n');

% print output to file if a name is specified
if nargin > 2
    fid = fopen(outfn, 'w');
    fprintf('  writing output to file %s\n', outfn);
    % print header
    fprintf(fid, 'phn');
    for c=1:nc
        for r=1:nr
            for a=1:numbasis
                fprintf(fid, ',a%d-t%d-f%d', a, r, c);
            end
        end
    end
    fprintf(fid, '\n');
    
    lineformat = ['%s', repmat(',%g', [1,nr*nc*numbasis]), '\n'];
    fprintf(['   line ' repmat(' ', [1 2*digits+7])]);
    for i=1:size(projected, 1)
        fprintf(str, i);
        fprintf(fid, lineformat, segs(i).phn, projected(i,:));
    end
    fprintf('done\n');
    
    fclose(fid);
end
