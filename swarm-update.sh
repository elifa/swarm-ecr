#!/bin/sh

set -e

docker service ls -q | xargs -t -n 1 docker service update -d --with-registry-auth