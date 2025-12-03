### 版本镜像

```bash
export VERSION=
docker build --build-arg LAZYLLM_VERSION=$VERSION -t lazyllm/lazyllm:$VERSION .
docker tag lazyllm/lazyllm:$VERSION registry.cn-hangzhou.aliyuncs.com/lazyllm/lazyllm:$VERSION
docker tag lazyllm/lazyllm:$VERSION lazyllm/lazyllm:latest
docker tag lazyllm/lazyllm:$VERSION registry.cn-hangzhou.aliyuncs.com/lazyllm/lazyllm:latest

docker push lazyllm/lazyllm:$VERSION
docker push registry.cn-hangzhou.aliyuncs.com/lazyllm/lazyllm:$VERSION
docker push lazyllm/lazyllm:latest
docker push registry.cn-hangzhou.aliyuncs.com/lazyllm/lazyllm:latest
```

### light镜像

#### arm
```bash
export VERSION=
docker buildx build -f Dockerfile-light --build-arg LAZYLLM_VERSION=$VERSION --platform linux/arm64 -t lazyllm/lazyllm:$VERSION-light-arm64 --push . 
docker tag lazyllm/lazyllm:$VERSION-light-arm64 registry.cn-hangzhou.aliyuncs.com/lazyllm/lazyllm:$VERSION-light-arm64
docker push registry.cn-hangzhou.aliyuncs.com/lazyllm/lazyllm:$VERSION-light-arm64
```

#### x86
```bash
export VERSION=
docker buildx build -f Dockerfile-light --build-arg LAZYLLM_VERSION=$VERSION --platform linux/amd64 -t lazyllm/lazyllm:$VERSION-light-amd64 --push .
docker tag lazyllm/lazyllm:$VERSION-light-amd64 registry.cn-hangzhou.aliyuncs.com/lazyllm/lazyllm:$VERSION-light-amd64
docker push registry.cn-hangzhou.aliyuncs.com/lazyllm/lazyllm:$VERSION-light-amd64
```

#### 合并
```bash
# 合并hub.docker
export VERSION=
docker manifest create lazyllm/lazyllm:$VERSION-light \
  --amend lazyllm/lazyllm:$VERSION-light-amd64 \
  --amend lazyllm/lazyllm:$VERSION-light-arm64

docker manifest push lazyllm/lazyllm:$VERSION-light

# 合并阿里云
docker manifest create registry.cn-hangzhou.aliyuncs.com/lazyllm/lazyllm:$VERSION-light \
  --amend registry.cn-hangzhou.aliyuncs.com/lazyllm/lazyllm:$VERSION-light-amd64 \
  --amend registry.cn-hangzhou.aliyuncs.com/lazyllm/lazyllm:$VERSION-light-arm64

docker manifest push registry.cn-hangzhou.aliyuncs.com/lazyllm/lazyllm:$VERSION-light

```
