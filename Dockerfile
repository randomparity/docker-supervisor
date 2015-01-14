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

# Don't clean the apt repository here, it likely will be needed
# by users of this image.  Let them clean it up. :-)

# Create a user to match the host OS for file access (e.g. network share)
RUN addgroup --gid 1000 sysadmin && \
    adduser --disabled-password --uid 1000 --gid 1000 --gecos "" sysadmin

# Copy the supervisord configuration file into the container
COPY supervisor.conf /etc/supervisor.conf

# Run supervisord in the foreground as "root".  Users of this image
# SHOULD NOT specify "CMD" or "ENTRYPOINT" in their Dockerfiles.  I
# chose CMD here to make it easier to enter a running container with
# a shell for debugging.
CMD [ "/usr/bin/supervisord", "-c", "/etc/supervisor.conf" ]
