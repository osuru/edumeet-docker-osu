#!/bin/sh 

echo "Container starting up..." 
set -e 

env
cd ${BASEDIR}/${EDUMEET}/server
DEBUG=* node ${BASEDIR}/${EDUMEET}/server/server.js 
exec "$@"
