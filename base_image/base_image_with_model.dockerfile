# Stage 1: Base
FROM lockinwu/sd_base_image:v1 as base

LABEL author="stevenchenworking@gmail.com"

# Load related models
ADD https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned.safetensors /models/stable-diffusion/
ADD https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors /models/stable-diffusion/
