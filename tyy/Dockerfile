FROM ubuntu:22.04

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV TZ=Asia/Shanghai

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata locales \
    openssh-server git vim tzdata curl net-tools locales zip libtinfo5 cmake \
    exuberant-ctags libclang-dev tcl expect telnet rsync \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=C.UTF-8


# 下载并安装 Miniconda
RUN set -ex \
    && wget https://repo.anaconda.com/miniconda/Miniconda3-py310_23.1.0-1-Linux-x86_64.sh \
    && bash Miniconda3-py310_23.1.0-1-Linux-x86_64.sh -b -p /opt/miniconda3 \
    && rm Miniconda3-py310_23.1.0-1-Linux-x86_64.sh 

# 将 conda 的 bin 目录添加到 PATH 环境变量
ENV PATH="/opt/miniconda3/bin:${PATH}"

# 复制 requirements.txt 文件到 Docker 容器
COPY requirements.txt /tmp/

# 初始化 conda
RUN conda init bash \
    && conda create -n eqa --clone base \
    && echo "source activate eqa" > ~/.bashrc


# 设置默认的pip源
RUN mkdir -p /root/.pip/ && \
    echo "[global]\n\
index-url = https://pypi.tuna.tsinghua.edu.cn/simple\n\
[install]\n\
trusted-host = pypi.tuna.tsinghua.edu.cn" > /root/.pip/pip.conf

# 安装
RUN bash -c "source activate eqa  \
    && pip install paddlepaddle==2.6.1 \
    && pip install -r /tmp/requirements.txt  && rm -rf /tmp/requirements.txt\
    && pip install llama-index-embeddings-huggingface==0.2.0 \
    && pip install magic-pdf[full]==0.7.0b1 --extra-index-url https://wheels.myhloli.com \
    && pip install paddleocr==2.8.0  pillow==8.4.0  \
    && pip cache purge "

RUN bash -c "source activate eqa  \
    && pip install pytest \
    && pip cache purge "

ENV PYTHONUSERBASE=/data/sqa/.local
ENV PATH="/data/sqa/.local/bin:${PATH}"

RUN apt-get update  \
    && apt-get install -y libgl1 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
