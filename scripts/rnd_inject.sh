#!/usr/bin/env bash

set -euo pipefail

# TODOs:
#trap EXIT histors -d -1
#APPEND_COUNT > file magic number
#file check in if;then below: does *.truncated exist?
#get rid of new.file

test -f "$TARGET_FILE"
test "$APPEND_COUNT" -ne 0

du -b "$TARGET_FILE"

if [[ APPEND_COUNT -gt 0 ]]; then
	{
		head --bytes="$APPEND_COUNT" "$TARGET_FILE";
		head --bytes="$APPEND_COUNT" < /dev/urandom;
		tail --bytes=+$(("$APPEND_COUNT" + 1)) "$TARGET_FILE";
	} > new.file
elif [[ APPEND_COUNT -lt 0 ]]; then
	{
		head --bytes=$(( "$APPEND_COUNT" * -1 )) "$TARGET_FILE";
		tail --bytes=+$(( "$APPEND_COUNT" * -2 + 1 )) "$TARGET_FILE"
	} > new.file
fi
