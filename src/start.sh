#!/bin/bash
nobup /bin/aria2c --conf /core/aria2/conf/aria2.conf > /core/log/aria2.log 2>&1 &
/core/bin/cloudreve -c ./etc/conf.ini