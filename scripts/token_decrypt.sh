#!/bin/sh

set -eu

[ $# -ne 2 ]	&& echo "USAGE: 'token_decrypt.sh FILE.enc FILE.dec'" && exit 1
[ ! -f "$1" ]	&& echo "Couldn't find encrypted token file:" "$1" && exit 1
[ -f "$2" ]		&& echo "Target decrypted token file already exists:" "$2" && exit 1

sudo cryptsetup plainOpen -c aes-cbc-essiv:sha256 -s 256 -r -d - "$1" token_dev

if [ ! -z "$?" ]; then
	sudo cp /dev/mapper/token_dev "$2"
	sudo chmod go-rwx "$2"
	sudo chown $USER "$2"
	sudo cryptsetup close token_dev
else
	echo "Failed to open cryptsetup mapper device. Return:" "$?"
fi
