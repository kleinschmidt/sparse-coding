function display_trsc(U,whiten)

% U is 255-by-256 (num by dim)
% dewhtU is 2048-by-255 (dim-by-num)
% (dewhitened) basis functions are 16-by-128
dewhtU = U*whiten;
minu = -1;%min(dewhtU(:));
maxu = 1;%max(dewhtU(:));

% number of rows and columns in the plot.
rs = 4;
cs = 64;

bfrs = 128;
bfcs = 16;

bfs = ones(rs*(bfrs+1), cs*(bfcs+1))*maxu;

i=0;

for r=1:rs
    for c=1:cs
        i=i+1;
        if i > size(dewhtU,1), continue, end
        bf = reshape(dewhtU(i,:), bfcs,bfrs);
        bfs( (1:bfrs)+(r-1)*(bfrs+1), (1:bfcs)+(c-1)*(bfcs+1) ) = ...
            bf(:,end:-1:1)'/max(abs(bf(:)));
    end
end

colormap(gray(256));
iptsetpref('ImshowBorder','tight'); 
subplot('position',[0,0,1,1]);
imshow(bfs,[minu maxu]);
truesize;  
drawnow;
