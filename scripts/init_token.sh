#!/usr/bin/env bash

set -euo pipefail


test -f "${1:-$ARG_1_INPUT_TOKEN_NOT_DEFINED}"
test ! -f "${2:-$ARG_2_OUTPUT_TOKEN_NOT_DEFINED}"

SALT="0Ghra9a+OOBaysAjBG084VFqBGjnPGraS0w2ODxzRZ0Ygze6oyeX2yOmfbMKJ7wW0qpGKL7qptQM7F0MNkgez2CbC+7aLhrQOHKtB13UDLHhQemIQcoa8HIWT8UzNtkIG4IZlXS+RtuFB6oltF2+6DzkmQ0sggv1XMSAabTFHFU="
read -rp "Enter password:"
PW="$REPLY"
echo


sha_digest_binary() { echo -ne $(sha512sum --binary "$1" | cut -f1 -d' ' | sed 's/../\\x&/g'); }

sha_pw() { sha_digest_binary <(printf "$PW"); }
sha_salt() { sha_digest_binary <(printf "$SALT" | base64 --decode); }
sha_token() { sha_digest_binary "$1"; }


sha_digest_binary <(
	sha_pw;
	sha_salt;
	sha_pw;
	sha_token "$1";
) > "$2"

# inflate the output to 128 bytes
sha_digest_binary <(
	sha_token "$1";
	sha_pw;
	sha_salt;
	sha_pw;
) >> "$2"


echo "Result:"
sha256sum "$2"

chmod a-rwx,g+r "$2"
sudo chown root:keepassxc "$2"
