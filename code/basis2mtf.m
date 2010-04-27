function mtf = basis2mtf(A, show)
% function mtf = basis2mtf(A) - convert sparse-coding basis fcn to MTF
%
% Takes an array of basis functions learned by sparsenet.m and converts
% them to an array of modulationg transfer functions (via 2D FFT)

[L M]=size(A);
sz=sqrt(L);

mtf = zeros(L,M);
for i = 1:M
    basis = reshape(A(i,:), sz, sz);
    ffted = fft2(basis);
    mtf(i,:) = reshape(ffted, L, 1);
end