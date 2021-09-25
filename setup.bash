#/bin/bash --login
# conda env create -f environment.yaml
. /opt/conda/etc/profile.d/conda.sh
conda activate insightFace && \
# git clone https://github.com/deepinsight/insightface.git && \
# cd insightface/python-package && \
# python -m pip install -e . && \
# cd ../.. && \
gunicorn --bind :$PORT --workers 2 --threads 8 --timeout 0 api:app 
