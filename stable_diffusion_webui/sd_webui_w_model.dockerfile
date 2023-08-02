FROM lockinwu/sd_base_image_w_model:v1.5 as sd-models
FROM lockinwu/stable_diffusion_webui:v1 as base

LABEL author="stevenchenworking@gmail.com"

COPY --from=sd-models /models/stable-diffusion/v1-5-pruned.safetensors /stable-diffusion-webui/models/Stable-diffusion/v1-5-pruned.safetensors
COPY --from=sd-models /models/stable-diffusion/vae-ft-mse-840000-ema-pruned.safetensors /stable-diffusion-webui/models/VAE/vae-ft-mse-840000-ema-pruned.safetensors

FROM base as work

WORKDIR /stable-diffusion-webui
STOPSIGNAL SIGINT
CMD [ "bash", "start.sh" ]
