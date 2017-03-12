In these directories are some examples of how to use ALS-based regression for scattered data.  

The scripts "example*.m" generate example data, which are saved as .mat files of the same name.

The scripts "setup*.m" loads the data and form the data structure, for use with ALS (both with and without cross validation). These scripts provide important examples illustrating the use of the data structure.  They also demonstrate one way (there are many) to form the Phi matrices needed by ALS, without having to explicitly represent the basis functions (as functions).

The script "example_driver.m" allows you to choose the setup (CV or no CV?), and run ALS on the data.  This script plots several quantities of interest.
