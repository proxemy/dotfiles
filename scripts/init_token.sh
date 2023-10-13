#!/usr/bin/env rbash

set -Eeuo pipefail


usage() { echo "USAGE: ./$(basename $0) [token.enc] [token.dec]"; }
trap usage ERR EXIT
[ $# -ne 2 ] && exit 1

readonly enc=$1
readonly dec=$2

readonly SUDOERS_FILE=/etc/sudoers.d/keepassxc_$USER
readonly CRYPT_MAPPER_DEVICE=/dev/mapper/tmp_dev


[ ! -f "$enc" ] \
&& echo "Couldn't find encrypted token file:" "$enc" && exit 1
[ -f "$dec" ] \
&& echo "Target decrypted token file already exists:" "$dec" && exit 1
[ -f "$SUDOERS_FILE" ] \
&& echo "Excepted keepassxc sudoers file to not exist:" "$SUDOERS_FILE" && exit 1
[ -f "$CRYPT_MAPPER_DEVICE" ] \
&& echo "cryptsetup mapper device busy:" "$CRYPT_MAPPER_DEVICE" && exit 1


trap 'echo Missing Dependency!' ERR
type keepassxc
type cryptsetup
type sudo
trap -


on_exit()
{
	echo Cleanup
	sudo cryptsetup close $(basename "$CRYPT_MAPPER_DEVICE")
	sudo -K
}
trap on_exit EXIT


#if ! getent group keepassxc; then
sudo addgroup keepassxc || true

echo "$USER $HOSTNAME=(:keepassxc) NOPASSWD:NOEXEC:NOFOLLOW: /usr/bin/keepassxc" \
| sudo tee "$SUDOERS_FILE"

sudo visudo -sc "$SUDOERS_FILE" \
|| sudo rm "$SUDOERS_FILE"

sudo chmod a-rwx,ug+r "$SUDOERS_FILE"
sudo chown root:root "$SUDOERS_FILE"

sudo cryptsetup plainOpen \
	-c aes-cbc-essiv:sha256 \
	-s 256 \
	-r -d - "$enc" $(basename "$CRYPT_MAPPER_DEVICE")


sudo cp "$CRYPT_MAPPER_DEVICE" "$dec"
sudo echo Key file sha256 hash: $(sudo sha256sum "$dec")
sudo chmod a-rwx,g+r "$dec"
sudo chown root:keepassxc "$dec"
