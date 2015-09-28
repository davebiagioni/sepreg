clear all; close all; clc;

N = [8,16,32];

pts = [];

for i = 1:length(N)
  pts = [pts; box_surface(N(i))];
end
  
save pts.mat pts