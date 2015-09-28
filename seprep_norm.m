function nrm = seprep_norm(f)
% Returns the norm of the seprep w.r.t. training data (test data is
% ignored).
% If no values of the sep rep at the training data do not exist, then the
% function coef2val is called to produce it.

  fprintf('This function has not yet been fully tested ... use with care!\n')

  if ~isfield(f,'seprep')
    fprintf('no field "seprep"!\n')
    nrm = 0; return
  end
  
  if ~isfield(f.seprep,'train')
    f = coef2val(f);
  end
  
  rnk = length(f.seprep.train.svals);
  
  nrm = ones(rnk,rnk);
  for d = 1:f.ndim
    nrm = nrm .* (f.seprep.train.factors{d}' * f.seprep.train.factors{d});
  end
  nrm = nrm .* (f.seprep.svals * f.seprep.svals');
  nrm = sqrt(abs(sum(nrm(:))));

end