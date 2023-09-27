#!/usr/bin/env bash

set -xeuo pipefail

target_file="$1"
tmp=$(mktemp -d -p /dev/shm)

cleanup()
{
	rm -rf "$tmp"
}
trap cleanup EXIT

cp --archive "$target_file" "$tmp"/

git filter-branch \
	--force \
	--prune-empty \
	--index-filter \
	"git rm --cached --ignore-unmatch \"$target_file\" HEAD" \
	-- --all

cp -a "$tmp"/"$target_file" .

git add "$target_file"
git commit -m "Squashed history"

