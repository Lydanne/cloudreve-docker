#!/bin/bash
if [ ! -f "/core/etc/conf.ini" ];then
echo "文件不存在"
echo "[System]" > /core/etc/conf.ini
echo "Mode = master" >> /core/etc/conf.ini
echo "Listen = :83" >> /core/etc/conf.ini
echo "Debug = false" >> /core/etc/conf.ini
echo "[Database]" >> /core/etc/conf.ini
echo "DBFile = /core/db/cloudreve.db" >> /core/etc/conf.ini
fi
/bin/chmod +x /core/cloudreve
nohup /bin/aria2c --conf /core/aria2/conf/aria2.conf > /core/log/aria2.log 2>&1 &
/core/cloudreve -c /core/etc/conf.ini > /core/log/cloudreve.log