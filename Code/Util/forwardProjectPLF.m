function TOTALprojection = forwardProjectPLF(H, realspace, dummy)

% Create a projector
projector = py.projector.Projector_allC();

t0 = tic;
planes = string(missing); % Represents Python's None
TOTALprojection = py.matlab_wrapper.ForwardProjectPLF(projector, H, realspace(:)', size(realspace), planes, 1, py.py_light_field.GetNumThreadsToUse());
%disp(['  Forward PLF took ' num2str(toc(t0))]);
t0 = tic;
TOTALprojection = single(TOTALprojection);
%disp(['Array conversion took ' num2str(toc(t0)) '. Matlab matrix shape is now ' num2str(size(TOTALprojection))])

end
