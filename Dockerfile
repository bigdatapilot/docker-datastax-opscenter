FROM phusion/baseimage:0.9.15

MAINTAINER MAINTAINER Dominique Ronde <dominique.ronde@codecentric.de>

# Install wget
RUN apt-get update
RUN apt-get upgrade -y -qq
RUN apt-get install -y -qq wget

# Install pyton

RUN apt-get install -y -qq python-dev python-setuptools
RUN easy_install pip


# Download and extract OpsCenter
RUN mkdir /opt/opscenter
RUN wget -O - http://downloads.datastax.com/community/opscenter-5.1.0.tar.gz | tar xzf - --strip-components=1 -C "/opt/opscenter"

ADD	. /src

# Copy over daemons
RUN mkdir -p /etc/service/opscenter;
RUN cp /src/run /etc/service/opscenter/
RUN ln -s /opt/opscenter/log /var/log/opscenter

# Expose ports
EXPOSE 8888

WORKDIR /opt/opscenter

CMD ["/sbin/my_init"]

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
