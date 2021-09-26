##Build Command
# docker build -t ghcr.io/bmabir17/deploy_insightface:v1 .
##Docker Run Command
# docker run -it --gpus all  ghcr.io/bmabir17/deploy_insightface:v1

#https://medium.com/@itembe2a/docker-nvidia-conda-h204gpu-make-an-ml-docker-image-47451c5ced51
# Use a docker image as base image
FROM nvidia/cuda:11.1-cudnn8-runtime
# Declare some ARGuments
ARG PYTHON_VERSION=3.8
ARG CONDA_VERSION=3
ARG CONDA_PY_VERSION=py38_4.10.3
# Installation of some libraries / RUN some commands on the base image
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends python3-pip python3-dev wget \
    bzip2 libopenblas-dev pbzip2 libgl1-mesa-glx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# INSTALLATION OF CONDA
ENV PATH /opt/conda/bin:$PATH
RUN wget https://repo.anaconda.com/miniconda/Miniconda$CONDA_VERSION-$CONDA_PY_VERSION-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo “. /opt/conda/etc/profile.d/conda.sh” >> ~/.bashrc && \
    echo “conda activate base” >> ~/.bashrc
ENV TINI_VERSION v0.16.1
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
# Install build essential as gcc is needed to install insightFace
RUN apt-get update && apt-get install build-essential -y
# Allow statements and log messages to immediately appear in the Knative logs
ENV PYTHONUNBUFFERED True
RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" TZ="America/New_York" apt-get -y install tzdata
RUN apt-get update && apt-get install -y libglib2.0-0
RUN apt update && apt install -y git

# Copy local code to the container image.
ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . ./
RUN conda init bash
# Create the environment:
RUN conda env create -f environment.yaml

# The code to run when container is started:
RUN chmod +x ./entrypoint.sh
ENTRYPOINT ["/bin/bash", "--login", "-c","./entrypoint.sh"]