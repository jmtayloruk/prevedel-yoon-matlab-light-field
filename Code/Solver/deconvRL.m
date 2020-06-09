function [Xguess] = deconvRL(forwardFUN, backwardFUN, Htf, maxIter, Xguess )

for i=1:maxIter,
    t0=tic;
    HXguess = forwardFUN(Xguess);
    HXguessBack = backwardFUN(HXguess);
    errorBack = Htf./HXguessBack;
    Xguess = Xguess.*errorBack; 
    Xguess(find(isnan(Xguess))) = 0;
    ttime = toc(t0);
    disp(['  iter ' num2str(i) ' | ' num2str(maxIter) ', took ' num2str(ttime) ' secs']);
end
    


        