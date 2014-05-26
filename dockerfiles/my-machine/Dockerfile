FROM mckoss/sshd

RUN apt-get install -y man
RUN apt-get install -y git
RUN mkdir -p /home/service/src
RUN git clone http://github.com/mckoss/my-machine /home/service/src/my-machine
RUN chown -R service /home/service/src

EXPOSE 22
