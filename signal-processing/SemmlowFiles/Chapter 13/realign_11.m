function err = realign_11(Corner, I, I_transform);
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
U = [1 1; 1 M; N M; N 1];       %Input rectangle
% Perform transformation
 X = [1+Corner(1) 1+Corner(1); 1-Corner(2) M-Corner(2); N+Corner(4) M-Corner(3); N-Corner(4) 1+Corner(4)]; 
 Tform = maketform('projective', U, X);
I_aligned = imtransform(I_transform,Tform,'Xdata',[1 N],'Ydata',[1 M]);
% Calculate negative correlation
err =  -abs(corr2(I_aligned,I));
