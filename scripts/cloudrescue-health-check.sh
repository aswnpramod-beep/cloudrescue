#!/bin/bash

LOCKFILE="/var/run/cloudrescue-recovery.lock"

if [ -e "$LOCKFILE" ]; then
    echo "$(date): Recovery already in progress. Skipping duplicate execution."
    exit 0
fi

touch "$LOCKFILE"

trap 'rm -f "$LOCKFILE"' EXIT

HEALTH_URL="http://localhost/health"
RECOVERY_SCRIPT="/usr/local/bin/cloudrescue-recovery.sh"

if curl -fs "$HEALTH_URL" > /dev/null; then
    echo "$(date): CloudRescue application is HEALTHY"
    exit 0
else
    echo "$(date): CloudRescue application is UNHEALTHY"
    echo "$(date): Starting automated recovery"

    "$RECOVERY_SCRIPT"

    sleep 5

    if curl -fs "$HEALTH_URL" > /dev/null; then
        echo "$(date): CloudRescue recovery successful"
        exit 0
    else
        echo "$(date): CloudRescue recovery FAILED"
        exit 1
    fi
fi

