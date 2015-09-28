function f=seprep_normalize(f)
% Normalize the separated representation w.r.t. the training data. 

  fprintf('This function has not yet been fully tested ... use with care!\n')

  if ~isfield(f,'seprep')
    fprintf('"seprep" field is missing, nothing to normalize!\n')
    return
  end
  
  if ~isfield(f.seprep,'train')
    f = coef2val(f);
  end
  
  rnk = length(f.seprep.svals);
  
  for d = 1:f.ndim
    svals = sqrt(sum(f.seprep.train.factors{d}.^2,1))';
    f.seprep.train.factors{d} = f.seprep.train.factors{d} * spdiags(1./svals,0,rnk,rnk);
    f.seprep.train.svals = f.seprep.train.svals .* svals;
  end

end