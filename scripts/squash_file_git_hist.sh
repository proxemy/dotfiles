#!/usr/bin/env bash

# to pull diverting commit history:
# git reset --hard origin/master


set -xeuo pipefail

test -f $TARGET_FILE
test -d $GIT_DIR
test -d $WORK_TREE

alias git="git --git-dir=$GIT_DIR --work-tree=$WORK_TREE"

tmp=$(mktemp -d -p /dev/shm)
cleanup() { rm -rf "$tmp"; }
trap cleanup EXIT

cp --archive "$TARGET_FILE" "$tmp"/"$TARGET_FILE"

git filter-branch \
	--force \
	--prune-empty \
	--index-filter \
	"git rm --cached --ignore-unmatch \"$TARGET_FILE\" HEAD" \
	-- --all

cp --archive "$tmp"/"$TARGET_FILE" "$TARGET_FILE"

git add "$TARGET_FILE"
git commit -m "Squashed history."
