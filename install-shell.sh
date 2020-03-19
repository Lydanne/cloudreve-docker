#!/bin/bash
path=$(readlink -f "$(dirname "$0")")
chmod 775 ${path}/shell/*
\cp -f ${path}/shell/* /bin/
echo "安装shell成功"