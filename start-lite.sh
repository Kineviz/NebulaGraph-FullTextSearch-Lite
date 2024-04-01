#!/bin/bash
# Nabula Graph Studio 
## http://localhost:7001   
## 默认用户名为 root，密码为 nebula
## Host:Port graphd:9669

DATA_PATH=/mnt/f/wsl-docker-containers/nebula-docker-compose/

SYSTEM="$(uname -o)"
if [ $SYSTEM == "Msys" ]
then
    export MSYS2_ARG_CONV_EXCL="*"
    DATA_PATH="$(cygpath -w $DATA_PATH)"
    echo "Msys"
else
    echo "GNU/Linux"
fi




# docker network prune -f

## 如果不存在则创建nebula-net, 并指定bridge模式, 并且指定子网和IP区域，
### 由于Nebula 全文索引服务只支持使用IP地址访问，所以需要指定子网和网关
if [ -z "$(docker network ls --filter name=nebula-net -q)" ]
then
    echo "create network"
    docker network create -d bridge --subnet=172.10.10.0/24 --gateway=172.10.10.1 nebula-net
fi

export DATA_DIR=./data

docker-compose -f ./docker-compose-lite.yaml up -d --remove-orphans