#!/bin/bash
# path=$(readlink -f "$(dirname "$0")")
chmod 775 ./shell/*
\cp -f ./shell/* /bin/
echo "安装shell成功"