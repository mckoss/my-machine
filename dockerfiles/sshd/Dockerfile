FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y openssh-server
RUN echo 'root:password' | chpasswd
RUN useradd --create-home --shell /bin/bash --gid sudo service
RUN echo 'service:service' | chpasswd
RUN mkdir -p /home/service/.ssh
ADD start-service /usr/local/bin/start-service
ADD authorized_keys /home/service/.ssh/authorized_keys

EXPOSE 22

CMD start-service
