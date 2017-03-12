function y = poly_eval_dd(factors,svals,X)

  [N,D] = size(X);
  rnk = length(svals);
  
  y = ones(N,rnk);
  for r = 1:rnk
    for d = 1:D
      y(:,r) = y(:,r) .* poly_eval_1d(factors{d}(:,r),X(:,d));
    end
  end
  y = y * svals;

end