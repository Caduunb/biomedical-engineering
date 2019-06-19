%  Example 10.9  Use SVD to determine the best embedding dimension for an 
%  ECG signal.  In order to perform the decomposition, multiple times 
%  series are required arranged as a matrix.  First create this matrix by
%  using delayed versions of the original signal, then use svd to perform 
%  the decomposition.  Use a scree plot (see Section 9.2.2) and evaluate 
%  the breakpoint to determine the best embedding vector.

x=load('ECGtest.csv');    % Load the sample ECG file.
fs = 2100;                % Sampling frequency of the ECG file
% 

X = delay_emb(x,6,fs);    % Generate delayed signals
[U,S,pc]= svd(X', 'econ');% Perform the decomposition
eigen = diag(S).^2;       % Get the eigenvalues (diagonal elements) 
                          % elements of S
subplot(2,1,1)
    plot(x,'k','linewidth',1);
    grid on
    xlabel('samples')
    title('ECG Signal')
    set(gca,'FontSize',12)
    set(findall(gcf,'type','text'),'FontSize',14) 
subplot(2,1,2)
    plot(eigen,'k','linewidth',2);
    grid on
    xlabel('N');
    ylabel('Eigenvalue');
    title('Scree Plot');
    set(gca,'FontSize',14)
    set(findall(gcf,'type','text'),'FontSize',14) 
