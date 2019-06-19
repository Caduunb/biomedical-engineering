% Example 11.3  Create a 10000 sample vector of Guassian noise of evenly distributed 
% noise and use histogram2 to % create a the joint-frequency plot.  
% Use imagesc to view the plot.
% Use a range from the minimum and maximum values of your vectors and 50
% binsto create the histogram plot.  Then get the X and Y histograms by
% summing across the rows and colums

close all; clear all;
nu_bin = 50;            % Number of bins. 
x = randn(1,10000);     % Create signals; Gaussian noise
y = rand(1,10000);      %    Uniform noise
H = hist2(x,y,nu_bin);  % Use hist2 to get 2D histogram
                                                               
colormap gray % Set the colormap to grayscale
subplot(1,2,1)
  pcolor(-H);
   shading('interp');
 %imagesc(-H)    % Use negative H so that higher values are darker in plot
  xlabel('Joint X Y Histogram')
     set(gca,'FontSize',12)
     text(5,5,'A','fontsize',12)
subplot(2,2,2)
  bar(sum(H),'c')
  xlabel('Histogram of Y')
    set(gca,'FontSize',12)
    text(5,250,'B','fontsize',12)
    axis([0,50,0,300])
subplot(2,2,4)
  bar(sum(H,2),'c')
  xlabel('Histogram of X')
  set(findall(gcf,'type','text'),'FontSize',12) 
  set(gca,'FontSize',12)
  text(5,600,'C','fontsize',12)