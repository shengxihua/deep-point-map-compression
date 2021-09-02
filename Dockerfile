# Base image
FROM pytorch/pytorch:1.7.0-cuda11.0-cudnn8-runtime

# setup environment
ENV TERM xterm
ENV DEBIAN_FRONTEND=noninteractive
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib/python3.8/dist-packages/torch/lib/
ENV PYTHONPATH=/depoco/submodules/ChamferDistancePytorch/

# Provide a data directory to share data across docker and the host system
RUN mkdir -p /mydata

# Install system packages
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    vim 

# Install Pytorch with CUDA 11 support

# Install python dependencies
RUN pip install \
    open3d  \
    tensorboard \
    ruamel.yaml \
    jupyterlab

# Copy the libary to the docker image
COPY ./ depoco/

# Install depoco and 3rdparty dependencies
RUN cd depoco/ && pip install -U -e .
RUN cd depoco/submodules/octree_handler && pip install -U .
RUN cd depoco/submodules/ChamferDistancePytorch/chamfer3D/ && pip install -U . 2>/dev/null

WORKDIR /depoco/depoco
