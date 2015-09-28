%% Setup
clear all; close all; clc;

addpath ../..                      % add path to main code
load pts.mat

N = size(pts,1);                               % number of samples

f.ndim = 2;    % number of directions
f.ord = [10,10];    % order of basis in each direction
f.X.train = pts(:,1:2);       % X data
f.y.train = pts(:,3);         % y data
f.cv = false;                      % use cross validation error for ALS

f.Phi.train = cell(1,f.ndim);   % form the phi matrices
for d = 1:f.ndim
  f.Phi.train{d} = repmat(pts(:,d),[1,f.ord(d)]);
  deg = repmat(0:(f.ord(d)-1),[N,1]);
  f.Phi.train{d} = f.Phi.train{d}.^deg;
end

% check data structure, exit if failed
flag = check_data_struct(f);  
if ~flag;
  fprintf('Something is wrong!\n'); return
else
  fprintf('Problem was set up successfully!\n')
end

% Parameters for ALS
tol = 1e-3;           % error tolerance
stucktol = 1e-7;      % stuck tolerance (absolute)
maxit = 50;           % iterations per rank
r0 = 1;               % initial sep rank
rmax = 10;             % max sep rank
vrb = 1;              % verbose flag

% run ALS
[f,yhat,err] = als(f,tol,stucktol,maxit,r0,rmax,vrb);