function [psf, LFpsf] = calcPSF(p1, p2, p3, fobj, NA, x1space, x2space, scale, lambda, MLARRAY, fml, M, n, centerArea)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
k = 2*pi*n/lambda;
alpha = asin(NA/n);
x1length = length(x1space);
x2length = length(x2space);
zeroline = zeros(1, length(x2space) );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
pattern = zeros(x1length, x2length);
centerPT = ceil(length(x1space)/2);
parfor a=centerArea(1):centerPT,
    patternLine = zeroline;
    for b=a:centerPT, 
        x1 = x1space(a);
        x2 = x2space(b);          
        xL2normsq = (((x1+M*p1)^2+(x2+M*p2)^2)^0.5)/M;        
       
        v = k*xL2normsq*sin(alpha);    
        u = 4*k*(p3*1)*(sin(alpha/2)^2);
        Koi = M/((fobj*lambda)^2)*exp(-i*u/(4*(sin(alpha/2)^2)));
        intgrand = @(theta) (sqrt(cos(theta))) .* (1+cos(theta))  .*  (exp(-(i*u/2)* (sin(theta/2).^2) / (sin(alpha/2)^2)))  .*  (besselj(0, sin(theta)/sin(alpha)*v))  .*  (sin(theta));
        I0 = integral(@(theta)intgrand (theta),0,alpha);  
                
        patternLine(1,b) =  Koi*I0;
    end
    pattern(a,:) = patternLine;    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
patternA = pattern( (1:centerPT), (1:centerPT) );
patternAt = fliplr(patternA);

pattern3D = zeros(size(pattern,1), size(pattern,2), 4);
pattern3D(:,:,1) = pattern;
pattern3D( (1:centerPT), (centerPT:end),1 ) = patternAt;
pattern3D(:,:,2) = rot90( pattern3D(:,:,1) , -1);
pattern3D(:,:,3) = rot90( pattern3D(:,:,1) , -2);
pattern3D(:,:,4) = rot90( pattern3D(:,:,1) , -3);
% JT: bug fix: this use of 'max' below is rather esoteric and dangerous.
% It relies on the documented behaviour that 'max' acting on complex
% numbers will take the element with the maximum *absolute* value.
% HOWEVER, Matlab aggressively down-converts complex numbers to real
% numbers if their imaginary part is identically zero. This is the case at
% z=0, at which point 'max' does not behave in the way the original
% programmer of this code intended.
% The fix is to explicitly cast pattern3D at this point. It must be done
% right here - if it is done any earlier, Matlab will quietly convert it 
% back to real!
%Original code: pattern = max(pattern3D,[],3);
pattern = max(complex(pattern3D),[],3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%% CALCULATED  LF PSF %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
[f1,dx1,x1]=fresnel2D(pattern.*MLARRAY,scale,1*fml,lambda);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
psf = pattern;
LFpsf = f1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%