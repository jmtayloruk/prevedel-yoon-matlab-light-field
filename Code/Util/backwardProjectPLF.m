function Backprojection = backwardProjectPLF(H, projection, dummy)

% Create a projector
projector = py.projector.Projector_allC();
%projector = py.projector.Projector_python();

planes = string(missing);
% TODO: determine number of threads to use
Backprojection = py.matlab_wrapper.BackwardProjectPLF(projector, H, projection(:)', size(projection), planes, 1, 4);
      
% Code from stackoverflow to convert ndarray to Python
% TODO: should profile this, but hopefully it is fairly efficient!
shape = cellfun(@int64,cell(Backprojection.shape));
ls = py.array.array('d', Backprojection.flatten('C').tolist());
p = single(ls);
Backprojection = reshape(p,flip(shape));

end
