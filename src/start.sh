#!/bin/bash
if [ ! -f "/core/etc/conf.ini" ];then
echo "文件不存在"
echo "[Database]" > /core/etc/conf.ini
echo "DBFile = /core/db/cloudreve.db" >> /core/etc/conf.ini
fi
/bin/chmod +x /core/bin/cloudreve
nohup /bin/aria2c --conf /core/aria2/conf/aria2.conf > /core/log/aria2.log 2>&1 &
/core/bin/cloudreve -c /core/etc/conf.ini > /core/log/cloudreve.log