% Example 10.6 Using the Hénon map, find all the nearest neighbors that are
%  less than a threshold distance away from an arbitrary point on the 
%  trajectory.   For this example, use the 50th point as a test point and 
%  use threshold distances of 0.1 and 0.2.

clear all
close all
N = 99;                  % Get 10000 values of Henon map
x=.1; y=.1; a=1.4; b=.3; % Set up constants and initial conditions
r1 = .03; r2 = .05;      % The radii tested
p = 50;                  % We are tested the 50th point  
for k=1:N  %  Step through N iterations
    x(k+1)=1-a*x(k).^2+y(k);  % x and y equations for Henon map
    y(k+1)=b*x(k);
end
tau = 1;
m = 2  % Use a delay of 1 and m of 2
Hen = delay_emb(y,m,tau);     % We use the y vector

testp = Hen(p,:);  % Get 50th point in attractor as test point
testp = repmat(testp,N+1-tau,1);  % Make whole vector for subtracting later

dist = sqrt(sum((testp-Hen).^2,2));  % This is the same as equation 10.11

n1 = dist(dist < r1); % Find points where distance is less than r1
n1(n1==0)= [];        % Remove self match
n2 = dist(dist < r2); % Find points where distance is less than r2
n2(n2==0)= [];        % Remove self match

numnear1 = length(n1); % Get number of nearest neighbors for first radius   
numnear2 = length(n2); % Get number of nearest neighbors for second radius
% plotting
% Use function viscircles to make the circular sections

    plot(Hen(:,1),Hen(:,2),'.k','markersize',15)
    hold on
    plot(Hen(p,1),Hen(p,2),'*k','markersize',15)
    viscircles([Hen(p,:)],r1,'EdgeColor','k','linewidth',3)  
    viscircles([Hen(p,:)],r2,'EdgeColor','k','linestyle','--','linewidth',3)
    axis equal
    xlabel('x [n]')
    ylabel('y [n]')
    set(gca,'FontSize',14)
    axis( [-0.0238 0.2043,0.2476 0.3655])
    set(findall(gcf,'type','text'),'FontSize',14)
    title('Nearest Neighbors in 2 Dimensions for two Radii')
    text(0.01,0.35,'B','fontsize',14)
