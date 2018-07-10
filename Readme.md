# mssql_redis_docker

This repo contains a simplest docker configuration for convenient developing.

## Before start

1. Install [docker](https://docker.com)
2. Open cmd/ps and go to repo root directory
3. Run `docker-compose build`

## Start

1. Run command: `docker-compose up`
1. ...
1. Profit!

Also you can work with containers separately for example:

```bat
docker-compose up mssql
docker-compose restart redis
```

After run you can see logs of the running service (or logs both of them).

For gracefully stopping just press `CTRL+C`.

## Description

In containers for convenience and saving a persistent data, provides configs, entrypoint logs and the data itself in `/data` directory.  
When you first start the container mssql it will create the file `/data/mssql-sa.pw.txt` with
a random password for the user **SA**, subsequent runs will use it.  
Configs `/sqlserver/data/var/opt/mssql/mssql.conf` and `/redis/data/etc/redis/redis.conf` can be changed, changed values will be used at the next start of the container.