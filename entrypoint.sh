#!/bin/sh

set -e

/opt/ecr-update.sh

echo "0 */12 * * * /bin/sleep \$(( \$\$ \% 21600 )); /opt/ecr-update.sh && /opt/swarm-update.sh 2>&1" > /var/spool/cron/crontabs/ecr-update-crontab

chmod +x /var/spool/cron/crontabs/ecr-update-crontab

touch /var/log/cron/cron.log
crond -s /var/spool/cron/crontabs -f -L /var/log/cron/cron.log "$@"