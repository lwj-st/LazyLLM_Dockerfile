# 配置基础镜像
FROM nvidia/cuda:12.1.0-cudnn8-devel-ubuntu22.04

# 设置工作目录
WORKDIR /tmp

USER root
# 安装依赖
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV TZ=Asia/Shanghai

RUN set -ex \
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && apt-get update && apt-get install -y openssh-server \
    git vim tzdata curl net-tools locales zip libtinfo5 cmake \
    exuberant-ctags libclang-dev tcl expect telnet rsync \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && service ssh start \
    && echo 'LANG="en_US.UTF-8"' > /etc/default/locale \
    && echo 'LC_ALL="en_US.UTF-8"' >> /etc/default/locale \
    && locale-gen en_US.UTF-8


# 下载并安装 Miniconda
RUN set -ex \
    && wget https://repo.anaconda.com/miniconda/Miniconda3-py310_23.1.0-1-Linux-x86_64.sh \
    && bash Miniconda3-py310_23.1.0-1-Linux-x86_64.sh -b -p /opt/miniconda3 \
    && rm Miniconda3-py310_23.1.0-1-Linux-x86_64.sh \
    && wget https://packages.redis.io/redis-stack/redis-stack-server-7.2.0-v10.rhel7.x86_64.tar.gz \
    && tar xf redis-stack-server-7.2.0-v10.rhel7.x86_64.tar.gz \
    && mv redis-stack-server-7.2.0-v10 /usr/local/ \
    && rm -rf redis-stack-server-7.2.0-v10.rhel7.x86_64.tar.gz

# 将 conda 的 bin 目录添加到 PATH 环境变量
ENV PATH="/opt/miniconda3/bin:/usr/local/redis-stack-server-7.2.0-v10/bin:${PATH}"

# 复制 requirements.txt 文件到 Docker 容器
COPY requirements* /tmp/

# 初始化 conda
RUN conda init bash \
    && conda create -n lazyllm --clone base \
    && echo "source activate lazyllm" > ~/.bashrc

# 拆分多个requirements安装
RUN bash -c "source activate lazyllm && pip install  -r requirements0.txt --default-timeout=10000 --no-deps  --no-cache-dir " \
    && bash -c "source activate lazyllm && pip install  -r requirements1.txt --default-timeout=10000 --no-deps  --no-cache-dir " \
    && bash -c "source activate lazyllm && pip install  -r requirements2.txt --default-timeout=10000 --no-deps  --no-cache-dir " \
    && bash -c "source activate lazyllm && pip install  -r requirements3.txt --default-timeout=10000 --no-deps  --no-cache-dir " \
    && bash -c "source activate lazyllm && pip install flash-attn==2.5.8" \
    && bash -c "source activate lazyllm && conda install -y mpi4py" \
    && bash -c "source activate lazyllm && git clone --depth 1 https://github.com/hiyouga/LLaMA-Factory.git && cd LLaMA-Factory && pip install -e ." \
    && bash -c "source activate lazyllm && pip install https://mirrors.cloud.tencent.com/pypi/packages/53/b7/6663ec9c0157cf7c766bd4c9dca957ca744f0b3b16c945be7e8f8d0b2142/rpdb-0.1.6.tar.gz" \
    && rm -rf /tmp/*


ENTRYPOINT ["/bin/bash"]
WORKDIR /root