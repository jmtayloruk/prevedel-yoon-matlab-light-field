# prevedel-yoon-matlab-light-field

This repository is primarily a clone of the Matlab code from "Simultaneous whole-animal 3D-imaging of neuronal activity using light field microscopy",
R. Prevedel, Y.-G. Yoon *et al.*, Nature Methods **11** 727–730 (2014). Reposted here with permission from Young-Gyu Yoon.

This repository incorporates a couple of small bug fixes I have made to the original code (including one affecting PSF generation (see file calcPSF.m). 
However, its main purpose is to demonstrate how my fast light field projection code can be called seamlessly from existing Matlab codebases,
accelerating this too.

To benefit from my fast light field projection code, download and install my code from [https://github.com/jmtayloruk/fast-light-field](https://github.com/jmtayloruk/fast-light-field).
Follow the installation instructions for that repository, and then edit `Reconstruction3D_GUI.m` or `Reconstruction3D_headless.m` (look for comment `JT: EDIT ME` around line 850)
to provide the appropriate path to my fast-light-field Python source code directory.

When you run `Reconstruction3D_GUI.m` or `Reconstruction3D_headless.m`, my fast algorithm should be selected and used by default.
Note that the first time you call this function, the first projection operation will take a long time (potentially several minutes) as it calibrates itself for best performance.
Subsequent projection operations (and subsequent calls to this function) will be way faster.

If you encounter issues relating to Python calls, look for comments nearby in the Matlab code,
as I have put in some comments explaining why an error might occur at that point. 
Note that if Matlab says it is "unable to resolve" a python symbol from Matlab,
this may mean the module couldn’t be imported for some reason. 
If so, use py.importlib.import_module to find out what the underlying error is)
