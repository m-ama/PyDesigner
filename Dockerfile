# ==============================================================================
# MAMA-Docker
# A docker container that contains all PyDesigner dependencies such as MRTRIX3,
# FSL, and Python to preprocess diffusion MRI images. Additional dependencies 
# will be incorporated as the pipeline progresses further
#
# Maintainer: Siddhartha Dhiman
# ------------------------------------------------------------------------------
# Current Dependencies
#    1.) FSL
#    2.) MRTRIX3
#    3.) Python 2.7
#    4.) Python 3 
#    6.) PyDesigner
# ==============================================================================

# Load base Ubuntu image
FROM debian:buster-slim

# Add LABEL Information
# ARG BUILD_DATE
# ARG VCS_REF

# Labels.
LABEL maintainer="Siddhartha Dhiman (dhiman@musc.edu)"
LABEL org.label-schema.schema-version="1.0.0-rc1"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.name="dmri/pydesigner"
LABEL org.label-schema.description="A state-of-the-art difusion and kurtosis MRI processing pipeline"
LABEL org.label-schema.url="https://github.com/m-ama/"
LABEL org.label-schema.vcs-url="https://github.com/m-ama/NeuroDock.git"
LABEL org.label-schema.vcs-ref=$VCS_REF
LABEL org.label-schema.vendor="MAMA"

ARG DEBIAN_FRONTEND=noninteractive

# Initial update
RUN apt-get update && \
      apt-get install -y \
      apt-utils \
      wget \
      curl \
      nano \
      software-properties-common \
      python2.7 python-pip \
      python3-pip \
      jq

# # Install MRTRIX3 dependencies
# RUN apt-get install -y --no-install-recommends \
#       clang \
#       git \
#       python-numpy \
#       libeigen3-dev \
#       zlib1g-dev \
#       libqt4-opengl-dev \
#       libgl1-mesa-dev \
#       libfftw3-dev \
#       libtiff5-dev \
#       libomp-dev

# RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Copy and install PyDesigner
RUn mkdir -p /tmp/PyDesigner
ADD . / /tmp/PyDesigner/
RUN pip3 install /tmp/PyDesigner
# ENV PATH=$PATH:/usr/local/PyDesigner/designer
# RUN echo "alias python=python3" >> ~/.bashrc && source ~/.bashrc
# RUN echo "alias pip=pip3" >> ~/.bashrc && source ~/.bashrc
# RUN echo "alias pydesigner='python3 /usr/local/PyDesigner/designer/pydesigner.py'" >> ~/.bashrc && source ~/.bashrc

# # Install Python dependencies
# RUN pip3 install --upgrade setuptools && \
#             pip3 install numpy \
#                         pandas \
#                         scipy \
#                         joblib \
#                         multiprocess \
#                         tqdm \
#                         nibabel \
#                         cvxpy

# # Install FSL
# RUN curl https://fsl.fmrib.ox.ac.uk/fsldownloads/fslinstaller.py -o /tmp/fslinstaller.py
# RUN echo "/usr/local/fsl" | python2 /tmp/fslinstaller.py -V 6.0.2

# # Configure FSL Environment
# ENV FSLDIR=/usr/local/fsl
# ENV FSLOUTPUTTYPE=NIFTI_GZ
# ENV PATH=$PATH:$FSLDIR/bin
# ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$FSLDIR

# # Build and Configure MRTRIX3
# RUN git clone https://github.com/MRtrix3/mrtrix3.git /usr/lib/mrtrix3
# ENV CXX=/usr/bin/clang++
# ENV ARCH=native
# RUN cd /usr/lib/mrtrix3 && \
#       ./configure -nogui -openmp && \
#       ./build && \
#       ./set_path
# ENV PATH=$PATH:/usr/lib/mrtrix3/bin

# # Remove unwanted packages
# RUN apt-get autoremove && apt-get clean
# RUN rm /tmp/fslinstaller.py && rm -r /tmp/PyDesigner
# RUN rm -r /tmp/PyDesigner

# # Create PyDesigner executable
# RUN printf '#!/bin/bash\npython3 /usr/local/PyDesigner/designer/pydesigner.py "$@"' > /usr/bin/pydesigner && chmod +x /usr/bin/pydesigner
