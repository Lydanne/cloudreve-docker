FROM centos
LABEL maintainer="wm 15804854160@163.com"
WORKDIR /core
COPY ./src ./
RUN chmod +x ./bin/cloudreve && mkdir -p ./data ./db
RUN yum install -y make
RUN cd ./aria2 && make install
CMD /core/bin/cloudreve -c ./etc/conf.ini \
  && /bin/aria2c --conf /core/aria2/conf/aria2.conf
EXPOSE 83

# docker build -t cloudreve .