function hMatrix = initPLF(PSFpath, pythonExecutablePath)

% Works with matlab 2020a
pythonEnvironment = pyenv;
if pythonEnvironment.Executable ~= pythonExecutablePath
    pyenv('Version', pythonExecutablePath);
end

% For Matlab 2019a, we may need to use the following
% (and I didn't get that to work with python 3.7 even though it is
%  supposed to be compatible. Most things worked, but not lists and tuples)
%pyversion '/usr/bin/python'

% Insert path to python source code
% TODO: I need to install my python code as a proper module
pyCodePath = '/Users/jonny/Development/light-field-flow';
if count(py.sys.path, pyCodePath) == 0
    insert(py.sys.path, int32(0), pyCodePath);
end

% Create a matrix object, and return it
%matPath = '/Users/jonny/Development/light-field-flow/PSFmatrix/fdnormPSFmatrix_M22.222NA0.5MLPitch125fml3125from-10to10zspacing5Nnum19lambda520n1.33.mat'
hMatrix  = py.psfmatrix.LoadMatrix(PSFpath);
