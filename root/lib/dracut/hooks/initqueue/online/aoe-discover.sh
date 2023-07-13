#! /usr/bin/bash

logger -t "aoe-discover" "Link up"
if [[ -e /dev/etherd/discover ]]; then
    echo > /dev/etherd/discover
    logger -t "aoe-discover" "Discover triggered"
fi
