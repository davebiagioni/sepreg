% This script sets up an example for ALS that uses a user supplied basis in
% each direction.  This may be implemented in a number of ways.  The
% approach used herein is one example.
%
% The X-data is uniformly spaced on the interval [-1,1] in each direction.
%
% The basis functions are chosen to be polynomials, trigonometric, and
% and Gaussians in the directions 1,2, and 3, resp.
%
% The script saves:
%
%  X = N-by-ndim matrix of x values.
%  y = N-vector of response values
%  ord = vector of orders (cardinality) of the basis in each direction
%  phi = ndim-cell of N-by-ord matrices of the basis functions evaluated at
%        the X nodes.

clear all; close all; clc;
addpath ../..

% problem parameters
ndim = 3;   % number of dimensions
N = 100;    % number of samples
rA = 5;     % separation rank of function generating data

% independent variables
X = linspace(-1,1,N)';
X = repmat(X,[1,ndim]);

%% Generate the phi matrices
phi = cell(1,ndim);  % cell containing the basis matrices

  % First direction: polynomial basis
  deg1 = 2;  % degree of the basis in the first direction
  ord1 = deg1+1;   % order of the basis
  x1 = repmat(X(:,1),[1,ord1]);
  dgr1 = repmat(0:deg1,[N,1]);
  phi{1} = x1 .^ dgr1;
  
  % Second direction: sines and cosines
  fcell2 = {@(x)(cos(pi*x)),@(x)(sin(pi*x)),@(x)(cos(2*pi*x)),@(x)(sin(2*pi*x))};
  ord2 = length(fcell2);
  x2 = repmat(X(:,2),[1,ord2]);
  phi{2} = zeros(N,ord2);
  for i = 1:ord2
    phi{2}(:,i) = fcell2{i}(x2(:,i));
  end
  
  % Third direction: shifted Gaussians
  cslow = 5;
  cfast = 10;
  fcell3 = {@(x)(1.5*exp(-(cslow*x).^2)),@(x)(1.5*exp(-(cslow*(x-.5)).^2)),...
    @(x)(1.5*exp(-(cslow*(x+.5)).^2)), @(x)(exp(-(cslow*(x-.25)).^2)+exp(-(cslow*(x+.25)).^2)),...
    @(x)(2*exp(-(cfast*x).^2))};
  ord3 = length(fcell3);
  x3 = repmat(X(:,3),[1,ord3]);
  phi{3} = zeros(N,ord3);
  for i = 1:ord3
    phi{3}(:,i) = fcell3{i}(x3(:,i));  
  end
  
  ord = [ord1, ord2, ord3]; % order of the basis in each dimension

%% Generate the data using the phi matrices

A = rand_cell(ndim,ord,rA,'n'); % cell of random coefficient matrices

% generate values of the seprep with phi basis and random coeff
y = ones(N,rA);
for d = 1:ndim
    y = y .* (phi{d} * A{d});
end 
y = sum(y,2);

save example_mixed_basis.mat y X phi ord
