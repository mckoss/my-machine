#!/bin/bash
# docker-gc --- Remove stopped docker containers

RUNNING=$(docker ps -q)
ALL=$(docker ps -a -q)

for container in $ALL ; do
    [[ "$RUNNING" =~ "$container" ]] && continue
    echo Removing container: $(docker rm $container)
done
