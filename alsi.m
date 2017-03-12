function [f,y,err,flag] = alsi(f,tol,stucktol,maxit,vrb)
% See als.m for doc

  % PRELIMINARIES
  
  flag = 0;
  
  % internal parameter... should I form normal equations explicitly?
  % I think no, for several reasons
  form_normal_equations = 0;

  rnk = length(f.seprep.svals);   % convenience variables
  Ntrain = size(f.X.train,1);
  M = f.ord;
  
  ynorm.train = norm(f.y.train);  % for computing rel. err.
  if f.cv;  ynorm.test = norm(f.y.test); end % for computing rel. cv err  
  dims = 1:f.ndim;      % can change the sweep order here
  
  % convert coefficients to values of function at given nodes
  f = coef2val(f); 
  
  err.train = zeros(maxit,1);   % training error
  derr.train = zeros(maxit,1);  % change in error, to monitor if stuck
  if f.cv
    err.test = zeros(maxit,1);  % cv error    
    derr.test = zeros(maxit,1); % change in cv error
  end

  % MAIN ALS ITERATION
  for iter = 1:maxit
    
    for d = dims
      
      % compute the matrix p_j^l
      P = als_collapse(f.seprep.train,d);    %%%% problem?
      
      % set up the linear system 
      if form_normal_equations == 1  % form normal equations (square system) explicitly (bad idea)
        
        A = zeros(M(d)*rnk,M(d)*rnk);
        b = zeros(M(d)*rnk,1);

        for i = 1:rnk
         ii = ((i-1)*M(d)+1):(i*M(d));  % row block indices
         PPi = (repmat(P(:,i),[1,M(d)]) .* f.Phi.train{d})';  
         b(ii) = PPi * f.y.train;
         for j = 1:rnk
           jj = ((j-1)*M(d)+1):(j*M(d));  % col block indices
           A(ii,jj) = PPi * (repmat(P(:,j),[1,M(d)]) .* f.Phi.train{d});
         end
        end
      
      else % form rectangular system (no A* stuff)
        
        A = zeros(Ntrain*rnk,M(d)*rnk);
        b = zeros(Ntrain*rnk,1);

        for i = 1:rnk
           ii = ((i-1)*Ntrain+1):(i*Ntrain);  % row block indices
           b(ii) = f.y.train;  % can just do this once in outer iteration...?
           for j = 1:rnk
             jj = ((j-1)*M(d)+1):(j*M(d));  % col block indices
             A(ii,jj) =  (repmat(P(:,j),[1,M(d)]) .* f.Phi.train{d});
           end
        end 
        
      end
      
      % regularize
      A = A + 1e-12 * eye(size(A));
      
      %fprintf('cond(A) = %e\n', cond(A))
      c = lsolve(A,b);    % internal function (below); we might want to do this in different ways
      c = reshape(c,[M(d),rnk]);
      
      % update solution
      f.seprep.train.factors{d} = f.Phi.train{d} * c;
      f.seprep.factors{d} = c;
      
      % normalize
      svals = sqrt(sum(f.seprep.train.factors{d}.^2,1))';
      f.seprep.train.factors{d} = f.seprep.train.factors{d} * spdiags(1./svals,0,rnk,rnk);
      f.seprep.train.svals = f.seprep.train.svals .* svals;
      f.seprep.factors{d} = f.seprep.factors{d} * spdiags(1./svals,0,rnk,rnk);
      f.seprep.svals = f.seprep.svals .* svals;
      
    end
    
    % compute error
    y = seprep_eval(f);
    err.train(iter) = norm(y.train - f.y.train) / ynorm.train;
    if f.cv; err.test(iter) = norm(y.test - f.y.test) / ynorm.test; end
    
    % compute change in error for iteration 2 and beyond
    if iter > 1
      derr.train(iter) = abs(err.train(iter-1)-err.train(iter));
      if f.cv; derr.test(iter) = abs(err.test(iter-1)-err.test(iter)); end
    end
    
    % print statuts 
    if vrb
      if ~f.cv
        fprintf('alsi: rank = %d, iter = %d, err.train = %e, derr = %e\n',rnk,...
           iter,err.train(iter), derr.train(iter))
      else
        fprintf('alsi: rank = %d, iter = %d, err.test = %e, err.train = %e, derr.test = %e\n',...
          rnk,iter,err.test(iter),err.train(iter),derr.test(iter))
      end
    end
    
    % are you stuck?
    if ~f.cv
      %if iter>3 && (derr.train(iter))>0
      %  if vrb;  fprintf('ALS iteration error increasing!\n'); end
      %  err.train = err.train(1:iter);
      %  flag = 1;
      %  return
      %end
      if iter>1 && (derr.train(iter)<stucktol)
        if vrb;  fprintf('ALS iteration stuck at rank %d!\n',rnk); end
        err.train = err.train(1:iter);
        return
      end
    else
      %if iter>3 && (derr.test(iter) > 0)
      %  if vrb; fprintf('ALS iteration error increasing!\n'); end
      %  err.train = err.train(1:iter);
      %  err.test = err.test(1:iter);
      %  flag = 1;
      %  return
      %end
      if iter>3 && derr.test(iter)<stucktol
        if vrb;  fprintf('ALS iteration stuck at rank %d!\n',rnk); end
        err.train = err.train(1:iter);
        err.test = err.test(1:iter);
        return
      end
    end
      
    
    % did you converge?
    if ~f.cv
      if err.train(iter) < tol
        err.train = err.train(1:iter);
        return
      end
    else
      if err.test(iter) < tol
        err.train = err.train(1:iter);
        err.test = err.test(1:iter);
        return
      end      
    end
    
  end

  if vrb; fprintf('ALS reached max iterations for rank = %d!\n',rnk); end

end

function P = als_collapse(A,k)
% Given values of the seprep evaluated on the given nodes, collapse all
% but direction k.  This returns the matrix N-by-rnk matrix p_j^l.

  rnk = length(A.svals);
  dims = 1:length(A.factors);
  dims(k) = [];
  
  P = ones(size(A.factors{1}));
  for i = dims
    P = P .* A.factors{i};
  end
  P = P * spdiags(A.svals,0,rnk,rnk);

end

function c = lsolve(A,b)
  %c = pinv(A,1e-4) * b;        % option 1: built-in pseudo-inverse
  %[u,s,v] = svd(A);            % option 2: pseudo-inverse via SVD
  %ix = find((diag(s)/s(1,1))>1e-4);
  %c = v(:,ix) * diag(1./diag(s(ix,ix))) * u(:,ix)' * b;
  c = A\b;                      % option 3: backslash
end
