FROM lockinwu/sd_base_image:v1 as base

LABEL author="stevenchenworking@gmail.com"
ENV PATH="$PATH:/home/root/.local/bin" \
    DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai \
    PYTHONUNBUFFERED=1

WORKDIR /
# cp related files
COPY start.sh \
     /dependencies/

RUN ln -s /dependencies/start.sh start.sh &&\
    chmod +x /start.sh

# setup start.sh
RUN GIT_LFS_SKIP_SMUDGE=1 git clone https://github.com/facefusion/facefusion.git --depth 1 /facefusion && \
    sed -i 's/ui\.launch(show_api = False)/ui.launch(show_api = False, server_name="0.0.0.0", server_port=8084)/' /facefusion/facefusion/uis/core.py

# setup project
WORKDIR /facefusion
RUN python3 -m pip install --no-cache-dir --use-pep517 -U -r requirements.txt && \
    python3 -m pip install --upgrade tensorrt && \
    pip3 cache purge

# Set up the container startup script
STOPSIGNAL SIGINT
WORKDIR /
CMD [ "bash", "start.sh" ]
