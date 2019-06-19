% Example 12.3 
% Generate a movie of a mulitframe array consisting of sinewave gratings that vary
%   in phase from 0 to 2*pi across 12 images
% Since function 'immovie' requires either RGB or Indexed data formats, use
%  the indexed format, scale the data,  and use a standard colormap ('jet')
%
% The gratings should be the same as in Example 10.2. 
%
clear all; close all;
N = 100;                            % Vertical and horizontal points 
Nu_cyc = 2;                         % Produce 4 cycle grating
M = 20;                             % Produce 20 images
x = (1:N)*Nu_cyc/N;                 % Generate spatial vector 
for j = 1:M                         % Generate M (20) images
    % Generate sine; scale between 0 and 1
    phase = 2*pi*j/M;               % Shift phase through 180 (pi)every 10 images
    I_sin(1,:) = .5 * sin(2*pi*x + phase) + .5;
    I_8 = im2uint8(I_sin);          % Convert to a uint8 vector
    Mf(:,:,1,j) = repmat(I_8,100,1);     % Add 100 rows;
end    
%
[Mf map] = gray2ind(Mf);            % Use default map length of 64
% The movie function requires either RGB format or indexed format
mov = immovie(Mf,jet);              % Make into a movie
movie(mov,4);                       %   and display 4 times 
    