function err = rotation_align(angle, I,I_rot);
%  Function to rotate the image by an angle angle and calculate the error
%
I_proj = imrotate(I_rot,angle,'bilinear','crop');
err =  -abs(corr2(I_proj,I));
