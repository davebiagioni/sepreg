% This script demonstrates the use of ALS with or without CV.

clear all; close all; clc;

% choose whether to use cv setup or no by commenting out one of these lines
%setup_cv_no;
setup_cv_yes;

% Parameters for ALS
tol = 1e-3;           % error tolerance
stucktol = 1e-5;      % stuck tolerance (absolute)
maxit = 25;           % iterations per rank
r0 = 1;               % initial sep rank
rmax = 4;             % max sep rank
vrb = 1;              % verbose flag

% run ALS
[f,yhat,err] = als(f,tol,stucktol,maxit,r0,rmax,vrb);