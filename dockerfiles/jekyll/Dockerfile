FROM mckoss/sshd

RUN apt-get install -y git

# Are these dependencies really needed for Ruby?
RUN apt-get install -y git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev
RUN apt-get install -y sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties

RUN cd /tmp; wget http://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.gz
RUN cd /tmp; tar -xzvf ruby-2.1.2.tar.gz
RUN cd /tmp/ruby-2.1.2/; ./configure; make; make install

RUN gem install bundler
RUN gem install jekyll

EXPOSE 22
