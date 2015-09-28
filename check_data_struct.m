function flag = check_data_struct(f)
% Check that f is set up correctly.  Returns 1 if OK, 0 otherwise.

  nfail = 0;  % number of failed checks
  fprintf('check_data_struct.m: running checks ...')

  % Check essential fields first
  if ~isfield(f,'ndim')
    fprintf('\n"ndim" field missing\n'); nfail=nfail+1;
  end
  if ~isfield(f,'ord')
    fprintf('"\nord" field missing\n'); nfail=nfail+1;
  end
  if ~isfield(f,'X')
    fprintf('\n"X" field missing\n'); nfail=nfail+1;
  end
  if ~isfield(f,'y')
    fprintf('\n"y" field missing\n'); nfail=nfail+1;
  end
  if ~isfield(f,'cv')
    fprintf('\n"cv" field missing\n'); nfail=nfail+1;
  end
  if ~isfield(f,'Phi')
    fprintf('\n"Phi" field missing\n'); nfail=nfail+1;
  end    
  
  % if the above tests failed, you are likely to have more problems. Exit.
  if nfail>0
    fprintf('Failed %d checks.  Correct these and try again!\n', nfail)
    flag = 0; return;
  end
  
  % these are required sub-fields of X and y
  if ~isfield(f.X,'train')
    fprintf('\n"X.train" field missing\n');  nfail=nfail+1;
  end
  if ~isfield(f.y,'train')
    fprintf('\n"y.train" field missing\n');  nfail=nfail+1;
  end
  
  % fields required for CV
  if f.cv
    if ~isfield(f.X,'test')
      fprintf('\n"f.X.test" field missing (needed for CV)\n'); 
      nfail=nfail+1;
    end
    if ~isfield(f.y,'test')
      fprintf('\n"f.y.test" field missing (needed for CV)\n'); 
      nfail=nfail+1;
    end
  end
  if ~isfield(f.Phi,'train')
    fprintf('\nNeed to supply f.Phi.train matrix!\n'); nfail=nfail+1;
  end
  if f.cv
    if ~isfield(f.Phi,'test')
      fprintf('\nNeed to supply f.Phi.test matrices for CV\n'); nfail=nfail+1;
    end
  end
  
  % Check that the phi matrices have the correct dimensions
  for d = 1:f.ndim
    if (size(f.Phi.train{d},1) ~= size(f.X.train,1)) || ...
        (size(f.Phi.train{d},2) ~= f.ord(d))
      fprintf('\nProblem with dimension of Phi.train matrix %d\n', d); 
      nfail=nfail+1;
    end
    if f.cv
      if (size(f.Phi.test{d},1) ~= size(f.X.test,1)) || ...
          (size(f.Phi.test{d},2) ~= f.ord(d))
        fprintf('\nProblem with dimension of Phi.test matrix %d\n', d); 
        nfail=nfail+1;
      end
    end
  end
  
  if nfail>0
    fprintf('Failed %d checks.  Correct these and try again!\n', nfail)
    flag = 0; return;
  end
  
  % if you got here, everything looks OK   
  flag = 1;  fprintf('seems OK!\n')  
    
end