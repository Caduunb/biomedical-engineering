% Example 11.7 Application of spectral entropy to sinusoid
%
clear all; close all;
fig1 = figure;
fig2 = figure;
f = 100;   			% Signal frequency
fs = 10000;			% Sample frequency
N = 1000;			% Number of points    
t = (0:N-1)/fs;  		% Generate time vector 
frq = (0:N/2-1)/N*fs;     % Generate frequecy vector  
% Construct test signals
x(1,:) = sin(t*f*2*pi);        % Make sine wave
x(2,:) = x(1,:) + .1 * cumsum(randn(1,N)); % Make noise sine corrupted with correlated noise
for k = 1:2        %  Repeat the process twice, one time for each signal
   
        %compute normalized power spectrum
        psx=abs(fft(x(k,:))).^2;  % Get power spectrum
        psx=psx(1:(N/2));    % Get frequencies below fs/2
        Q=psx/sum(psx);    % Normalize as in Eq. 11.14 
        H=Q.*log2(1./(Q))/log2(N/2); % Apply Eq. 11.15
        H(isnan(H))=0;                  % Remove any potential Nans caused
                                        % by the log operation
        entropy(k) = sum(H);            % Equation 11.16                         
        %plot the figures        
        t1=linspace(0,1,1000);
        figure(fig1); hold on;
          subplot(2,2,(k-1)*2+1);
            plot(t,x(k,:),'k','linewidth',1)
            grid on 
            title('Signal','fontsize',12)
            xlabel('Time (s)','fontsize',12)
          subplot(2,2,2*k);
           stem(frq,Q,'k','linewidth',2);
            ylabel('Normalized Power','fontsize',12);
            xlabel('Frequency (Hz)','fontsize',12);
            title('Power Spectrum','fontsize',12);
            axis([0 200 0 1.2]);
           grid on;
 
        figure(fig2); hold on
        subplot(1,2,k);
            stem(Q,H,'k','linewidth',2)
            hold on;
             plot(t1,t1.*log2(1./t1)/log2(N/2),'--k','linewidth',2);
            grid on;
        title('Transformed Power Spectrum','fontsize',12)
            xlabel('Normalized Power','fontsize',12)
         ylabel('Shannon Transformation','fontsize',12)
end

