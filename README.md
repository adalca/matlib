matlib
======================
A Matlab general library. Here's a sampling of tools split across several folders/categories:

### general 
tools useful in **general** matlab code (or if they didn't fit elsewhere)  
Examples: `sys.whos` for a more powerful version of `whos`, `bw2sdtrf` to compute a signed distance transform from a bw image, `dice` to compute a Dice measure between images, `cellfunc` to return a cell when doing `cellfun` behavior, `meanShift` for (single mode) mean shift estimate, and many more  

### visual
tools for **image and video** code  
Examples: `frames2vid` to write a video file from frames, `volresize` to resize a n-d volume, `volblur` to blur a n-d volume with separable filters, `volwarp` warp a n-dim volume via displacement fields, and many more  

### medimg
tools for **medical imaging** processing code  
Examples: `loadNii` to load nifti files robustly, `toIsotropic` transform original resolution volume to isotropic volume, and many more  

### genetics
tools for **geneticts and epigenetics** code  
Examples: `manhattanSNP` for manhatten plots of SNPs, or `simulation` folder for simulation of imaging genetics datasets, and many more  



License:
--------
MIT License
