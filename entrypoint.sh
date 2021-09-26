#/bin/bash --login
. /opt/conda/etc/profile.d/conda.sh
conda activate insightFace && \
gunicorn --bind :$PORT --workers 2 --threads 8 --timeout 0 api:app 
