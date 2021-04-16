function TOTALprojection = forwardProjectPLF(H, realspace, dummy)

% Create a projector
projector = py.projector.Projector_allC();
%projector = py.projector.Projector_python();

planes = string(missing);
% TODO: determine number of threads to use
TOTALprojection = py.matlab_wrapper.ForwardProjectPLF(projector, H, realspace(:)', size(realspace), planes, 1, 4);
                                                      
% Code from stackoverflow to convert ndarray to Python
% TODO: should profile this, but hopefully it is fairly efficient!
shape = cellfun(@int64,cell(TOTALprojection.shape));
ls = py.array.array('d', TOTALprojection.flatten('C').tolist());
p = single(ls);
TOTALprojection = reshape(p,flip(shape));

end
