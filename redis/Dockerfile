FROM redis:latest
MAINTAINER Vladimir Chirikov <vovanchig@gmail.com>

# Fix some issues with APT packages.
# See https://github.com/dotcloud/docker/issues/1024
RUN dpkg-divert --local --rename --add /sbin/initctl && ln -sf /bin/true /sbin/initctl

## Replace the 'ischroot' tool to make it always return true.
## Prevent initscripts updates from breaking /dev/shm.
## https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/
## https://bugs.launchpad.net/launchpad/+bug/974584
RUN dpkg-divert --local --rename --add /usr/bin/ischroot && ln -sf /bin/true /usr/bin/ischroot

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

# use Moscow time
RUN ln -fs /usr/share/zoneinfo/Europe/Moscow /etc/localtime


RUN    mkdir -p /data/database \
    && mkdir -p /data/logs/ \
    && mkdir -p /data/etc/ \
    && chmod -R 777 /data

WORKDIR /data

EXPOSE 6379
# volume
VOLUME ["/data"]

CMD ["/bin/bash", "/data/start.sh"]
