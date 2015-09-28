function f = poly_eval_1d(c,x)

  x = reshape(x,[length(x),1]);  % make col vector
  c = reshape(c,[length(c),1]);  % make col vector
  deg = length(c)-1;

  V = repmat(x,[1,deg+1]);
  p = repmat(0:deg,[length(x),1]);
  V = V.^p;
  
  f = V * c;
   
end