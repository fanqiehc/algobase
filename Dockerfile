FROM ubuntu:24.04

RUN apt update && \
    apt install -y wget ca-certificates && \
    update-ca-certificates --fresh && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# 安装 Miniconda
ENV CONDA_DIR=/opt/conda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p $CONDA_DIR && \
    rm /tmp/miniconda.sh

ENV PATH=$CONDA_DIR/bin:$PATH

# Conda 会安装所需的 CUDA runtime 库（cudatoolkit）
RUN conda tos accept --override-channels --channel defaults --channel https://repo.anaconda.com/pkgs/main --channel https://repo.anaconda.com/pkgs/r && \
    conda install -y python=3.10.18 && \
    conda clean --all && \
    rm -rf /opt/conda/pkgs/*  # 确保删除 pkgs 目录

RUN conda config --set remote_connect_timeout_secs 90 && \
    conda config --set remote_read_timeout_secs 180 && \
    conda config --set remote_max_retries 10 && \
    conda config --set remote_backoff_factor 3 && \
    conda tos accept --override-channels --channel defaults --channel https://repo.anaconda.com/pkgs/main --channel https://repo.anaconda.com/pkgs/r && \
    conda install -y pytorch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1 pytorch-cuda=11.7 -c pytorch -c nvidia && \
    conda clean --all && \
    rm -rf /opt/conda/pkgs/*  # 确保删除 pkgs 目录

#RUN conda install -y SimpleITK vtk=9.2 && \
#    conda clean --all && \
#    rm -rf /opt/conda/pkgs/*  # 确保删除 pkgs 目录
