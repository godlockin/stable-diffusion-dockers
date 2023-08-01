FROM nvcr.io/nvidia/pytorch:23.04-py3

ENV PATH="$PATH:/home/root/.local/bin" \
    DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai

WORKDIR /app

RUN echo "deb http://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse\ndeb http://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse\ndeb http://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse\ndeb http://mirrors.aliyun.com/ubuntu/ jammy-proposed main restricted universe multiverse\ndeb http://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse" > /etc/apt/sources.list && \
    apt update && \
    apt-get install -y software-properties-common ca-certificates --fix-missing && \
    add-apt-repository universe && \
    apt update && \
    apt-get install -y git curl libgl1 libglib2.0-0 libgoogle-perftools-dev apt-transport-https --fix-missing && \
	apt-get install -y python3.10 python3.10-tk python3-html5lib python3-apt python3-pip python3.10-distutils virtualenv python3.10-venv --fix-missing && \
	rm -rf /var/lib/apt/lists/* && \
    # Set python 3.10 as default
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 3 && \
	update-alternatives --config python3 && \
    # upgrade pip
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3 &&\
    # Fix missing libnvinfer7
    ln -s /usr/lib/x86_64-linux-gnu/libnvinfer.so /usr/lib/x86_64-linux-gnu/libnvinfer.so.7 && \
    ln -s /usr/lib/x86_64-linux-gnu/libnvinfer_plugin.so /usr/lib/x86_64-linux-gnu/libnvinfer_plugin.so.7 &&\
    # download project
    git clone https://github.com/comfyanonymous/ComfyUI.git &&\
    cd ComfyUI &&\
    python3 -m pip install wheel torchvision && \
    python3 -m pip install --no-cache-dir --use-pep517 -U -r requirements.txt 
    
ENV LD_PRELOAD=libtcmalloc.so

WORKDIR /app/ComfyUI

STOPSIGNAL SIGINT
CMD python main.py --listen