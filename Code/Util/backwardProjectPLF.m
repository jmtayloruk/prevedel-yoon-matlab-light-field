% This function is written by Jonathan Taylor to provide Python support
% within matlab to call my fast-light-field code.

function Backprojection = backwardProjectPLF(H, projection, gpu)

% Create a projector
if gpu,
    py.matlab_wrapper.ErrorIfGPUUnavailable();
    projector = py.projector.Projector_gpuHelpers();
else
    projector = py.projector.Projector_allC();
end

t0 = tic;
planes = string(missing); % Represents Python's None
Backprojection = py.matlab_wrapper.BackwardProjectPLF(projector, H, projection(:)', size(projection), planes, 1, py.py_light_field.GetNumThreadsToUse());
%disp(['  Backward PLF took ' num2str(toc(t0))]);
t0 = tic;
Backprojection = single(Backprojection);
%disp(['Array conversion took ' num2str(toc(t0)) '. Matlab matrix shape is now ' num2str(size(Backprojection))])
                                                      
end
