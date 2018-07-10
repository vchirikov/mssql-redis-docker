#!/bin/bash
DEBUG=false
# For debug
[ "$DEBUG" == 'true' ] && set -x
start_pid=$$
# A wrapper to trap the SIGINT signal (Ctrl+C) and forwards it to the background worker
# In other words : traps SIGINT and SIGTERM signals and forwards them to the child process as SIGTERM signals

asyncRun() {
    "$@" &
    pid="$!"
    trap "echo -e '\nStopping PID $pid'; kill -SIGTERM $pid;" SIGINT SIGTERM

    # A signal emitted while waiting will make the wait command return code > 128
    # Let's wrap it in a loop that doesn't end before the process is indeed stopped
    while kill -0 $pid > /dev/null 2>&1; do
        wait
    done
    trap - SIGINT SIGTERM
    sleep .5
    [ "$DEBUG" == 'true' ] && ps -a
    echo -e '\n\nBackground process was stopped';
    echo -e "Stop a script PID $start_pid\n"
    kill -SIGTERM "$start_pid"
}

chmod -R 777 /data/
cp -rf /data/var/* /var/

SQL_ARGS=""
# create password if needed
if [ ! -f /data/mssql-sa-pw.txt ]; then
  sleep 0.5s  
  export SA_PASSWORD=`pwgen -c -n -1 12`
  #This is so the passwords show up in logs.
  echo $SA_PASSWORD > /data/mssql-sa-pw.txt
  export SQLSERVR_SA_PASSWORD=$SA_PASSWORD
  SQL_ARGS='--reset-sa-password --force-setup'
fi

# read password
export SA_PASSWORD=$(</data/mssql-sa-pw.txt)

echo mssql sa password: $SA_PASSWORD

# start services
asyncRun /opt/mssql/bin/sqlservr $SQL_ARGS & $@

if [ ! -f /data/logs/error.log ]; then
    touch /data/logs/error.log
    chmod 777 /data/logs/error.log
fi

tail -f /data/logs/error.log
#/bin/bash
