FROM lockinwu/sd_base_image_w_model:v1.5 as sd-models
FROM lockinwu/kohya_ss_webui:v1 as base

LABEL author="stevenchenworking@gmail.com"
COPY --from=sd-models /models/stable-diffusion/v1-5-pruned.safetensors /kohya_ss/models/v1-5-pruned.safetensors

FROM base as work

WORKDIR /
STOPSIGNAL SIGINT
CMD [ "bash", "start.sh" ]
