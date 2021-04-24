#/bin/bash
conda env create -f environment.yaml
conda activate insightface
git clone https://github.com/deepinsight/insightface.git
# pip3 install mmdnn
cd insightface/python-package
python -m pip install -e .