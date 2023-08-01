FROM lockinwu/sd_base_image:v1 as base

# Create workspace working directory
WORKDIR /

# cp related files
COPY requirements_extra.txt \
     accelerate.yaml \
     start.sh \
     /dependencies/

# setup start.sh
RUN ln -s /dependencies/start.sh start.sh &&\
    chmod +x /start.sh && \
    # init kohya
    git clone https://github.com/bmaltais/kohya_ss.git /kohya_ss

# Install Kohya_ss
WORKDIR /kohya_ss
RUN python3 -m venv --system-site-packag venv && \
    source venv/bin/activate && \
    pip3 install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118 && \
    pip3 install -r /dependencies/requirements_extra.txt && \
    pip3 install -r requirements.txt && \
    pip3 install . && \
    bash setup.sh &&\
    pip3 cache purge && \
    deactivate

# Set up the container startup script
WORKDIR /

CMD [ "bash", "start.sh" ]
