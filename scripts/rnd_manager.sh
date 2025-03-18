#!/usr/bin/env bash

set -euo pipefail


SOURCE="${1:-$ARG1_SOURCE_FILE}"
TARGET="${2:-$ARG2_TARGET_FILE}"
OFFSET=0
SIZE=0


test -f "$SOURCE" || { echo "SOURCE (\$1) file not found"; exit 1; }
[ "$SOURCE" != "$TARGET" ] || { echo "Target and source file cannot be identical"; exit 1; }
read -r -p "Please enter size: " SIZE
test "$SIZE" -ne 0 || { echo "\$SIZE cannot be zero/undefined"; exit 1; }

if [ -f "$TARGET" ]; then
	echo
	read -p "Target file '$TARGET' already exists! Overwrite? [y/N]" inp
	if [[ ! "y|Y" =~ "$inp" ]]; then
		echo Aborting
		exit
	fi
fi


echo -n "Analyzing source file "
hex_dump=$(xxd -p "$SOURCE" | tr -d '\n')
header_hash_size=32
for i in $(seq 0 500); do
	echo -n "."
	sha=$(head --byte=+"$i" "$SOURCE" | sha256sum -b | cut -f1 -d' ')
	if [[ "$hex_dump" =~ "$sha" ]]; then
		#OFFSET beyond KDBX header + SIZE
		OFFSET=$(($i + $header_hash_size + ${SIZE#-}))
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
	echo "Adding $SIZE bytes"
	{
		head --bytes="$OFFSET" "$SOURCE";
		head --bytes="$SIZE" < /dev/urandom;
		tail --bytes=+$(("$OFFSET" + 1)) "$SOURCE";
	} > "$TARGET"
elif [[ $SIZE -lt 0 ]]; then
	echo "Removing ... $SIZE bytes"
	{
		head --bytes=$(( "$OFFSET" )) "$SOURCE";
		tail --bytes=+$(( "$OFFSET" + ("$SIZE" * -1) + 1 )) "$SOURCE"
	} > "$TARGET"
fi
