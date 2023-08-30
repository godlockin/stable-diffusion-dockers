# Stage 1: Base
FROM lockinwu/sd_base_image:v1 as base

LABEL author="stevenchenworking@gmail.com"
ENV PATH="$PATH:/home/root/.local/bin" \
    DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai \
    PYTHONUNBUFFERED=1

WORKDIR /

RUN apt update && \
    apt -y upgrade && \
    apt install -y --no-install-recommends nodejs npm

# setup start.sh
RUN git clone https://github.com/7eu7d7/HCP-Diffusion-webui.git /HCP-Diffusion-webui && \
    cd HCP-Diffusion-webui && \
    git clone https://github.com/7eu7d7/HCP-Diffusion.git /HCP-Diffusion-webui/HCP-Diffusion && \
    sed -i "s/app\.run(port=3001)/app.run(host='0.0.0.0', port=8083)/" /HCP-Diffusion-webui/web/hcpdiff-server/main.py

WORKDIR /HCP-Diffusion-webui
RUN python3 -m venv --system-site-packag venv && \
    source venv/bin/activate && \
    cd /HCP-Diffusion-webui/HCP-Diffusion && \
    python3 -m pip install --no-cache-dir --use-pep517 -U -r requirements.txt && \
    python3 -m pip install . && \
    python3 -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118 && \
    python3 -m pip install --no-cache-dir xformers flask --ignore-installed && \
    cd /HCP-Diffusion-webui && \
    python3 env_check.py && \
    python3 -m pip cache purge && \
    deactivate

WORKDIR /HCP-Diffusion-webui
STOPSIGNAL SIGINT
CMD [ "bash", "webui.sh", "-f" ]
