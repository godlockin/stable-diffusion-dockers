FROM nvcr.io/nvidia/pytorch:23.04-py3

ENV PATH="$PATH:/home/appuser/.local/bin" \
    DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai

WORKDIR /app
COPY requirements_extra.txt .

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
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3 && \
    # download project
    git clone https://github.com/vladmandic/automatic.git &&\
    cd automatic &&\
    # install requirements
    python3 -m venv /app/automatic/venv &&\
    source /app/automatic/venv/bin/activate &&\
    python3 -m pip install wheel && \
    python3 -m pip install --no-cache-dir --use-pep517 -U -r requirements.txt &&\
    python3 -m pip install --no-cache-dir --use-pep517 -U -r /app/requirements_extra.txt &&\
    # download support repo
    git clone https://github.com/Stability-AI/stablediffusion.git /app/automatic/repositories/stable-diffusion-stability-ai &&\
    git clone https://github.com/CompVis/taming-transformers.git /app/automatic/repositories/taming-transformers &&\
    git clone https://github.com/crowsonkb/k-diffusion.git /app/automatic/repositories/k-diffusion &&\
    git clone https://github.com/sczhou/CodeFormer.git /app/automatic/repositories/CodeFormer &&\
    git clone https://github.com/salesforce/BLIP.git /app/automatic/repositories/BLIP &&\
    # Fix missing libnvinfer7
    ln -s /usr/lib/x86_64-linux-gnu/libnvinfer.so /usr/lib/x86_64-linux-gnu/libnvinfer.so.7 && \
    ln -s /usr/lib/x86_64-linux-gnu/libnvinfer_plugin.so /usr/lib/x86_64-linux-gnu/libnvinfer_plugin.so.7

ENV LD_PRELOAD=libtcmalloc.so

WORKDIR /app/automatic

STOPSIGNAL SIGINT
CMD "./webui.sh" -f --listen --port 7860

