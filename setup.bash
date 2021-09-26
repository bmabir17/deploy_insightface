#/bin/bash --login
# conda env create -f environment.yaml
. /opt/conda/etc/profile.d/conda.sh
conda activate insightFace && \
# python -m pip install -e "git+https://github.com/deepinsight/insightface.git#egg=insightface&subdirectory=python-package"
# git clone https://github.com/deepinsight/insightface.git && \
cd insightface/python-package && \
python -m pip install -e . && \
cd ../..