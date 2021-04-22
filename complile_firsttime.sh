#!/bin/bash

base=/opt/edumeet
tmp_name=edumeet-osu-build
source .env.dev

#IF not set node version in .env file
[ -z "$NODE_ENV" ] || NODE_ENV=14-slim



echo Git clone if not yet
[ -d './edumeet-osu'  ] && echo Skipping.... || git clone https://github.com/osuru/edumeet-osu

echo Try to start/create container \"$tmp_name\" if not yet
#docker container rm $tmp_name
img=$(docker image ls | grep "$tmp_name")

#[ -z "$img" ] && docker create  -it --name $tmp_name --env-file=./.env -v $(pwd)/edumeet-osu:$base node:$NODE_VER  || echo Already exists
[ -z "$img" ] ||  echo Already exists

echo Prepare container if not yet
docker container rm $tmp_name-tmp1 >/dev/null 2>&1  || echo Clean old success
[ -z "$img" ]  && (docker run --name $tmp_name-tmp1  -it  --env-file=./.env -v $(pwd)/edumeet-osu:$base node:$NODE_ENV sh -c \
"apt-get update &&\
apt-get install -y git build-essential python bash make" && \
docker commit $tmp_name-tmp1 $tmp_name && docker container rm $tmp_name-tmp1  >/dev/null 2>&1 )


echo Run npm install and build  on app
#[ -d './edumeet-osu/node_modules'  ] && echo Skipping....  || \
docker run   -it --rm --env-file=./.env -v $(pwd)/edumeet-osu:$base $tmp_name sh -c \
"cd $base/app && ([ -d './node_modules' ] || npm install) && npm run-script build "


echo Run npm install on server
[ -d './edumeet-osu/server/node_modules'  ] && echo Skipping....  || \
echo Run npm install server
docker run  -it --rm  --env-file=./.env -v $(pwd)/edumeet-osu:$base $tmp_name sh -c "cd $base/server && npm install"

echo Ready for start