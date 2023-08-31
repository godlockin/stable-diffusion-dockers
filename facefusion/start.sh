#!/bin/bash

echo "Starting face fusion Web UI"
cd /facefusion && \
nohup python \
    run.py \
    --execution-providers cuda \
    -o /facefusion/output/ \
    >> facefusion.log 2>&1 &
echo "Facefusion Web UI started, log in /facefusion/facefusion.log"
sleep infinity
