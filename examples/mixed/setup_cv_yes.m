% This script shows how to set up a problem with arbitrary basis functions
% given by the phi matrix in the .mat file, and some artificial data.
% The setup supports use of cross validation within ALS iteration.

%% Setup
clear all; close all; clc;

addpath ../..                      % add path to main code
load example_mixed_basis           % load the test data

N = size(X,1);                               % number of samples
itest = randsample(1:N,ceil(N/10),'false');  % CV test data
itrain = 1:N;  itrain(itest) = [];           % CV training data

f.ndim = size(X,2);    % number of directions
f.ord = ord;           % order of basis in each direction
f.X.test = X(itest,:);    % X data
f.X.train = X(itrain,:);  
f.y.test = y(itest,:);    % y data
f.y.train = y(itrain,:);
f.cv = true;              % use cross validation error for ALS

f.Phi.train = cell(1,f.ndim);   % form the phi matrices
f.Phi.test = cell(1,f.ndim);
for d = 1:f.ndim
  f.Phi.train{d} = phi{d}(itrain,:);
  f.Phi.test{d} = phi{d}(itest,:);
end

% optional paramters
f.ix.train = itrain;
f.ix.test = itest;

% check data structure, exit if failed
flag = check_data_struct(f);  
if ~flag;
  fprintf('Something is wrong!\n'); return
else
  fprintf('Problem was set up successfully!\n')
end