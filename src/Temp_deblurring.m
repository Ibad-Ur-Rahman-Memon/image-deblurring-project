% Load the original image
Ioriginal = imread('C:\Users\princ\Documents\Ibad Documents\PIcs\formal pic.jpg');

% Convert the original image to double precision
Idouble = im2double(Ioriginal);

% Create the point spread function (PSF)
PSF = fspecial('motion', 21, 11);

% Blur the image
blurred = imfilter(Idouble, PSF, 'conv', 'circular');

% Perform Wiener deconvolution on the blurred image
wnr1 = deconvwnr(blurred, PSF);

% Add Gaussian noise to the blurred image
noise_mean = 0;
noise_var = 0.0001;
blurred_noisy = imnoise(blurred, 'gaussian', noise_mean, noise_var);

% Perform Wiener deconvolution on the blurred and noisy image (NSR = 0)
wnr2 = deconvwnr(blurred_noisy, PSF);

% Estimate the noise-to-signal ratio (NSR)
signal_var = var(Idouble(:));
NSR = noise_var / signal_var;

% Perform Wiener deconvolution on the blurred and noisy image (estimated NSR)
wnr3 = deconvwnr(blurred_noisy, PSF, NSR);

% Blur the original image with quantization effect
blurred_quantized = imfilter(Ioriginal, PSF, 'conv', 'circular');

% Perform Wiener deconvolution on the blurred quantized image (NSR = 0)
wnr4 = deconvwnr(blurred_quantized, PSF);

% Estimate the NSR for the quantized image
uniform_quantization_var = (1/256)^2 / 12;
NSR_quantized = uniform_quantization_var / signal_var;

% Perform Wiener deconvolution on the blurred quantized image (estimated NSR)
wnr5 = deconvwnr(blurred_quantized, PSF, NSR_quantized);

% Display all images in a single figure window with subplots
figure;

subplot(2, 3, 1);
imshow(Ioriginal);
title('Original Image');

subplot(2, 3, 2);
imshow(blurred);
title('Blurred Image');

subplot(2, 3, 3);
imshow(wnr1);
title('Restored Blurred Image');

subplot(2, 3, 4);
imshow(blurred_noisy);
title('Blurred and Noisy Image');

subplot(2, 3, 5);
imshow(wnr2);
title('Restoration of Blurred Noisy Image (NSR = 0)');

subplot(2, 3, 6);
imshow(wnr3);
title('Restoration of Blurred Noisy Image (Estimated NSR)');

figure;

subplot(1, 3, 1);
imshow(blurred_quantized);
title('Blurred Quantized Image');

subplot(1, 3, 2);
imshow(wnr4);
title('Restoration of Blurred Quantized Image (NSR = 0)');

subplot(1, 3, 3);
imshow(wnr5);
title('Restoration of Blurred Quantized Image (Estimated NSR)');
