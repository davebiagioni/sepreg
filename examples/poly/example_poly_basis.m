% This script sets up an example for ALS the uses a polynomial basis in
% each direction.
%
% The X-data is uniformly spaced on the interval [-1,1] in each direction.
%
% The polynomials used to generate the y-data have i.i.d. random 
% coeffients ~ N(0,1).  
%
% The script saves:
%
%  X = N-by-ndim matrix of x values.
%  y = N-vector of response values
%  deg = vector of degrees of the polynomial basis in each direction

clear all; close all; clc;

% problem parameters
deg = [1,2,3,4,5];    % degree of poly's in each dimension
ord = deg+1;          % order of basis in each dimension
ndim = length(deg);   % number of dimensions
N = 100;              % number of samples
rA = 5;               % rank of generating function

% independent variables
X = linspace(-1,1,N)';
X = repmat(X,[1,ndim]);

% generating function
factors = rand_cell(ndim,ord,rA,'n');
svals = ones(rA,1);

% values of generating function at the X nodes
y = poly_eval_dd(factors,svals,X);   

save example_poly_basis.mat y X deg