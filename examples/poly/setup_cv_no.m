% This script shows you how you might set up the regression problem given
% some data.

clear all; close all; clc;

addpath ../..                 % add path to main code
load example_poly_basis.mat   % load the test data

N = size(X,1);                               % number of samples

f.ndim = size(X,2);    % number of directions
f.deg = deg;           % degree of polynomial in each direction
f.ord = f.deg + 1;     % order of the basis in each direction
f.X.train = X;         % X data
f.y.train = y;         % y data
f.cv = false;          % dont' use cross validation error for ALS

% generate phi matrices ... we can automate this at some point, but need to
% think carefully about thow.
f.Phi.train = cell(1,f.ndim);
for d = 1:f.ndim
  %x_train = repmat(f.X.train(:,d),[1,f.ord(d)]);
  %deg_train = repmat(0:f.deg(d),[size(x_train,1),1]);
  %f.Phi.train{d} = x_train .^ deg_train;
  f.Phi.train{d} = generate_legendre_values(f.deg(d),f.X.train(:,d),0);
end

flag = check_data_struct(f);  % checks the data structure

if ~flag;  % if didn't pass checks, exit and see what happened
  fprintf('Something went wrong in your setup!\n')
  return
else
  fprintf('Problem was set up successfully!\n')
end