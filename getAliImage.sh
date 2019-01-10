#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

KUBE_VERSION=v1.11.5
KUBE_PAUSE_VERSION=3.1
ETCD_VERSION=3.2.18
DNS_VERSION=1.1.3

GCR_URL=k8s.gcr.io
ALIYUN_URL=registry.cn-hangzhou.aliyuncs.com/xinyuan/k8s

images=(kube-proxy-amd64:${KUBE_VERSION}
kube-scheduler-amd64:${KUBE_VERSION}
kube-controller-manager-amd64:${KUBE_VERSION}
kube-apiserver-amd64:${KUBE_VERSION}
pause:${KUBE_PAUSE_VERSION}
etcd-amd64:${ETCD_VERSION}
coredns:${DNS_VERSION})

for imageName in ${images[@]}
do
  tagName=${imageName%%:*}
  docker pull $ALIYUN_URL:$tagName
  docker tag $ALIYUN_URL:$tagName $GCR_URL/$imageName
  docker rmi $ALIYUN_URL:$tagName
done
