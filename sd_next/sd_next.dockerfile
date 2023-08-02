FROM lockinwu/sd_base_image:v1 as base

LABEL author="stevenchenworking@gmail.com"
ENV PATH="$PATH:/home/root/.local/bin" \
    DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai \
    PYTHONUNBUFFERED=1

WORKDIR /
COPY requirements_extra.txt \
     start.sh \
     /dependencies/

# setup start.sh
RUN ln -s /dependencies/start.sh start.sh &&\
    chmod +x /start.sh && \
    # init project
    git clone https://github.com/vladmandic/automatic.git /automatic && \
    git clone https://github.com/Stability-AI/stablediffusion.git /automatic/repositories/stable-diffusion-stability-ai &&\
    git clone https://github.com/CompVis/taming-transformers.git /automatic/repositories/taming-transformers &&\
    git clone https://github.com/crowsonkb/k-diffusion.git /automatic/repositories/k-diffusion &&\
    git clone https://github.com/sczhou/CodeFormer.git /automatic/repositories/CodeFormer &&\
    git clone https://github.com/salesforce/BLIP.git /automatic/repositories/BLIP

# setup project
WORKDIR /automatic
RUN python3 -m venv venv && \
    source venv/bin/activate && \
    python3 -m pip install wheel && \
    python3 -m pip install --no-cache-dir --use-pep517 -U -r requirements.txt && \
    python3 -m pip install --no-cache-dir --use-pep517 -U -r /dependencies/requirements_extra.txt && \
    pip3 cache purge && \
    deactivate

# Set up the container startup script
WORKDIR /
STOPSIGNAL SIGINT
CMD [ "bash", "start.sh" ]
