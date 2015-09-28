% This script shows how to set up a problem with arbitrary basis 
% functions given by the phi matrix in the .mat file, and some artificial data.

%% Setup
clear all; close all; clc;

addpath ../..                      % add path to main code
load example_mixed_basis           % load the test data

N = size(X,1);                               % number of samples

f.ndim = size(X,2);    % number of directions
f.ord = ord;           % order of basis in each direction
f.X.train = X;         % X data
f.y.train = y;         % y data
f.cv = false;          % use cross validation error for ALS

f.Phi.train = cell(1,f.ndim);   % form the phi matrices
for d = 1:f.ndim
  f.Phi.train{d} = phi{d};
end

% check data structure, exit if failed
flag = check_data_struct(f);  
if ~flag;
  fprintf('Something is wrong!\n'); return
else
  fprintf('Problem was set up successfully!\n')
end