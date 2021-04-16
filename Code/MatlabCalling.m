if 1
    % Reload to pick up code changes
    clear classes
    m = py.importlib.import_module('matlab_wrapper');
    py.importlib.reload(m);
    m = py.importlib.import_module('projector');
    py.importlib.reload(m);
    % Reloading this custom module of mine doesnt actually work. I'm not sure why.
    % If I change this, I need to quit Matlab entirely and relaunch.
    m = py.importlib.import_module('py_light_field');
    py.importlib.reload(m);
end
