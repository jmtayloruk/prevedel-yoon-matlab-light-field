# prevedel-yoon-matlab-light-field

This repository is primarily a clone of the Matlab code from "Simultaneous whole-animal 3D-imaging of neuronal activity using light field microscopy",
R. Prevedel, Y.-G. Yoon *et al.*, Nature Methods **11** 727–730 (2014). Reposted here with permission from Young-Gyu Yoon.

This repository incorporates a couple of small bug fixes I have made to the original code (including one affecting PSF generation (see file calcPSF.m). 
However, its main purpose is to demonstrate how my fast light field projection code can be called seamlessly from existing Matlab codebases,
accelerating this too.

To benefit from my fast light field projection code, download and install my code from [https://github.com/jmtayloruk/fast-light-field](https://github.com/jmtayloruk/fast-light-field).
Follow the installation instructions for that repository, and then edit `Reconstruction3D_GUI.m` (look for comment `JT: EDIT ME` around line 850)
to provide the appropriate path to my fast-light-field Python source code directory.

When you run `Reconstruction3D_GUI.m`, my fast algorithm will be selected and used by default.
