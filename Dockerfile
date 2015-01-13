FROM ubuntu:trusty

MAINTAINER David Christensen <randomparity@gmail.com>

ENV LAST_UPDATE_SUPERVISOR 2015-01-12

# Remove error messages like "debconf: unable to initialize frontend: Dialog":
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Fetch/install latest updates and install needed tools
RUN apt-get -q update && \
    apt-get -qy upgrade  && \
    apt-get -qy install supervisor && \
    mkdir -p /var/log/supervisor && \
    mkdir -p /etc/supervisor/conf.d

# Create a user to match the host OS for file access
RUN addgroup --gid 1000 sysadmin && \
    adduser --disabled-password --uid 1000 --gid 1000 --gecos "" sysadmin

# Copy the supervisord configuration file into the container
COPY supervisor.conf /etc/supervisor.conf

# Run Supervisord in the foreground as "root"
CMD [ "/usr/bin/supervisord", "-c", "/etc/supervisor.conf" ]
