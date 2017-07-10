#!/bin/sh

set -e

aws ecr get-login --region $REGION > /tmp/login-raw
sed -r "s/ -e none//" /tmp/login-raw > /tmp/login-clean
chmod +x /tmp/login-clean

/tmp/login-clean

rm -f /tmp/login-*