FROM ubuntu:trusty

MAINTAINER David Christensen <randomparity@gmail.com>

ENV LAST_UPDATE_SUPERVISOR 2015-01-16

# Remove error messages like "debconf: unable to initialize frontend: Dialog":
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Update image and install tools
RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ trusty universe multiverse" >> \
    /etc/apt/sources.list && \
    echo "deb http://us.archive.ubuntu.com/ubuntu/ trusty-updates universe multiverse" >> \
    /etc/apt/sources.list && \
    apt-get -q update && \
    apt-get -qy upgrade && \
    apt-get -qy install software-properties-common supervisor wget git

# Configure image for supervisord operation
RUN mkdir -p /var/log/supervisor && \
    mkdir -p /etc/supervisor/conf.d

# Don't clean the apt repository here, it might be needed
# by users of this image.  Let them clean it up. :-)

# Create a user to match the host OS for file access (e.g. network share)
ENV BASE_USER sysadmin
ENV BASE_GROUP sysadmin
ENV BASE_USER_UID 1000
ENV BASE_USER_GID 1000
RUN addgroup --gid $BASE_USER_GID $BASE_GROUP && \
    adduser --disabled-password --uid $BASE_USER_UID \
    --gid $BASE_USER_GID --gecos "" $BASE_USER

# Copy the supervisord configuration file into the container
COPY supervisor.conf /etc/supervisor.conf

# Users of this image SHOULD NOT specify "CMD" or "ENTRYPOINT" in 
# their Dockerfiles.
CMD [ "/usr/bin/supervisord", "-c", "/etc/supervisor.conf" ]
