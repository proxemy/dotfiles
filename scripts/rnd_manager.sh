#!/usr/bin/env bash

set -euo pipefail


on_exit()
{
	echo "Done"
	echo -e "\x44\x4f\x4e\x54\x20\x46\x4f\x52\x47\x45\x54\x20\x54\x4f\x20\x43\x4c\x45\x41\x52\x20\x48\x49\x53\x54\x4f\x52\x59 \x57\x49\x54\x48"
	echo -e "\x2\x73\x6f\x75\x72\x63\x65\x20\x63\x6c\x65\x61\x72\x5f\x68\x69\x73\x74\x6f\x72\x79\x2e\x73\x68"
}
trap on_exit EXIT ERR


echo Start

SOURCE="${1:-'\$1'}"
TARGET="${2:-'\$2'}"
OFFSET=0
SIZE="${SIZE:-0}"


test -f "$SOURCE" || { echo "SOURCE (\$1) file not found"; exit 1; }
test "$SIZE" -ne 0 || { echo "\$SIZE cannot be zero/undefined"; exit 1; }
[ "$SOURCE" != "$TARGET" ] || { echo "Target and source file cannot be identical"; exit 1; }

if [ -f "$TARGET" ]; then
	read -p "Target file '$TARGET' already exists! Overwrite? [y/N]" inp
	if [[ ! "y|Y" =~ "$inp" ]]; then
		echo Aborting
		exit
	fi
fi


echo -n "Analyzing source file "
hex_dump=$(xxd -p "$SOURCE" | tr -d '\n')
for i in $(seq 0 500); do
	echo -n "."
	sha=$(head --byte=+"$i" "$SOURCE" | sha256sum -b | cut -f1 -d' ')
	if [[ "$hex_dump" =~ "$sha" ]]; then
		OFFSET=$(($i + 32))
		echo -e "\nFound hash at '$i': $sha"
		break
	fi
done

if [[ $OFFSET -eq 0 ]]; then
	echo -e "\nCould not dertermine offest in target file: $TARGET".
	exit 1
fi


echo "Writing target file ..."
if [[ $SIZE -gt 0 ]]; then
	echo Adding ...
	{
		head --bytes="$OFFSET" "$SOURCE";
		head --bytes="$SIZE" < /dev/urandom;
		tail --bytes=+$(("$OFFSET" + 1)) "$SOURCE";
	} > "$TARGET"
elif [[ $SIZE -lt 0 ]]; then
	echo Removing ...
	{
		head --bytes=$(( "$OFFSET" )) "$SOURCE";
		tail --bytes=+$(( "$OFFSET" + ("$SIZE" * -1) + 1 )) "$SOURCE"
	} > "$TARGET"
fi
