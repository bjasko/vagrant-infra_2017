#!/bin/bash

# it's usually a good idea to exit upon error
set -e

# your connection parameters
user=vagrant
server=${SERVER_IP:-192.168.56.150}

localPort=80
remotePort=8201

# some stuff autossh needs to know
AUTOSSH_SERVER_ALIVE_INTERVAL=30
AUTOSSH_SERVER_ALIVE_COUNT=2

export AUTOSSH_PATH=$(pwd)/do_ssh
echo "starting ssh from this location: $AUTOSSH_PATH, connecting to server $server"
 
export AUTOSSH_POLL=30
export AUTOSSH_GATETIME=0
export AUTOSSH_LOGFILE="/tmp/autossh.log"

# clean up log file on start
touch "${AUTOSSH_LOGFILE}"
rm "${AUTOSSH_LOGFILE}" || true

BACKGROUND=-f
TUNNEL_ONLY=-N
autossh $BACKGROUND -M 0 \
  -o "ExitOnForwardFailure=yes" \
  -o "ServerAliveInterval=${AUTOSSH_SERVER_ALIVE_INTERVAL}" \
  -o "ServerAliveCountMax=${AUTOSSH_SERVER_ALIVE_COUNT}" \
  -A ${user}@${server} \
  $TUNNEL_ONLY -R ${remotePort}:localhost:${localPort}


echo "monitor:"
echo "tail -f /tmp/autossh.log"

