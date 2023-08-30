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
RUN ln -s /dependencies/start.sh start.sh && chmod +x /start.sh && \
    # init project
    git clone https://github.com/comfyanonymous/ComfyUI.git /ComfyUI && \
    git clone https://github.com/M1kep/ComfyLiterals /ComfyUI/custom_nodes/ComfyLiterals && \
    git clone https://github.com/evanspearman/ComfyMath.git /ComfyUI/custom_nodes/ComfyMath && \
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git /ComfyUI/custom_nodes/ComfyUI-Manager && \
    git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack /ComfyUI/custom_nodes/ComfyUI-Impact-Pack && \
    git clone https://github.com/Fannovel16/comfyui_controlnet_aux /ComfyUI/custom_nodes/comfyui_controlnet_aux && \
    git clone https://github.com/WASasquatch/was-node-suite-comfyui /ComfyUI/custom_nodes/was-node-suite-comfyui && \
    git clone https://github.com/ssitu/ComfyUI_UltimateSDUpscale /ComfyUI/custom_nodes/ComfyUI_UltimateSDUpscale && \
    git clone https://github.com/LEv145/images-grid-comfy-plugin.git /ComfyUI/custom_nodes/images-grid-comfy-plugin && \
    git clone https://github.com/Derfuu/Derfuu_ComfyUI_ModdedNodes /ComfyUI/custom_nodes/Derfuu_ComfyUI_ModdedNodes && \
    git clone https://github.com/LucianoCirino/efficiency-nodes-comfyui /ComfyUI/custom_nodes/efficiency-nodes-comfyui && \
    git clone https://github.com/RockOfFire/ComfyUI_Comfyroll_CustomNodes /ComfyUI/custom_nodes/ComfyUI_Comfyroll_CustomNodes && \
    git clone https://github.com/Fannovel16/comfy_controlnet_preprocessors.git /ComfyUI/custom_nodes/comfy_controlnet_preprocessors

WORKDIR /ComfyUI
RUN python3 -m pip install wheel torchvision && \
    python3 -m pip install --no-cache-dir --use-pep517 -U -r /ComfyUI/requirements.txt && \
    python3 -m pip install --no-cache-dir --use-pep517 -U -r /ComfyUI/custom_nodes/ComfyMath/requirements.txt && \
    python3 -m pip install --no-cache-dir --use-pep517 -U -r /ComfyUI/custom_nodes/ComfyUI-Manager/requirements.txt && \
    python3 -m pip install --no-cache-dir --use-pep517 -U -r /ComfyUI/custom_nodes/ComfyUI-Impact-Pack/requirements.txt && \
    python3 -m pip install --no-cache-dir --use-pep517 -U -r /ComfyUI/custom_nodes/comfyui_controlnet_aux/requirements.txt && \
    python3 -m pip install --no-cache-dir --use-pep517 -U -r /ComfyUI/custom_nodes/was-node-suite-comfyui/requirements.txt && \
    python3 -m pip install --no-cache-dir --use-pep517 -U -r /ComfyUI/custom_nodes/efficiency-nodes-comfyui/requirements.txt && \
    python3 -m pip install --no-cache-dir --use-pep517 -U -r /ComfyUI/custom_nodes/comfy_controlnet_preprocessors/requirements.txt && \
    python3 -m pip install --no-cache-dir --use-pep517 -U -r /ComfyUI/custom_nodes/comfyui_controlnet_aux/src/controlnet_aux/tests/requirements.txt && \
    python3 -m pip install --no-cache-dir --use-pep517 -U -r /ComfyUI/custom_nodes/comfy_controlnet_preprocessors/v11/normalbae/models/submodules/efficientnet_repo/requirements.txt && \
    python3 -m pip install --no-cache-dir --use-pep517 -U -r /ComfyUI/custom_nodes/comfyui_controlnet_aux/src/controlnet_aux/normalbae/nets/submodules/efficientnet_repo/requirements.txt

WORKDIR /
STOPSIGNAL SIGINT
CMD [ "bash", "start.sh" ]
