#!/bin/bash
set -e  # Exit the script if any statement returns a non-true return value

# setup accelerate
if [[ ${DISABLE_ALLELERATE:-1} != 0 ]]; then
    echo "Configuring accelerate..."
    mkdir -p /root/.cache/huggingface/accelerate
    cp /dependencies/accelerate.yaml /root/.cache/huggingface/accelerate/default_config.yaml
fi

echo "Starting Kohya_ss Web UI"
cd /kohya_ss && \
source venv/bin/activate && \
bash setup.sh && \
nohup bash gui.sh \
    --listen 0.0.0.0 \
    --server_port ${KOHYA_PORT:-8081} \
    --headless \
    >> kohya.log 2>&1 &
echo "Kohya_ss Web UI started, log in /kohya_ss/kohya.log"
sleep infinity
