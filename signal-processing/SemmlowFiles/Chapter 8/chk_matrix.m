function matrix_out = chk_matrix(rxx_matrix)
%  Fuction to check if a matrix is singular and or ill conditioned
%  Assumes a Toeplitz matrix such a the correlation matrix
%     Automatically reduces rank if singular
%		Allows user to reduce matrix if ill conditioned
%
% matrix			is the input matrix
% matrix_out 	is the matrix output, potentially reduced

% Check if singular
rnk = rank(rxx_matrix);
[r,c] =size(rxx_matrix);
if rnk < r;
   disp(['Matrix singular: reduced to:',num2str(rnk)])
   matrix_out  = rxx_matrix(1:rnk,1:rnk);% Reduce matrix dimensions
else
   matrix_out = rxx_matrix;
end   
% Check conditioning
while (1)
   condition = cond(matrix_out);
   if condition > 10000
      disp(['Matrix ill-conditioned, SVD ratio = ',num2str(condition)])
   	rk = input('Suggest reduce order by (0 to exit)');
   	if rk == 0
         return
      else
         matrix_out = matrix_out(1:rnk,1:rnk); %Reduce matrix dimensions
      end
   else
      return
   end   
end
