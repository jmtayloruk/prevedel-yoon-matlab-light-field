function Xguess_out  = contrastAdjust(Xguess_in, Contrast)

XguessMax = max(Xguess_in(:));
Xguess = Xguess_in/XguessMax;
Xguess = Contrast*(2*Xguess - 1)+1;
Xguess_out = 0.5*XguessMax*Xguess;