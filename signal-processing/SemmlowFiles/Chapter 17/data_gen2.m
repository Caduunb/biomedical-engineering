% Program to generate data for problems
% Produces both test and training data
%
clear all; close all;
npts = input('training set number');
nu_val = input('validation set number');
test_number = input('test set number');
distance = input('distance');
angle = input('angle');
type = input('data type','s');
[X,d] = gen_data2(distance,angle,type,[0,1],npts);
if test_number > 0
  figure;
  Xt = X;
  dt = d;
  clear X d;
  [X,d] = gen_data2(distance,angle,type,[0,1],test_number);
end

if nu_val > 0
    figure;
    [Xv,dv] = gen_data2(distance,angle,type,[0,1],nu_val);
end
    

