# Stage 1: Base
FROM lockinwu/sd_base_image:v1 as base

LABEL author="stevenchenworking@gmail.com"
ENV PATH="$PATH:/home/root/.local/bin" \
    DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai \
    PYTHONUNBUFFERED=1

# Create workspace working directory
WORKDIR /

# Copy related files
COPY requirements_extra_kohya.txt \
     requirements_dreambooth.txt \
     requirements_versions.txt \
     requirements.txt \
     accelerate.yaml \
     /dependencies/

# Setup base projects
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git && \
    git clone https://github.com/toshiaki1729/stable-diffusion-webui-dataset-tag-editor /stable-diffusion-webui/extensions/stable-diffusion-webui-dataset-tag-editor &&\
    git clone https://github.com/a2569875/stable-diffusion-webui-composable-lora /stable-diffusion-webui/extensions/stable-diffusion-webui-composable-lora &&\
    git clone https://github.com/toriato/stable-diffusion-webui-wd14-tagger /stable-diffusion-webui/extensions/stable-diffusion-webui-wd14-tagger &&\
    git clone https://github.com/VinsonLaro/stable-diffusion-webui-chinese /stable-diffusion-webui/extensions/stable-diffusion-webui-chinese &&\
    git clone https://github.com/continue-revolution/sd-webui-segment-anything /stable-diffusion-webui/extensions/sd-webui-segment-anything &&\
    git clone https://github.com/kohya-ss/sd-webui-additional-networks /stable-diffusion-webui/extensions/sd-webui-additional-networks && \
    git clone https://github.com/hako-mikan/sd-webui-regional-prompter /stable-diffusion-webui/extensions/sd-webui-regional-prompter &&\
    git clone https://github.com/Physton/sd-webui-prompt-all-in-one /stable-diffusion-webui/extensions/sd-webui-prompt-all-in-one &&\
    git clone https://github.com/d8ahazard/sd_dreambooth_extension.git /stable-diffusion-webui/extensions/sd_dreambooth_extension && \
    git clone https://github.com/pharmapsychotic/clip-interrogator-ext /stable-diffusion-webui/extensions/clip-interrogator-ext &&\
    git clone https://github.com/ashleykleynhans/a1111-sd-webui-locon /stable-diffusion-webui/extensions/a1111-sd-webui-locon && \
    git clone https://github.com/deforum-art/sd-webui-deforum /stable-diffusion-webui/extensions/sd-webui-deforum && \
    git clone https://github.com/Mikubill/sd-webui-controlnet.git /stable-diffusion-webui/extensions/sd-webui-controlnet && \
    git clone https://github.com/volotat/SD-CN-Animation /stable-diffusion-webui/extensions/SD-CN-Animation &&\
    git clone https://github.com/s0md3v/sd-webui-roop /stable-diffusion-webui/extensions/sd-webui-roop &&\
    git clone https://github.com/bmaltais/kohya_ss.git /kohya_ss

# Stage 2: Setup all projects
# Install stable diffusion webui
WORKDIR /stable-diffusion-webui
RUN python3 -m venv --system-site-packages venv && \
    source venv/bin/activate && \
    pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118 && \
    pip install --no-cache-dir xformers && \
    python -c "from launch import prepare_environment; prepare_environment()" --skip-torch-cuda-test && \
    pip3 install -r /dependencies/requirements.txt &&\
    pip3 install -r /dependencies/requirements_versions.txt &&\
    pip3 install -r /dependencies/requirements_dreambooth.txt &&\
    pip3 install -r /stable-diffusion-webui/extensions/sd-webui-roop/requirements.txt && \
    pip3 install -r /stable-diffusion-webui/extensions/sd-webui-deforum/requirements.txt && \
    pip3 install -r /stable-diffusion-webui/extensions/sd-webui-controlnet/requirements.txt && \
    # Fix Tensorboard
    pip3 uninstall -y tensorboard tb-nightly && \
    pip3 install tensorboard tensorflow open-clip-torch mediapipe onnx && \
    pip3 cache purge && \
    deactivate

# Install Kohya_ss
WORKDIR /kohya_ss
RUN python3 -m venv --system-site-packag venv && \
    source venv/bin/activate && \
    pip3 install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118 && \
    pip3 install -r /dependencies/requirements_extra_kohya.txt && \
    pip3 install -r requirements.txt && \
    pip3 install . && \
    bash setup.sh &&\
    pip3 cache purge && \
    deactivate

# Install Jupyter
RUN pip3 install jupyterlab \
        notebook==6.5.4 \
        ipywidgets \
        jupyter-archive \
        jupyter_contrib_nbextensions \
        gdown && \
    jupyter contrib nbextension install --user && \
    jupyter nbextension enable --py widgetsnbextension

# Stage 3: Setup dependent files
COPY ui-config.json \
     config.json \
     /stable-diffusion-webui/
COPY start.sh /

# Stage 4: Execute startup script
WORKDIR /
STOPSIGNAL SIGINT
CMD [ "bash", "/start.sh" ]