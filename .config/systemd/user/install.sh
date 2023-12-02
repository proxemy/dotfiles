#!/usr/bin/env bash

set -eux

UNITS=( $HOME/.config/systemd/user/*.{service,timer} )

for u in ${UNITS[@]}; do
	systemd-analyze verify "$u"
	sudo systemctl stop $(basename "$u") || true
	sudo systemctl disable $(basename "$u") || true
	sudo systemctl enable $(realpath "$u")
	#sudo systemctl start $(basename "$u")
done

#sudo systemctl daemon-reload

systemctl is-enabled steam-guard.timer
systemctl is-active steam-guard.timer
