#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os.path as op
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.ticker import AutoMinorLocator, FormatStrFormatter

def plot(input, output, bval=None, mask=None):
    """
    Plots subject motion from eddy_qc output file.

    Parameters
    ----------
    input:  str
        path to eddy_qc's
    output: str
        path to brain mask

    Returns
    -------
    none
        writes plot to path
    
    See Also
    --------
    outlierplot: plots outliers from IRLLS
    snrplot:     plots DWI's SNR  
    """
    print('Plotting motion...')
    if not op.exists(input):
        raise OSError('Input file {} does not exist'.format(input))
    if op.isdir(output):
        raise OSError('Output {} cannot be a directory. Please '
        'define the output to be an image file.'.format(output))
    if op.splitext(output)[-1] != '.png':
        raise OSError('Output path {} does not indicate a PNG file'
        ''. format(input))
    # Load file
    dat = np.loadtxt(input)
    if dat.size[-1] != 2:
        raise Exception('The input file containing eddy computed '
        'movement should have only two columns. The file {} supplied '
        'however only contains {} column(s)'.format(input, dat.size[-1])
    nvols = dat.shape[0]
    # The datafile being read here should be 
    # `eddy_restricted_movement_rms`, which contians information on
    # how much a subjects moved during a DWI scan, with complete
    # disregard of translation in PE dir. The file has two columns
    # where the first contains the RMS movement relative the first
    # volume and the second column the RMS relative the previous
    # volume
    # Variables:
    #   relone: motion relative to first volume
    #   relbef: motion relative to previous volume
    #   cum:    cunulative motion from relbef
    relone = dat[:, 0]
    relbef = dat[:, 1]
    cum = np.cumsum(relbef)
    x = np.arange(start=1, stop=nvols+1, step=1)
    # Plot
    plt.style.use('ggplot')
    fig, ax = plt.subplots()
    ax.plot(x, relone, linewidth=1, label='Realtive to first volume')
    ax.plot(x, relbef, linewidth=1, label='Relative to previous volume')
    plt.plot(x, cum, linewidth=1, label='Cumulative sum of previous volumes')
    plt.xlabel('Volume Number')
    plt.ylabel('RMS of Voxel Displacement')
    ax.legend(loc='upper center', bbox_to_anchor=(0.5, -0.30), shadow=True, ncol=2)
    ax.xaxis.set_minor_locator(AutoMinorLocator())
    ax.grid(which='minor', linestyle=':', linewidth='0.5')
    plt.title('Intervolume Head Motion')
    plt.tight_layout()
    plt.savefig(output, dpi=600)
