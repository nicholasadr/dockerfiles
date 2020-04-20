FROM nvidia/cuda:8.0-cudnn5-devel-ubuntu16.04

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
    libgtk2.0-dev \
    bzip2 ca-certificates \
    python-pip python-dev python-tk

ENV PATH="/home/${user}/.local/bin:${PATH}"
USER ${user}

# FlowNet2
RUN pip install --no-cache-dir --user --upgrade pip setuptools==44.0.0
RUN git clone https://github.com/sampepose/flownet2-tf.git
RUN cd flownet2-tf && pip install --no-cache-dir --user enum pypng matplotlib image scipy numpy "tensorflow-gpu==1.2.0"

# Jupyter Notebook
# Allow access from outside the container, and skip trying to open a browser.
# NOTE: disable authentication token for convenience. DON'T DO THIS ON A PUBLIC SERVER.
RUN pip install --no-cache-dir --user jupyter scikit-learn && \
    mkdir .jupyter && \
    echo "c.NotebookApp.ip = '0.0.0.0'" \
         "\nc.NotebookApp.open_browser = False" \
         "\nc.NotebookApp.token = ''" \
         > .jupyter/jupyter_notebook_config.py
EXPOSE 8888
