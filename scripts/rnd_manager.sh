#!/usr/bin/env bash

set -euo pipefail


SOURCE="${1:-$ARG1_SOURCE_FILE}"
TARGET="${2:-$ARG2_TARGET_FILE}"
TMP_TARGET=$(mktemp "$TARGET".XXX)
OFFSET=0
SIZE=0


on_exit() {
	test -f "$TMP_TARGET" && rm "$TMP_TARGET"
}
trap on_exit ERR EXIT


test -f "$SOURCE" || { echo "SOURCE (\$1) file not found"; exit 1; }
[ "$SOURCE" != "$TARGET" ] || { echo "Target and source file cannot be identical"; exit 1; }
read -r -p "Please enter size: " SIZE
test "$SIZE" -ne 0 || { echo "\$SIZE cannot be zero/undefined"; exit 1; }

SOURCE_SIZE=$(du -b "$SOURCE" | cut -f1)
if [ $(($SIZE * 2)) -ge $SOURCE_SIZE ]; then
	echo "\$SIZE cannot be larger then 1/2 of source file size in bytes: $SOURCE_SIZE" >&2
	exit 1
fi

if [ -f "$TARGET" ]; then
	read -p "Target file '$TARGET' already exists! Overwrite? [y/N]"
	if [[ ! "y|Y" =~ $REPLY ]]; then
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
	} > "$TMP_TARGET"
elif [[ $SIZE -lt 0 ]]; then
	echo "Removing ... $SIZE bytes"
	{
		head --bytes=$(( "$OFFSET" )) "$SOURCE";
		tail --bytes=+$(( "$OFFSET" + ("$SIZE" * -1) + 1 )) "$SOURCE"
	} > "$TMP_TARGET"
fi

if [[ -f "$TARGET" ]] && [[ $SIZE -gt 0 ]]; then
	TARGET_TAIL_HASH=$(tail --bytes=50 "$TARGET" | md5sum | cut -d' ' -f1)
	TMP_TARGET_TAIL_HASH=$(tail --bytes=50 "$TMP_TARGET" | md5sum | cut -d' ' -f1)

	if [[ "$TARGET_TAIL_HASH" == "$TMP_TARGET_TAIL_HASH" ]]; then
		echo ERROR: You should not add random bytes to identical source/target files. >&2
		echo It would reveal the secret offset. Aborting! >&2
		exit 1
	fi
fi

cp "$TMP_TARGET" "$TARGET"
