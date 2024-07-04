#!/usr/bin/env bash

set -euo pipefail

echo Start

#TMP="${TMP:-/dev/shm}"
SOURCE="${1:-'\$1'}"
TARGET="${2:-'\$2'}"
OFFSET=0
SIZE="${SIZE:-0}"


#test -d "$TMP" || { echo "Temp $TMP directory not found"; exit 1; }
test -f "$SOURCE" || { echo "SOURCE (\$1) file not found"; exit 1; }
test -f "$TARGET" || { echo "TARGET (\$2) file not found"; exit 1; }
test "$SIZE" -ne 0 || { echo "\$SIZE cannot be zero/undefined"; exit 1; }
[ "$SOURCE" != "$TARGET" ] || { echo "Target and source file cannot be identical"; exit 1; }


#TMP=$(mktemp -dp "$TMP")
#on_exit() {
	#echo Done;
	#rm -rf "$TMP"
	#history -d 1
#}
#trap on_exit EXIT ERR


echo -n "Analyzing source file "
hex_dump=$(xxd -p "$SOURCE" | tr -d '\n')
for i in $(seq 0 500); do
	echo -n "."
	sha1=$(head --byte=+"$i" "$SOURCE" | sha256sum -b | cut -f1 -d' ')
	if [[ "$hex_dump" =~ "$sha1" ]]; then
		OFFSET=$(($i + 32))
		break
	fi
done
echo

if [[ $OFFSET -eq 0 ]]; then
	echo Could not find offest in target file "$TARGET".
	exit 1
fi


echo "Writing target file ..."
if [[ $SIZE -gt 0 ]]; then
	echo Adding ...
	{
		head --bytes="$OFFSET" "$SOURCE";
		head --bytes="$SIZE" < /dev/urandom;
		tail --bytes=+$(("$SIZE" + 1)) "$SOURCE";
	} > "$TARGET"
elif [[ $SIZE -lt 0 ]]; then
	echo Removing ...
	{
		head --bytes=$(( "$OFFSET" * -1 )) "$SOURCE";
		tail --bytes=+$(( "$SIZE" * -1 + 1 )) "$SOURCE"
	} > "$TARGET"
fi

echo Done
