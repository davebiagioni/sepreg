% This script tests the data structure and ALS for the type 'poly'.  It
% loads some example data 

clear all; close all; clc;

load example_poly_basis.mat   % load the test data

N = size(X,1);                               % number of samples
itest = randsample(1:N,ceil(N/10),'false');  % CV test data
itrain = 1:N;  itrain(itest) = [];           % CV training data

f.ndim = size(X,2);    % number of directions
f.deg = deg;           % degree of polynomial in each direction
f.ord = f.deg + 1;     % order of the basis in each direction
f.X.test = X(itest,:);    % X  test data
f.X.train = X(itrain,:);  % X training data
f.y.test = y(itest,:);    % y test data
f.y.train = y(itrain,:);  % y training data
f.cv = true;             % use cross validation error for ALS

% generate phi matrices ... we can automate this at some point, but need to
% think carefully abou thow.
f.Phi.train = cell(1,f.ndim);
f.Phi.test = cell(1,f.ndim);
for d = 1:f.ndim
  %x_train = repmat(f.X.train(:,d),[1,f.ord(d)]);
  %x_test = repmat(f.X.test(:,d),[1,f.ord(d)]);
  %deg_train = repmat(0:f.deg(d),[size(x_train,1),1]);
  %deg_test = repmat(0:f.deg(d),[size(x_test,1),1]);
  %f.Phi.train{d} = x_train .^ deg_train;
  %f.Phi.test{d} = x_test .^ deg_test;
  f.Phi.train{d} = generate_legendre_values(f.deg(d),f.X.train{d},0);
  f.Phi.test{d} = generate_legendre_values(f.deg(d),f.X.test{d},0);
end

% optional fields
f.ix.train = itrain;
f.ix.test = itest;

flag = check_data_struct(f);  % checks the data structure

if ~flag;  % if didn't pass checks, exit and see what happened
  fprintf('Something went wrong in your setup!\n')
  return
else
  fprintf('Problem was set up successfully!\n')
end