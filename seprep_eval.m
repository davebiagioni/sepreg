function y = seprep_eval(f)
% Evaluate the separated representation on its node points. Uses the phi 
% (basis) matrices to avoid having to specify functions.
%
% Required fields:
%   seprep = separated representation in coefficient format (ktensor)
%
% Output:
%   y = f.seprep(X)

  if ~isfield(f,'seprep')
    fprintf('seprep_eval.m: structure does not have "seprep" field!\n')
    return
  end
  
  [Ntrain,D] = size(f.X.train);
  rnk = length(f.seprep.svals);
  
  y.train = ones(Ntrain,rnk);
  for d = 1:D
      y.train = y.train .* (f.Phi.train{d} * f.seprep.factors{d});
  end
  y.train = y.train * f.seprep.svals;
  
  if f.cv
    Ntest = size(f.X.test,1);
    y.test = ones(Ntest,rnk);
    for d = 1:D
      y.test = y.test .* (f.Phi.test{d} * f.seprep.factors{d});
    end
    y.test = y.test * f.seprep.svals;
  end

end