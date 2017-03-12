function pts = box_surface(N)

  pts = [];

  % fix z=1 and z=N
  [xtmp,ytmp] = meshgrid(1:N,1:N);
  ztmp = ones(size(xtmp));
  pts = [pts; [xtmp(:), ytmp(:), ztmp(:)]];
  pts = [pts; [xtmp(:), ytmp(:), N*ztmp(:)]];
  
  % fix x=1 and x=N
  [ytmp,ztmp] = meshgrid(1:N,2:(N-1));
  xtmp = ones(size(ytmp));
  pts = [pts; [xtmp(:), ytmp(:), ztmp(:)]];
  pts = [pts; [N*xtmp(:), ytmp(:), ztmp(:)]];
  
  % fix y=1 and y=N
  [xtmp,ztmp] = meshgrid(2:(N-1),2:(N-1));
  ytmp = ones(size(xtmp));
  pts = [pts; [xtmp(:), ytmp(:), ztmp(:)]];
  pts = [pts; [xtmp(:), N*ytmp(:), ztmp(:)]];

end