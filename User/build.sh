#!/bin/bash
#version=cuda12.1.0-cudnn8-ubuntu22.04_250224

export Server_Dir=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
cd $Server_Dir
for i in `ls |grep ^Dockerfile_`;
do
  echo $i
  image_tag=${i#*_}
  echo $image_tag
  docker build  -f $i -t registry.cn-sh-01.sensecore.cn/ai-expert-service/lazyllm:${image_tag} .
done
