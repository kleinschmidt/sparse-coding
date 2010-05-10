function U = maxTRSC(p)

global Z Zlag U

% get size of input data:
% N = number of dimensions of the stimuli
% T = number of samples (times)
[N T] = size(Z);
K = N-1;

% if no maximum is specified on the number of iterations, go until
% tolerance is satisfied
fid = fopen(p.outfn, 'w');

% initialize the (whitened) U basis functions U
%U = symOrth(rand(K, N));

% initialize counters and stuff
fold = 0;
n = 0;
alpha = p.alpha;

f = @(W) objective(W,Z,Zlag);
fnew = f(U);

while ((fnew-fold >= p.tol) & (n <= p.maxIter))
    fold = fnew;
    % convolve filters with Zs to get ys.
    Yt = U*Z;
    Ydt = U*Zlag;
    dU = (gp(Yt).*g(Ydt)) * Z' + (g(Yt).*gp(Ydt)) * Zlag';

    m = 0;
    fprintf('n = %4d, m =%3d', n, m);
    Unext = symOrth(U + (alpha/2^m)*dU);
    fnew = f(Unext);
    while (fnew <= fold)
        fprintf('\b\b\b%3d', m);
        m=m+1; 
        Unext = symOrth(U + (alpha/2^m)*dU);
        fnew = f(Unext);
    end

    % adapt alpha
    if (mod(n,p.updateAlphaEvery)==0)
        alphas = [.5 1 2]*alpha;
        fvals = [f(U+alphas(1)*dU), f(U+alphas(2)*dU), f(U+alphas(3)*dU)];
        alpha = alphas(max(find(fvals==max(fvals))));
    end
    
    % display
    if (mod(n,p.displayEvery)==0)
        p.plotfcn(U);
    end

    U = Unext;
    n = n+1;
    
    % print output
    % to screen
    fprintf(', alpha = %.3g, f(U) = %g\n', alpha, fnew);
    % to file, if one's specified.
    fprintf(fid, '%d,%d,%g,%g', n,m,alpha,fnew);
    fprintf(fid, ',%g', U);
    fprintf(fid, '\n');
end


function B = symOrth(A)
% convert A to nearest orthonormal matrix B (wrt Frobenius matrix norm)
B = real(A/sqrtm(A'*A));

function y = g(x)
% nonlinearity function
y = log(cosh(x));

function y = gp(x)
% derivative of nonlinearity function
y = tanh(x);

function y = objective(A,Z,Zlag)
% objective function
y = sum(mean(g(A*Z).*g(A*Zlag), 2));