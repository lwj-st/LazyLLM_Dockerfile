#!/bin/bash

if [ $# -gt 0 ]; then
    echo "VERSION: $1"
    VERSION=$1
else
    VERSION="xxx"
    echo "No parameter provided, default VERSION=$VERSION"
fi
# 检查requirements.txt文件是否存在
if [[ ! -f requirements.txt ]]; then
    echo "requirements.txt 文件不存在！"
    exit 1
fi

# 读取requirements.txt文件中的所有行
mapfile -t lines < requirements.txt

# 计算每个分文件中的行数
total_lines=${#lines[@]}
lines_per_file=$(( (total_lines + 3) / 4 ))

# 分割文件
for i in {0..3}; do
    start=$(( i * lines_per_file + 1 ))
    end=$(( (i + 1) * lines_per_file ))
    if (( end > total_lines )); then
        end=$total_lines
    fi
    sed -n "${start},${end}p" requirements.txt > "requirements${i}.txt"
done

echo "分割完成：requirements0.txt - requirements3.txt"
HASH=$(sha256sum requirements.txt | cut -c 1-8)
echo "docker buildx build -f Dockerfile-light --build-arg LAZYLLM_VERSION=$VERSION --platform linux/arm64 -t lazyllm/lazyllm:$VERSION-light-arm64 --push . 
docker buildx build -f Dockerfile-light --build-arg LAZYLLM_VERSION=$VERSION --platform linux/amd64 -t lazyllm/lazyllm:$VERSION-light-amd64 --push .
docker buildx imagetools create \
  -t lazyllm/lazyllm:$VERSION-light \
  lazyllm/lazyllm:$VERSION-light-amd64 \
  lazyllm/lazyllm:$VERSION-light-arm64"

echo "docker build --build-arg LAZYLLM_VERSION=$VERSION -t lazyllm/lazyllm:$VERSION ."
