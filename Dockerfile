FROM centos
LABEL maintainer="wm 15804854160@163.com"
WORKDIR /core
COPY ./src ./
RUN mkdir ./uploads ./db ./log
RUN yum install -y make
RUN cd ./aria2 && make install
CMD /bin/bash /core/start.sh
EXPOSE 83

# docker build -t cloudreve .