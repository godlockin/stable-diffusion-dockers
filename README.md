# Introduction
The docker files for stable diffusion related webui

|Name|Reference project|Docker image|Dockerfile|Description|Comments|
|:-:|:-:|:-:|:-:|:-:|:-:|
|Base image|-|docker pull lockinwu/sd_base_image:v1|[base_image.dockerfile](https://github.com/godlockin/stable-diffusion-dockers/blob/miao/base_image/base_image.dockerfile)|The base image for all images, built based on [nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04]|basic tools installed, include python 3.10, venv, wget, git, curl, ffmpeg .etc, can be used as base image for other applications|
|Base image with model|-|docker pull lockinwu/sd_base_image_w_model:v1.5|[base_image_with_model.dockerfile](https://github.com/godlockin/stable-diffusion-dockers/blob/miao/base_image/base_image_with_model.dockerfile)|Built based on the base image, load stable-diffusion v1.5 at: `/models/stable-diffusion/v1-5-pruned.safetensors`, VAE model at: `/models/stable-diffusion/vae-ft-mse-840000-ema-pruned.safetensors`|-|
|Stable diffusion webui|https://github.com/AUTOMATIC1111/stable-diffusion-webui|docker pull lockinwu/stable_diffusion_webui:v1|[sd_webui.dockerfile](https://github.com/godlockin/stable-diffusion-dockers/blob/miao/stable_diffusion_webui/sd_webui.dockerfile)|Original stable diffusion webui, linsten the port `8080` and set the Chinese theme as default|To use pre-downloaded models in host, should be mount the model/checkpoints at: `/stable-diffusion-webui/models/Stable-diffusion/`|
|Stable diffusion webui with model|https://github.com/AUTOMATIC1111/stable-diffusion-webui|docker pull lockinwu/stable_diffusion_webui_w_model:v1.5|[sd_webui_w_model.dockerfile](https://github.com/godlockin/stable-diffusion-dockers/blob/miao/stable_diffusion_webui/sd_webui_w_model.dockerfile)|Mount the stable diffusion v1.5 at `/stable-diffusion-webui/models/Stable-diffusion/` and VAE model at `/stable-diffusion-webui/models/VAE`|-|
|ComfyUI|https://github.com/comfyanonymous/ComfyUI|docker pull lockinwu/comfyui:v5|[comfy_ui.dockerfile](https://github.com/godlockin/stable-diffusion-dockers/blob/miao/comfyui/comfy_ui.dockerfile)|Original ComfyUI, migrate the default port into: `8082`|To use pre-downloaded models in host, should be mount the model/checkpoints at: `/ComfyUI/models/checkpoints/`|-|
|ComfyUI with model|https://github.com/comfyanonymous/ComfyUI|docker pull lockinwu/comfyui_w_model:v1.5|[comfy_ui_w_model.dockerfile](https://github.com/godlockin/stable-diffusion-dockers/blob/miao/comfyui/comfy_ui_w_model.dockerfile)|Mount the stable diffusion v1.5 and VAE model|-|
|SD.Next|https://github.com/vladmandic/automatic|docker pull lockinwu/sd_next:v1|[sd_next.dockerfile](https://github.com/godlockin/stable-diffusion-dockers/blob/miao/sd_next/sd_next.dockerfile)|Original SD.Next ui, migrate the default port into: `8083`|To use pre-downloaded models in host, should be mount the model/checkpoints at: `/automatic/models/Stable-diffusion/`|-|
|SD.Next with model|https://github.com/vladmandic/automatic|docker pull lockinwu/sd_next_w_model:v1.5|[sd_next_w_model.dockerfile](https://github.com/godlockin/stable-diffusion-dockers/blob/miao/sd_next/sd_next_w_model.dockerfile)|Mount the stable diffusion v1.5 at `/automatic/models/Stable-diffusion/` and VAE model at `/automatic/models/VAE`|-|
|Kohya_ss webui|https://github.com/bmaltais/kohya_ss|docker pull lockinwu/kohya_ss_webui:v1|[kohya_webui.dockerfile](https://github.com/godlockin/stable-diffusion-dockers/blob/miao/kohya_ss/kohya_webui.dockerfile)|Original Kohya_ss ui, migrate the default port into: `8081`|-|
|Kohya_ss webui with model|https://github.com/bmaltais/kohya_ss|docker pull lockinwu/lockinwu/kohya_ss_webui_w_model:v1.5|[kohya_webui_w_model.dockerfile](https://github.com/godlockin/stable-diffusion-dockers/blob/miao/kohya_ss/kohya_webui_w_model.dockerfile)|Mount the stable diffusion v1.5 at `/kohya_ss/models/`|-|
|Stable Diffusion WebUI + Kohya_ss WebUI + Jupyter all in one|-|docker pull lockinwu/sd_kohya_all_in_one:v3|[sd_kohya.dockerfile](https://github.com/godlockin/stable-diffusion-dockers/blob/miao/sd_kohya_all_in_one/sd_kohya.dockerfile)|Built the stable diffusion webui + kohya_ss webui + jupyter into one image, open the port `8080` for stable diffusion webui, `8081` for kohya_ss, `8082` for tensorboard, `8083` for jupyter. The default token for jupter is `steven`.|-|
|Stable Diffusion WebUI + Kohya_ss WebUI + Jupyter all in one with model|-|docker pull lockinwu/sd_kohya_all_in_one_w_model:v1.5|[sd_kohya_w_model.dockerfile](https://github.com/godlockin/stable-diffusion-dockers/blob/miao/sd_kohya_all_in_one/sd_kohya_w_model.dockerfile)|Mount the stable diffusion v1.5 at `/stable-diffusion-webui/models/Stable-diffusion/` and VAE model at `/stable-diffusion-webui/models/VAE`|-|

# Additional parameters
|Image|Variable|Usage|Describe|Default|
|:-:|:-:|:-:|:-:|:-:|
|Stable diffusion webui|`PORT`|`docker -e PORT=8080`|set the listen port|`8080`|
|Stable diffusion webui with model|`PORT`|`docker -e PORT=8080`|set the listen port|`8080`|
|ComfyUI|`COMFY_UI_PORT`|`docker -e COMFY_UI_PORT=8082`|set the listen port|`8082`|
|ComfyUI with model|`COMFY_UI_PORT`|`docker -e COMFY_UI_PORT=8082`|set the listen port|`8082`|
|Kohya_ss|`KOHYA_PORT`|`docker -e KOHYA_PORT=8081`|set the listen port|`8081`|
|-|`DISABLE_ALLELERATE`|`docker -e DISABLE_ALLELERATE=0`|disable the allelerate|`1`: enabled allelerate|
|Kohya_ss with model|`KOHYA_PORT`|`docker -e KOHYA_PORT=8081`|set the listen port|`8081`|
|-|`DISABLE_ALLELERATE`|`docker -e DISABLE_ALLELERATE=0`|disable the allelerate|`1`: enabled allelerate|
|Stable Diffusion WebUI + Kohya_ss WebUI + Jupyter all in one|`DISABLE_ALLELERATE`|`docker -e DISABLE_ALLELERATE=0`|disable the allelerate|`1`: enabled allelerate|
|-|`DISABLE_SD`|`docker -e DISABLE_SD=1`|disable the stable diffusion webui|`0`: enabled stable diffusion webui|
|-|`DISABLE_KOHYA`|`docker -e DISABLE_KOHYA=1`|disable the kohya webui|`0`: enabled kohya webui|
|-|`DISABLE_TB`|`docker -e DISABLE_TB=1`|disable the Tensorboard|`0`: enabled Tensorboard|
|-|`PUBLIC_KEY`|`docker -e PUBLIC_KEY=Abcd1234`|set the public key for ssh| not set |
|-|`DISABLE_JUPYTER`|`docker -e DISABLE_JUPYTER=1`|disable the jupyter|`0`: enabled jupyter|
|-|`JUPYTER_PASSWORD`|`docker -e JUPYTER_PASSWORD=steven`|set the jupyer's token|`steven`|

# Bootstrap
Base commend
```bash
docker run --gpus all -it --rm --privileged \
    --ulimit memlock=-1 --ulimit stack=67108864 \
    --name=test \
```

Stable diffusion webui
```bash
docker run --gpus all -it --rm --privileged \
    -p 8080:8080 \
    --ulimit memlock=-1 --ulimit stack=67108864 \
    -v /path/to/model/Stable-diffusion:/stable-diffusion-webui/models/ \
    --name=test \
    lockinwu/stable_diffusion_webui:v1
```

Stable diffusion webui with model
```bash
docker run --gpus all -it --rm --privileged \
    -p 8080:8080 \
    --ulimit memlock=-1 --ulimit stack=67108864 \
    --name=test \
    lockinwu/stable_diffusion_webui_w_model:v1.5
```

Stable diffusion webui with model with customized port
```bash
docker run --gpus all -it --rm --privileged \
    -p 8080:8081 \
    --ulimit memlock=-1 --ulimit stack=67108864 \
    -e PORT=8081 \
    --name=test \
    lockinwu/stable_diffusion_webui_w_model:v1.5
```

(Others omissions)
All in one
```bash
docker run --gpus all -it --rm --privileged \
    -p 8080:8080 -p 8081:8081 -p 8082:8082 -p 8083:8083 \
    --ulimit memlock=-1 --ulimit stack=67108864 \
    -v /path/to/stable_diffusion_models/:/stable-diffusion-webui/models/ \
    -v /path/to/stable_diffusion_extension_controlnet_downloaded_models/:/stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads \
    -v /path/to/stable_diffusion_extensions/:/stable-diffusion-webui/extensions/ \
    -v /path/to/.ifnude/detector.onnx:/root/.ifnude/detector.onnx \
    --name=sd_all_in_one \
    lockinwu/sd_kohya_all_in_one:v3
```
