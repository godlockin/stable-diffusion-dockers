The docker files for stable diffusion related webui

|name|reference project|docker image|Dockerfile|description|
|:-:|:-:|:-:|:-:|:-:|
|base image|-|docker pull lockinwu/sd_base_image:v1|TODO|The base image for all images, built based on [nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04]|
|base image with model|-|docker pull lockinwu/sd_base_image:v1 TODO||Built based on the base image, load stable-diffusion v1.5 and VAE in [/models/stable-diffusion/]|
|stable diffusion webui|https://github.com/AUTOMATIC1111/stable-diffusion-webui||||