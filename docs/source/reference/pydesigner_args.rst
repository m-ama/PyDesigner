List of Flags
=============

PyDesigner is extremely flexible when it comes to dMRI processing.
Users can easily enable or disable various preprocessing steps without
changing the overall sequence.

The list below covers all these flags.

IO Control
---------------

These flags allow control of the pipeline's I/O handling

-o DIR, --output DIR    PyDesigner output directory


Preprocessing Control
---------------------

Preprocessing contol flags allow users to tweak certain parts of the
preprocessing pipeline, to accomodate all types of datasets.


-s, --standard  Runs the recommended preprocessing pipeline in order: denoise, degibbs, undistort, brain mask, smooth, rician

--denoise       Denoises input DWI

--extent        Shape of denoising extent matrix, defaults to 5,5,5

--reslice       Reslices input DWI and outputs to a specific resolution in mm or output dimensions

--interp        The interpolation method to use when resizing

--degibbs       Corrects Gibb’s ringing

--undistort     Undistorts image using a suite of EPI distortion correction, eddy current correction, and co-registration. Does not run EPI correction if reverse phase encoding DWI is absent.

--rpe_pairs N   Speeds up topup if a reverse PE is present; specify the number (integer) of reverse PE direction B0 pairs to use

--mask          Computes a brain mask at 0.20 threshold by default

--maskthr       Specify FSL bet fractional intensity threshold for brain masking, defaults to 0.20

--user_mask     Provide path to user-generated brain mask in NifTi (.nii) format

--smooth        Smooths DWI data at a default FWHM of 1.25

--fwhm          Specify the FWHM at which to smooth, defaults to 1.25

--rician        Corrects Rician bias

Diffusion Tensor Control
------------------------

Users may also tweak computations in estimating DTI or DKI parameters
with the following flags.

--nofit             Performs preprocessing only, disables DTI/DKI parameter extraction

--noakc             Disables brute forced kurtosis tensor outlier rejection

--nooutliers        Disables IRLLS outlier detection

-w, --wmti          Enables IRLLS outlier detection, disable by default because calculations are experimental

--fit_constraints   Specify fitting constraints to use, defaults to 0,1,0

--noqc              Disables saving of quality control (QC) metrics

--median            Performs post processing median filter of final DTI/DKI maps. **WARNING: Use on a case-by-case basis for bad data only. When applied, the filter alters the values of most voxels, so it should be used with caution and avoided when data quality is otherwise adequate. While maps appear visually soother with this flag on, they may nonetheless be less accurate**

Pipeline Control
----------------

These are more general pipeline flags that interface directly with the
user or machine.

--nthreads N    Specify number of CPU workers to use in processing, defaults to all physically available workers

--resume        Resumes preprocessing from an aborted or partial previous run

--force         Forces overwrite of existing output files

--verbose       Displays console output

--adv           Diables safety check to force run certain preprocessing steps **WARNING: This flag is for advanced users only who fully understand the MRI system and its outputs. Running with this flag could potentially yield inaccuracies in resulting DTI/DKI metrics**
