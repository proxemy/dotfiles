#!/usr/bin/env rbash

set -Eeuo pipefail


usage() { echo "USAGE: ./$(basename $0) [token.enc] [token.dec]"; }
trap usage ERR

readonly enc=${1:-$(exit 1)}
readonly dec=${2:-$(exit 1)}

readonly SUDOERS_KEEPASSXC=/etc/sudoers.d/keepassxc_$USER
readonly CRYPT_MAPPER_DEVICE=/dev/mapper/tmp_dev


[ ! -f "$enc" ] \
&& echo "Couldn't find encrypted token file:" "$enc" && exit 1
[ -f "$dec" ] \
&& echo "Target decrypted token file already exists:" "$dec" && exit 1
[ -f "$SUDOERS_KEEPASSXC" ] \
&& echo "Excepted keepassxc sudoers file to not exist:" "$SUDOERS_KEEPASSXC" && exit 1
[ -f "$CRYPT_MAPPER_DEVICE" ] \
&& echo "cryptsetup mapper device busy:" "$CRYPT_MAPPER_DEVICE" && exit 1


trap 'echo Missing Dependency!' ERR
type keepassxc
type cryptsetup
type su
trap '' ERR


on_exit()
{
	echo Cleanup
	sudo cryptsetup close $(basename "$CRYPT_MAPPER_DEVICE")
	sudo -K
}
trap on_exit EXIT


#if ! getent group keepassxc; then
sudo addgroup keepassxc

echo "$USER $HOSTNAME=(:keepassxc) NOPASSWD:SETENV:NOEXEC:NOFOLLOW: /usr/bin/keepassxc" \
| sudo tee "$SUDOERS_KEEPASSXC"

visudo -sc "$SUDOERS_KEEPASSXC" \
|| sudo rm "$SUDOERS_KEEPASSXC"

sudo chmod a-rwx,ug+r "$SUDOERS_KEEPASSXC"
sudo chown root:root "$SUDOERS_KEEPASSXC"

sudo cryptsetup plainOpen \
	-c aes-cbc-essiv:sha256 \
	-s 256 \
	-r -d - "$enc" $(basename "$CRYPT_MAPPER_DEVICE")


sudo cp "$CRYPT_MAPPER_DEVICE" "$dec"
sudo echo Key file sha256 hash: $(sudo sha256sum "$dec")
sudo chmod a-rwx,g+r "$dec"
sudo chown root:keepassxc "$dec"
