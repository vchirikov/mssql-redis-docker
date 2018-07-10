FROM  microsoft/mssql-server-linux:2017-latest
MAINTAINER Vladimir Chirikov <vovanchig@gmail.com>

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive
ENV ACCEPT_EULA Y
# Change if needed
ENV MSSQL_PID Developer
# use Moscow time
RUN ln -fs /usr/share/zoneinfo/Europe/Moscow /etc/localtime

RUN    mkdir -p /data/database \
       mkdir -p /data/logs \
       mkdir -p /data/dumps \
       mkdir -p /data/backups \
    && chmod -R 755 /data 

# RUN apt-get update && \
#     apt-get install -y curl pwgen && \
#     curl https://packages.microsoft.com/config/ubuntu/16.04/mssql-server-2017.list | tee /etc/apt/sources.list.d/mssql-server.list && \
#     apt-get update

RUN apt-get update && \
    apt-get install -y curl pwgen sudo && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | tee /etc/apt/sources.list.d/msprod.list && \
    apt-get update && \
    apt-get install -y mssql-tools unixodbc-dev

RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile

WORKDIR /data
EXPOSE 1433
# volume
VOLUME ["/data"]

## https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-configure-mssql-conf?view=sql-server-linux-2017

RUN /opt/mssql/bin/mssql-conf set sqlagent.enabled true 
RUN /opt/mssql/bin/mssql-conf set telemetry.customerfeedback false

# As telemetry the setting does not work, let's use the workaround below
RUN echo 127.0.0.1 settings-win.data.microsoft.com >> /etc/hosts
RUN echo 127.0.0.1 vortex.data.microsoft.com >> /etc/hosts

CMD ["/bin/bash", "/data/start.sh"]
