% This function is written by Jonathan Taylor to set up Python support
% within matlab to enable calling my fast-light-field code.
%
% Function parameters:
%  pythonExecutablePath: optional path to the actual python binary itself.
%                        currently not necessary to specify this, but it
%                        could be useful if you need to run a specific 
%                        version of Python for some reason
%  pythonCodePath:       path to my py-light-field code directory

function hMatrix = initFLF(pythonExecutablePath, pythonCodePath)

if ~strcmp(pythonExecutablePath, '')
    % Caller has specified a python executable path to use
    
    % Note that I haven't found a good way of programatically identifying
    % the correct anaconda python path on OS X from within Matlab.
    % If I call system("which python") then I get the wrong one.
    % It looks like the necessary environment is not being set up to enable 
    % Anaconda to insert itself, or something. The only alternative is to
    % hard-code the path in Matlab code.
    % Fortunately, though, it doesn't seem to be necessary to call this at
    % all, as Matlab appears to default to the correct one.

    if verLessThan('matlab','9.7')
        % For Matlab 2019a, we need to use the following.
        % (Note that I haven't got lists and tuples to work with python 3.7
        %  and Matlab 2019a - but I don't need them for this code)
        [version, executable, isloaded] = pyversion;
        if ~strcmp(executable, pythonExecutablePath)
            pyversion pythonExecutablePath;
        end
    else
        % Different code for matlab 2020a and later
        % Note that some versions/installs of Matlab really do not like
        % the python environment changing mid-run.
        % If you get an error "The environment cannot be changed in this MATLAB session",
        % you will need to comment out the next four lines entirely,
        % and make a manual call to pyenv('Version', xxx) when you first open Matlab.
        pythonEnvironment = pyenv;
        if ~strcmp(pythonEnvironment.Executable, pythonExecutablePath)
            pyenv('Version', pythonExecutablePath);
        end
    end
end

% These are not necessary, but serve as good debug checks.
% If import fails here we will get a helpful error message
% that hopefully indicates what the problem is.
% If we just try and call a python function later,
% we will not get an informative message in case of any problems
py.importlib.import_module('numpy');
py.importlib.import_module('h5py');

% Insert path to my Python source code
if count(py.sys.path, pythonCodePath) == 0
    insert(py.sys.path, int32(0), pythonCodePath);
end

% Similarly here, this catches any problems importing my python code.
% If this fails, it might mean the path (above) has not been set correctly.
py.importlib.import_module('psfmatrix');
