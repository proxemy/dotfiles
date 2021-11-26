#!/usr/bin/env sh

set -eo pipefail

interface="$1"

ip a show "$interface" 1>&- || exit 1

rnd_mac=$(echo "$RANDOM" | md5sum | head -c 12 | sed 's/../:&/2g')

echo random mac: "$rnd_mac"

sudo ip link set "$interface" down
sudo ip link set "$interface" address "$rnd_mac"
sudo ip link set "$interface" up

echo set mac: $(ip address show "$interface" | grep ether)
