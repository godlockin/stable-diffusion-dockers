#!/bin/bash
set -e  # Exit the script if any statement returns a non-true return value

echo "Starting ComfyUI"
cd /ComfyUI && \
nohup python main.py \
    --listen 0.0.0.0 \
    --port ${COMFY_UI_PORT:-8082} \
    >> comfyui.log 2>&1 &
echo "ComfyUI started, log in /ComfyUI/comfyui.log"
sleep infinity