FROM lockinwu/sd_base_image:v1 as base

LABEL author="stevenchenworking@gmail.com"
ENV PATH="$PATH:/home/root/.local/bin" \
    DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai \
    PYTHONUNBUFFERED=1

WORKDIR /

# setup start.sh
RUN GIT_LFS_SKIP_SMUDGE=1 git clone https://github.com/modelscope/facechain.git --depth 1 facechain && \
    sed -i 's/demo\.queue(status_update_rate=1)\.launch(share=True)/demo.queue(max_size=100, concurrency_count=20, status_update_rate=1).launch(inbrowser=False, server_name="0.0.0.0", server_port=8080)/g' /facechain/app.py && \
    sed -i 's/tensorflow==2.7.0/tensorflow/g' /facechain/requirements.txt

# setup project
WORKDIR /facechain
RUN python3 -m pip install --no-cache-dir --use-pep517 -U -r requirements.txt && \
    pip3 cache purge

# Set up the container startup script
STOPSIGNAL SIGINT
CMD [ "python", "app.py" ]
