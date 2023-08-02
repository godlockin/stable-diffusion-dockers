# Stage 1: Base
FROM lockinwu/sd_base_image_w_model:v1.5 as sd-models
FROM lockinwu/comfyui:v4 as base

LABEL author="stevenchenworking@gmail.com"

# Add default models
COPY --from=sd-models /models/stable-diffusion/v1-5-pruned.safetensors /ComfyUI/models/checkpoints/v1-5-pruned.safetensors
COPY --from=sd-models /models/stable-diffusion/vae-ft-mse-840000-ema-pruned.safetensors /ComfyUI/models/vae/vae-ft-mse-840000-ema-pruned.safetensors

FROM base as work

WORKDIR /
STOPSIGNAL SIGINT
CMD [ "bash", "start.sh" ]