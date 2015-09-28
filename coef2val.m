function f = coef2val(f)
% "Coefficient to values". Replace linear coefficients with function values.  
% Uses the phi (basis) matrices to avoid having to specify functions.
%
% Required fields:
%   seprep = separated representation in coefficient format (ktensor)
%
% Adds seprep.train and seprep.test fields (f.cv = 1).

  rnk = length(f.seprep.svals);  % for convenience
  Ntrain = size(f.X.train,1);
  D = f.ndim;
  
  f.seprep.train.factors = cell(1,D);
  for d = 1:D
    f.seprep.train.factors{d} = zeros(Ntrain,rnk);
    for r = 1:rnk
      f.seprep.train.factors{d}(:,r) = f.Phi.train{d} * f.seprep.factors{d}(:,r);
    end
  end
  f.seprep.train.svals = f.seprep.svals;
  
  if f.cv
    Ntest = size(f.X.test,1);
    f.seprep.test.factors = cell(1,D);
    for d = 1:D
      f.seprep.test.factors{d} = zeros(Ntest,rnk);
      for r = 1:rnk
        f.seprep.test.factors{d}(:,r) = f.Phi.test{d} * f.seprep.factors{d}(:,r);
      end
    end
    f.seprep.test.svals = f.seprep.svals;
  end
  
end