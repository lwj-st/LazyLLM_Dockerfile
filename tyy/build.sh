# 因为镜像ubuntu:22.04 一直在更新，所以提前控制本地镜像版本
docker pull docker.io/library/ubuntu:22.04@sha256:0e5e4a57c2499249aafc3b40fcd541e9a456aab7296681a3994d631587203f97
docker tag 97271d29cb79 ubuntu:22.04
docker build -t registry.sensetime.com/parrots/sqa:beta .
