FROM lockinwu/sd_base_image_w_model:v1.5 as sd-models
FROM lockinwu/sd_next:v1 as base

LABEL author="stevenchenworking@gmail.com"

COPY --from=sd-models /models/stable-diffusion/v1-5-pruned.safetensors /automatic/models/Stable-diffusion/v1-5-pruned.safetensors
COPY --from=sd-models /models/stable-diffusion/vae-ft-mse-840000-ema-pruned.safetensors /automatic/models/VAE-approx/vae-ft-mse-840000-ema-pruned.safetensors

FROM base as work

# Set up the container startup script
WORKDIR /
STOPSIGNAL SIGINT
CMD [ "bash", "start.sh" ]
