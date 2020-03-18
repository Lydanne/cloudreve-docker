FROM centos
LABEL maintainer="wm 15804854160@163.com"
WORKDIR /core
COPY ./src ./
RUN chmod +x ./bin/cloudreve
RUN yum install -y make
RUN cd ./aria2 && make install
RUN aria2c --conf /core/aria2/conf/aria2.conf
CMD ./bin/cloudreve -c ./etc/conf.ini > ./etc/log.txt
EXPOSE 83

# docker build -t cloudreve ./src