# Use official nvidia-docker cuda 10.0 as parent image
# CUDA 10.1 is not fully supported yet by tensorflow when this Dockerfile was created
FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04

ARG user
ARG group
ARG uid
ARG gid

RUN groupadd -g ${gid} ${group} && \
    useradd -u ${uid} -g ${gid} -ms /bin/bash ${user}

WORKDIR /home/${user}

# Supress warnings about missing front-end. As recommended at:
# http://stackoverflow.com/questions/22466255/is-it-possibe-to-answer-dialog-questions-when-installing-under-docker
ARG DEBIAN_FRONTEND=noninteractive

# Essentials: developer tools, build tools, OpenBLAS
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils git curl vim unzip openssh-client wget \
    build-essential cmake \
    libopenblas-dev \
    libgtk2.0-dev

# Python 3.6
RUN apt-get update && apt-get install -y --no-install-recommends python3.6 python3.6-dev python3-pip python3-tk

ENV PATH="/home/${user}/.local/bin:${PATH}"
USER ${user}

# tf_unet
RUN pip3 install --no-cache-dir --user --upgrade pip setuptools
RUN git clone https://github.com/jakeret/tf_unet.git
RUN cd tf_unet && pip3 install --no-cache-dir --user -r $(grep -ivE "tensorflow" requirements.txt) \
    "tensorflow-gpu>=1.3.0" && \
    python3 setup.py install --user

# Jupyter Notebook
# Allow access from outside the container, and skip trying to open a browser.
# NOTE: disable authentication token for convenience. DON'T DO THIS ON A PUBLIC SERVER.
RUN pip3 install --no-cache-dir --user jupyter && \
    mkdir .jupyter && \
    echo "c.NotebookApp.ip = '0.0.0.0'" \
         "\nc.NotebookApp.open_browser = False" \
         "\nc.NotebookApp.token = ''" \
         > .jupyter/jupyter_notebook_config.py
EXPOSE 8888
