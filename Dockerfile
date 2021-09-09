# Base image
FROM /pytorch/pytorch:1.7.0-cuda11.0-cudnn8-runtime

# setup environment
ENV TERM xterm
ENV DEBIAN_FRONTEND=noninteractive
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib/python3.8/dist-packages/torch/lib/
ENV PYTHONPATH=/depoco/submodules/ChamferDistancePytorch/

RUN rm /etc/apt/sources.list.d/cuda.list && rm /etc/apt/sources.list.d/nvidia-ml.list && \
    sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

# Install system packages
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    cmake \
    git \
    libeigen3-dev \
    libgl1-mesa-glx \
    libusb-1.0-0-dev \
    ninja-build \
    pybind11-dev \
    && rm -rf /var/lib/apt/lists/*


# Install python dependencies
RUN pip install \
    ruamel.yaml \

# Copy the libary to the docker image
COPY ./ depoco/

# Install depoco and 3rdparty dependencies
RUN cd depoco/ && pip install -U -e .
RUN cd depoco/submodules/octree_handler && pip install -U .
RUN cd depoco/submodules/ChamferDistancePytorch/chamfer3D/ && pip install -U . 2>/dev/null

WORKDIR /depoco/depoco

