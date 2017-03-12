function f=seprep_sort(f)
% sort the terms of the sep rep w.r.t. to the svals of the traning data.

  fprintf('This function has not yet been fully tested ... use with care!\n')

  [f.seprep.train.svals,ix] = sort(abs(f.seprep.train.svals),'descend');
  
  for d = 1:f.ndim
    f.seprep.factors{d} = f.seprep.factors{d}(:,ix);
    f.seprep.svals = f.seprep.svals(ix);
    f.seprep.train.factors{d} = f.seprep.train.factors{d}(:,ix);
    if f.cv
      f.seprep.test.factors{d} = f.seprep.test.factors{d}(:,ix);
      f.seprep.test.svals = f.seprep.test.svals(ix);
    end
  end

end