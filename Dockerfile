FROM centos
LABEL maintainer="wumacoder"
WORKDIR /core
COPY ./src ./
RUN mkdir ./uploads ./db ./log \ 
  & yum install -y make \
  & sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* \
  & sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
RUN cd ./aria2 && make install
CMD /bin/bash /core/start.sh
EXPOSE 83

# docker build -t cloudreve .