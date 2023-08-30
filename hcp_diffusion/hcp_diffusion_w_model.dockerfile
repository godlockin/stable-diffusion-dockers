# Stage 1: Base
FROM lockinwu/sd_base_image_w_model:v1.5 as sd-models
FROM lockinwu/hcp_diffusion:v1 as base

LABEL author="stevenchenworking@gmail.com"

# Add default models
COPY --from=sd-models /models/stable-diffusion/v1-5-pruned.safetensors /HCP-Diffusion-webui/sd_models/v1-5-pruned.safetensors

FROM base as work

WORKDIR /HCP-Diffusion-webui
STOPSIGNAL SIGINT
CMD [ "bash", "webui.sh", "-f" ]
