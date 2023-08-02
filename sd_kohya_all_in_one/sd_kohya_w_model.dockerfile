# Stage 1: Base
FROM lockinwu/sd_base_image_w_model:v1.5 as sd-models
FROM lockinwu/sd_kohya_all_in_one:v3 as base

LABEL author="stevenchenworking@gmail.com"

# Stage 2: init models
COPY --from=sd-models /models/stable-diffusion/v1-5-pruned.safetensors /models/stable-diffusion/v1-5-pruned.safetensors
COPY --from=sd-models /models/stable-diffusion/vae-ft-mse-840000-ema-pruned.safetensors /models/stable-diffusion/vae-ft-mse-840000-ema-pruned.safetensors

FROM base as work

# Stage 3: link the models into stable-diffusion-webui
RUN ln -s /models/stable-diffusion/v1-5-pruned.safetensors /stable-diffusion-webui/models/Stable-diffusion/v1-5-pruned.safetensors && \
    ln -s /models/stable-diffusion/vae-ft-mse-840000-ema-pruned.safetensors /stable-diffusion-webui/models/VAE-approx/v1-5-pruned.safetensors

# Stage 4: Execute startup script
WORKDIR /
STOPSIGNAL SIGINT
CMD [ "bash", "/start.sh" ]