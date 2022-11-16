function Backprojection = backwardProjectPLF(H, projection, dummy)

% Create a projector
projector = py.projector.Projector_allC();

t0 = tic;
planes = string(missing); % Represents Python's None
Backprojection = py.matlab_wrapper.BackwardProjectPLF(projector, H, projection(:)', size(projection), planes, 1, py.py_light_field.GetNumThreadsToUse());
%disp(['  Backward PLF took ' num2str(toc(t0))]);
t0 = tic;
Backprojection = single(Backprojection);
%disp(['Array conversion took ' num2str(toc(t0)) '. Matlab matrix shape is now ' num2str(size(Backprojection))])
                                                      
end
