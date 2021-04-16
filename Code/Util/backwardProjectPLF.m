function Backprojection = backwardProjectPLF(H, projection, dummy)

% Create a projector
projector = py.projector.Projector_allC();

planes = string(missing);
Backprojection = py.matlab_wrapper.BackwardProjectPLF(projector, H, projection(:)', size(projection), planes, 1, py.py_light_field.GetNumThreadsToUse());
      
% Code from stackoverflow to convert ndarray to Python
% Note that the full overhead of the Matlab code in the present function
% is about 10% of the time spent in the calling Matlab code,
% so I'm happy that these conversions here are efficient enough.
shape = cellfun(@int64,cell(Backprojection.shape));
ls = py.array.array('d', Backprojection.flatten('C').tolist());
p = single(ls);
Backprojection = reshape(p,flip(shape));

end
