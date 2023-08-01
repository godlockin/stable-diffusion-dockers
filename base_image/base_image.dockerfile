FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04 as base

SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai \
    PYTHONUNBUFFERED=1

# Create workspace working directory
WORKDIR /

# Install Ubuntu packages
RUN apt update && \
    apt -y upgrade && \
    apt install -y --no-install-recommends \
        software-properties-common \
        libgoogle-perftools4 \
        libtcmalloc-minimal4 \
        apt-transport-https \
        build-essential \
        ca-certificates \
        openssh-server \
        python3.10-venv \
        libcairo2-dev \
        libglib2.0-0 \
        libxrender1 \
        python3-dev \
        python3-tk \
        pkg-config \
        p7zip-full \
        net-tools \
        libxext6 \
        ffmpeg \
        libgl1 \
        libsm6 \
        psmisc \
        unzip \
        bash \
        curl \
        htop \
        ncdu \
        wget \
        git \
        vim \
        zip && \
    update-ca-certificates && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen &&\
    # Set Python and pip
    ln -s /usr/bin/python3.10 /usr/bin/python && \
    curl https://bootstrap.pypa.io/get-pip.py | python && \
    rm -f get-pip.py
