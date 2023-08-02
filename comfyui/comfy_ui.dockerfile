# Stage 1: Base
FROM lockinwu/sd_base_image:v1 as base

LABEL author="stevenchenworking@gmail.com"
ENV PATH="$PATH:/home/root/.local/bin" \
    DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai \
    PYTHONUNBUFFERED=1

WORKDIR /
COPY start.sh /dependencies/

# setup start.sh
RUN ln -s /dependencies/start.sh start.sh &&\
    chmod +x /start.sh && \
    # init project
    git clone https://github.com/comfyanonymous/ComfyUI.git ComfyUI

WORKDIR /ComfyUI
RUN python3 -m pip install wheel torchvision && \
    python3 -m pip install --no-cache-dir --use-pep517 -U -r requirements.txt 

WORKDIR /
STOPSIGNAL SIGINT
CMD [ "bash", "start.sh" ]
