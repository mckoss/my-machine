FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y openssh-server

RUN echo 'root:password' | chpasswd

RUN useradd --create-home --shell /bin/bash --gid sudo service
RUN echo 'service:service' | chpasswd

RUN mkdir -p /home/service/.ssh
ADD authorized_keys /home/service/.ssh/authorized_keys
RUN chown service /home/service/.ssh/authorized_keys

RUN mkdir -p /root/.ssh
ADD authorized_keys /root/.ssh/authorized_keys

ADD start-service /usr/local/bin/start-service

EXPOSE 22

ENTRYPOINT start-service
