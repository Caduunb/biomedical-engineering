function err = realign1(scale, I, I_transform);
%  Function used by 'fminsearch' to rescale an image 
%     horizontally, vertically, and with tilt.  
%  Performs transformation and computes correlation between
%  original and newly transformed image
%  Inputs:
%       scale  Current scale factor (from 'fminsearch')
%       I   originaly image
%       I_transform  image to be realigned
% Outputs:
%       Negative correlation between original and transformed image
%
[M N]= size(I);  
U = [1 1; 1 M; N M];          % Input triangle
% Perform transformation
X = [1+scale(1)+scale(3) 1 + scale(2); 1+scale(1) M; N-scale(1) M];
Tform = maketform('affine', U, X);
I_aligned = imtransform(I_transform,Tform,'bicubic','Xdata',[1 N],'Ydata',[1 M]);
% Calculate negative correlation
err =  -abs(corr2(I_aligned,I));
