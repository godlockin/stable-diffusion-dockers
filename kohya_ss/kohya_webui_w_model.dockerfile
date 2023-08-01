FROM lockinwu/sd_base_image_w_model:v1.5 as sd-models
FROM lockinwu/kohya_ss_webui:v1 as base

# Create workspace working directory
WORKDIR /kohya_ss

COPY --from=sd-models /models/stable-diffusion/v1-5-pruned.safetensors /kohya_ss/models/v1-5-pruned.safetensors

FROM base as work

# cp related files
COPY accelerate.yaml /dependencies/
COPY start.sh /kohya_ss/

WORKDIR /kohya_ss

CMD [ "bash", "start.sh" ]
