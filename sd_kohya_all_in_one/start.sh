#!/bin/bash
set -e  # Exit the script if any statement returns a non-true return value
export PYTHONUNBUFFERED=1

# ---------------------------------------------------------------------------- #
#                          Function Definitions                                #
# ---------------------------------------------------------------------------- #

# setup accelerate
setup_allelerate() {
    if [[ ${DISABLE_ALLELERATE:-1} != 0 ]]; then
        echo "Configuring accelerate..."
        mkdir -p /root/.cache/huggingface/accelerate
        mv /dependencies/accelerate.yaml /root/.cache/huggingface/accelerate/default_config.yaml
    fi
}

# start stable-diffusion-ui
start_sd() {
    if [[ ${DISABLE_SD:-0} != 1 ]]; then
        echo "Starting Stable Diffusion Web UI"
        cd /stable-diffusion-webui
        source venv/bin/activate
        nohup ./webui.sh -f \
            --port 8080 \
            --listen \
            --xformers \
            --deepdanbooru \
            --disable-nan-check \
            --opt-sdp-attention \
            --enable-insecure-extension-access \
            --config config.json \
            --ui-config-file ui-config.json \
            > /logs/webui.log 2>&1 &
        echo "Stable Diffusion Web UI started"
        echo "Log file: /logs/webui.log"
        deactivate
        cd -
    fi
}

# start kohya ui
start_kohya() {
    if [[ ${DISABLE_KOHYA:-0} != 1 ]]; then
        echo "Starting Kohya_ss Web UI"
        cd /kohya_ss
        source venv/bin/activate
        bash setup.sh
        nohup ./gui.sh \
                --listen 0.0.0.0 \
                --server_port 8081 \
                --headless > /logs/kohya_ss.log 2>&1 &
        echo "Kohya_ss started"
        echo "Log file: /logs/kohya_ss.log"
        deactivate
        cd -
    fi
}

# start tensorboard
start_tensorboard() {
    if [[ ${DISABLE_TB:-0} != 1 ]]; then
        echo "Starting Tensorboard"
        mkdir -p /logs/ti
        mkdir -p /logs/dreambooth
        ln -s /stable-diffusion-webui/models/dreambooth /logs/dreambooth
        ln -s /stable-diffusion-webui/textual_inversion /logs/ti
        cd /stable-diffusion-webui
        source venv/bin/activate
        nohup tensorboard --logdir=/workspace/logs --port=6066 --host=0.0.0.0 &
        deactivate
        echo "Tensorboard Started"
        cd -
    fi
}

# Execute script if exists
execute_script() {
    local script_path=$1
    local script_msg=$2
    if [[ -f ${script_path} ]]; then
        echo "${script_msg}"
        bash ${script_path}
    fi
}

# Setup ssh
setup_ssh() {
    if [[ $PUBLIC_KEY ]]; then
        echo "Setting up SSH..."
        mkdir -p ~/.ssh
        echo -e "${PUBLIC_KEY}\n" >> ~/.ssh/authorized_keys
        chmod 700 -R ~/.ssh
        service ssh start
    fi
}

# Export env vars
export_env_vars() {
    echo "Exporting environment variables..."
    printenv | grep -E '^RUNPOD_|^PATH=|^_=' | awk -F = '{ print "export " $1 "=\"" $2 "\"" }' >> /etc/rp_environment
    echo 'source /etc/rp_environment' >> ~/.bashrc
}

# Start jupyter lab
start_jupyter() {
    if [[ ${DISABLE_JUPYTER:-0} != 1 ]]; then
        echo "Starting Jupyter Lab..."
        mkdir -p /Jupyter && \
        cd / && \
        nohup jupyter lab --allow-root \
          --no-browser \
          --port=8888 \
          --ip=* \
          --ServerApp.terminado_settings='{"shell_command":["/bin/bash"]}' \
          --ServerApp.token=${JUPYTER_PASSWORD:-steven} \
          --ServerApp.allow_origin=* \
          --ServerApp.preferred_dir=/Jupyter &> /logs/jupyter.log &
        echo "Jupyter Lab started"
    fi
}

# ---------------------------------------------------------------------------- #
#                               Main Program                                   #
# ---------------------------------------------------------------------------- #

echo "Starting all services"
mkdir -p /logs
setup_allelerate
start_sd
start_kohya
start_tensorboard
start_jupyter
echo "All services' starting done"

setup_ssh
export_env_vars

sleep infinity
