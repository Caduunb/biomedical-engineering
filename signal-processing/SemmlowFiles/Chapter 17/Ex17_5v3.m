% Example 17.5 Cross-validation example. Trains a three layer neural net  
%   as in Ex 17.4, but stops when the validation error starts to 
%   increase.  Plots to progression of both training and validation
%   set errors.  Uses data with overlaps
%
clear all; close all;
alpha = .2;
hl1 = 6;                % Number of neurons in hidden layer 1
hl2 = 6;                % Number of neurons in hidden layer 2
% Generate training and validation data with some overlaping points 
[Xt dt] = gen_data2(4.75,[],'d'); % Training set
[Xv dv] = gen_data2(4.75,[],'d',[],24);  % Validation set
% Generate initial weights for both layers
 [r,nu_inputs] = size(Xt);
 [W1 b1 W2 b2 W3 b3] = initialize_weights(5,nu_inputs,hl1,hl2);
 last_mse_validation = 2;           %Initial validation mean squared error
for k3 = 1:100
    for k1 = 1:20
        [W1,b1,W2,b2,W3,b3] = net_learn_3(Xt,dt,alpha,W1,b1,W2,b2,W3,b3);  
    end
    mse_training(k3) = net_eval(Xt,dt,W1,b1,W2,b2,W3,b3);   % Eval. training
    mse_validation(k3) = net_eval(Xv,dv,W1,b1,W2,b2,W3,b3); % Eval. validation
    if mse_validation(k3) > last_mse_validation   
       disp('Validation error increase')
       %break;
   end
   last_mse_validation = mse_validation(k3);
   disp([mse_validation(k3) last_mse_validation mse_training(k3)])
end
[sensitivity, specificity] = net_boundaries(Xt,dt,W1,b1,W2,b2,W3,b3);
title(['Sensitivity: ',num2str(sensitivity,3),'% Specificity: ',num2str(specificity,3),'%'],'FontSize',14);
% 
figure;
[sensitivity, specificity] = net_boundaries(Xv,dv,W1,b1,W2,b2,W3,b3);
title(['Sensitivity: ',num2str(sensitivity,3),'% Specificity: ',num2str(specificity,3),'%'],'FontSize',14);
disp(['Epochs: ',num2str(20*k3)])
figure;  %Plot errors (learning curve)
x_plot = (1:length(mse_training))*20;  % Used for plotting learning curves
plot(x_plot,mse_training,':k', x_plot,mse_validation,'k');
xlabel('Epochs','FontSize',14); ylabel('Mean Squared Error','FontSize',14);
