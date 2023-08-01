#!/bin/bash
cat $0
set -e  # Exit the script if any statement returns a non-true return value
export PYTHONUNBUFFERED=1

echo "Starting Stable Diffusion Web UI"

nohup bash webui.sh -f \
    --port ${PORT:-8080} \
    --listen \
    --xformers \
    --deepdanbooru \
    --disable-nan-check \
    --opt-sdp-attention \
    --enable-insecure-extension-access \
    --config config.json \
    --ui-config-file ui-config.json \
    >> webui.log 2>&1 &

echo "Stable Diffusion Web UI started, wait for a while and get logs at: /stable-diffusion-webui/webui.log"
sleep infinity
