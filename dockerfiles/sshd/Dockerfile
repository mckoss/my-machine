FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y openssh-server
RUN useradd -m service
RUN echo 'service:service' | chpasswd
ADD start-service /usr/local/bin/start-service

EXPOSE 22

CMD start-service
