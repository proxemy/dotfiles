#!/usr/bin/env bash

set -eux

UNITS=( $HOME/.config/systemd/user/*.{service,timer} )

systemd-analyze verify --no-pager ${UNITS[@]}
sudo systemctl enable --now ${UNITS[@]}

# systemctl daemon-reload
