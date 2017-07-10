#!/bin/sh

set -e

su - docker -s /bin/sh -c "REGION=$REGION /opt/ecr-update.sh"

echo "0 */12 * * * docker /bin/sleep \$(( \$\$ % 21600 )); REGION=$REGION /opt/ecr-update.sh && /opt/swarm-update.sh 2>&1" > /var/spool/cron/crontabs/docker

chmod +x /var/spool/cron/crontabs/docker
crond -c /var/spool/cron/crontabs -f "$@"