function imagew = whiten_image(image)

% get the dimensions of the image
[Ny, Nx] = size(image);
% rescale the image to go from 0 to 1
image = (image-min(image(:))) / range(image(:));
% make the filter
[fx fy]=meshgrid(-Nx/2:Nx/2-1,-Ny/2:Ny/2-1);
rho=sqrt(fx.*fx+fy.*fy);
f_0=0.4*(Nx+Ny)/2;
filt=rho.*exp(-(rho/f_0).^4);
% apply it to the image
If = fft2(image);
imagew = real(ifft2(If .* fftshift(filt)));
