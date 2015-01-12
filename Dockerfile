FROM ubuntu:trusty

MAINTAINER David Christensen <randomparity@gmail.com>

# Remove error messages like "debconf: unable to initialize frontend: Dialog":
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Fetch/install latest updates and install needed tools
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install supervisor && \
    mkdir -p /var/log/supervisor && \
    mkdir -p /etc/supervisor/conf.d

# Clean-up any unneeded files
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV HOME /root

# Copy the supervisord configuration file into the container
COPY supervisor.conf /etc/supervisor.conf

# Run Supervisord in the foreground as "root"
CMD [ "/usr/bin/supervisord", "-c", "/etc/supervisor.conf" ]
