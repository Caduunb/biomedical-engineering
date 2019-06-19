% function make_koch(N)
% Function to draw Koch Curve for N iterates
% The method is to plot rescaled versions of the N =1 iteration at the correct  % angle.  
% At every iteration, each straight line is replaced by the N = 1 iterate

 xs = [0,1];  % Initialize the line segment for N = 1
 ys = [0,0];
 xk = [0, 1/3,.5,(2/3),1];
 yk = [0, 0,sin(pi/3)*(1/3),0,0 ]; % This follows from the geometry
 temp = [xs',ys'];                 % Create N = 1 vector of (x,y) values
 kochs=zeros(4^N+1,2);      % Initialize the N length vector of (x,y) values

for ii = 1:N  % For the number of iterations
    numseg = 4^(ii-1);   % Total number of segments in curve
    length =(1/3)^(ii-1); % Length of each segment
    b = 0;                % Initialize x value of segment start
        for jj = 1:numseg  % For the number of segments in current iteration
             x =[temp(jj,1),temp(jj+1,1)];  % Get new straight segment
             y =[temp(jj,2),temp(jj+1,2)];
             t =atan2(y(2)-y(1),x(2)-x(1)); % Get angle of segment
             R = [cos(t),-sin(t);sin(t) cos(t)] ;  % Perform rotation 
				    		%  of N =1 segment
						   
             for i = 1:5  
               coord(i,:) = length *R*[xk(i);yk(i)]; % Do scaling
             end
            coord(:,1) = coord(:,1) + x(1); % Put segment at correct spot
            coord(:,2) = coord(:,2) + y(1);
            r2=5;
         if jj ~=numseg
             coord(5,:) = [];  % If segment is not the last segment
			       %  delete last point
             r2 = 4;
         end  
           a = b+1;      % Update the x values of the segment
           b = a+r2-1;   % Update the x values
         kochs(a:b,:)= [coord]; % Updates the kochs sample value
        end
        temp(1:(4^ii+1),:) = kochs(1:(4^ii+1),:);  % Update temp
end
        plot(temp(:,1),temp(:,2),'k') % Plot the values after N iterations
        axis equal
  
