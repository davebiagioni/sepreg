function y = generate_legendre_values(n,x,nrm)
% Generate values of orthogonal legendre polynomials P_j(x) for j = 0,...,n
% at the values given in x.  If the "nrm" option is true, then the
% polynomials are l2-normalized on [-1,1].
%
% Input:
%   n = integer greater than or equal to 0
%   x = points at which to evaluate the legendre polynomials
%   nrm = optional argument to normalize.  Default is 1.
%
% Ouput:
%   y = length(x)-by-(n+1) array of legendre values.  Each row corresponds
%       to an x-value, each column to a degree increasing from 0 to n

  if nargin < 3    % normalize by default
    nrm = 1;
  end

  y = zeros(length(x),n+1);   % initialize solution
  
  y(:,1) = 1;     % first term in recurrence relation
  if n==0         % if only want constant term, then exit here
    return
  end
  
  y(:,2) = x(:);  % linear term in recurrence relation
  
  for i = 2:n     % remaining terms.  This loop exits without doing anything if n<2
    y(:,i+1) = ( (2*i - 1) * x(:) .* y(:,i) - (i-1) * y(:,i-1) ) / i;
  end

  if nrm          % optionally normalize
    for i = 0:n
      y(:,i+1) = sqrt( (2*i+1) / 2) * y(:,i+1);
    end
  end
  
end