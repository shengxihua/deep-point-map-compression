# Base image
FROM pytorch/pytorch:1.7.0-cuda11.0-cudnn8-runtime

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
    vim \
    && rm -rf /var/lib/apt/lists/*
