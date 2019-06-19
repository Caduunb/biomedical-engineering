% Example 15.3 and Figure 15.9
%  Example of reconstruction using the Fan Beam Geometry
% Reconstructs a pattern of 4 square of different intensities
%       using parallel beam and fan beam approaches.
%
clear all; close all;
D = 150;                      % Distance between fan beam vertex and center of rotation 
theta = (1:180);              % Angle between parallel projections is one degree
%
I = zeros(128,128);           % Generate image:, simple square
I(22:54,22:52) = .25;         % Four squares of different 
I(76:106,22:52) = .5;         %  shades against a black 
I(22:52,76:106) = .75;        %  background
I(76:106,76:106) = 1;
%
% Construct projections
[F,Floc,Fangles] = fanbeam(I,D);   % Fan beam projections
[R,xp] = radon(I,theta);      % Parallel beam porjections
%
% Reconstruct images.  Use Shepp-Logan filter
I_rfb = ifanbeam(F,D);
I_rpl = iradon(R,theta,'Shepp-Logan');
%
% Display images
subplot(1,2,1);
    imshow(I_rfb); title('Fan Beam')
subplot(1,2,2);
    imshow(I_rpl); title('Parallel Beam')