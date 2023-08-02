#!/bin/bash
set -e  # Exit the script if any statement returns a non-true return value

echo "Starting SD.Next"
cd /automatic && \
source venv/bin/activate && \
nohup bash webui.sh \
    -f \
    --listen \
    --port ${SD_NEXT_PORT:-8083} \
    >> sd_next.log 2>&1 &
echo "SD.Next started, log in /automatic/sd_next.log"
sleep infinity
