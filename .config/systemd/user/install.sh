#!/usr/bin/env bash

set -eux

sudo find /etc/systemd -iname 'steam-guard.*' -delete
sudo find /lib/systemd -iname 'steam-guard.*' -delete

UNITS=( $HOME/.config/systemd/user/*.{service,timer} )

systemd-analyze verify ${UNITS[@]}

sudo chown root:root ${UNITS[@]}
sudo chmod u+rw-x,go+r-wx ${UNITS[@]}

# it appears systemd does not allow user unit installed system wide, thus copy
sudo cp ${UNITS[@]} /lib/systemd/system

sudo systemctl enable --system --now steam-guard.service
sudo systemctl enable --system --now steam-guard.timer

sudo systemctl daemon-reload

systemctl is-enabled steam-guard.timer
systemctl is-active steam-guard.timer
