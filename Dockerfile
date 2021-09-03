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
    libeigen3-dev \
    libgl1-mesa-glx \
    libusb-1.0-0-dev \
    ninja-build \
    pybind11-dev \
    python3 \
    python3-dev \
    python3-pip \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Install Pytorch with CUDA 11 support
# Install python dependencies
# Copy the libary to the docker image
COPY ./ depoco/

# Install depoco and 3rdparty dependencies
RUN cd depoco/ && pip3 install -U -e .
RUN cd depoco/submodules/octree_handler && pip3 install -U .
RUN cd depoco/submodules/ChamferDistancePytorch/chamfer3D/ && pip3 install -U . 2>/dev/null

WORKDIR /depoco/depoco
