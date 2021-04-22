#!/bin/sh

base=/opt/edumeet

echo Get container
container=$( docker ps --format {{.Names}} |grep edumeet_ | tail -n 1)

echo Container == $container

echo Run bash for debug
docker exec -it $container bash

