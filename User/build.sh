#!/bin/bash
version=cuda12.1.0-cudnn8-ubuntu22.04_0923

export Server_Dir=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
cd $Server_Dir
for i in `ls |grep ^Dockerfile_`;
do
  echo $i
  user=${i#*_}
  echo $user
  docker build --build-arg version=$version -f $i -t registry.cn-sh-01.sensecore.cn/ai-expert-service/lazyllm:${version}_${user} .
done
