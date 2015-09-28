function A = rand_cell(ndim,ord,rnk,type,shift,scale)
% Generates a cell of random coefficient matrices. If shift and scale
% inputs are not specified, they are set to 0 and 1, respectively.
%
% Input:
%  ndim = number of dimensions (matrices)
%  ord = vector of order (cardinality) of basis functions in each direction
%  rnk = separation rank of the corresponding sep rep
%  type = 'n' for gaussian, 'u' for uniform.
%  shift = optional vector or scalar of shift parameters for the 1d distributions
%  scale = optionsl vector or scalar of scale parameters for the 1d distributions
% 
% Output:
%  A = an ndim-cell.  A{d} contains an ord(d)-by-rnk matrix of
%  random numbers x_ij of distribution 'type', such that
%    A{d}(i,j) = scale(d) * ( x_ij - shift(d) );

  A = cell(1,ndim);
  
  if nargin<6
    scale = ones(1,ndim);
  end
  if nargin<5
    shift = zeros(1,ndim);
  end
  
  if length(shift)==1
    shift = shift * ones(1,ndim);
  end
  if length(scale)==1
    scale = scale * ones(1,ndim);
  end
  
  if isequal(type,'n')
    for d = 1:ndim
      A{d} = scale(d)*(randn(ord(d),rnk)-shift(d));
    end
  end
  
  if isequal(type,'u')
    for d = 1:ndim
      A{d} = scale(d)*(rand(ord(d),rnk)-shift(d));
    end
  end
    
end