#!/usr/bin/env bash

# curl https://github.com/proxemy/dotfiles/blob/master/scripts/init_dotfiles.sh | sh

set -xeuo pipefail
shopt -s expand_aliases

export PWD=$HOME

DOTFILES_REPO_URL='https://github.com/proxemy/dotfiles'
BASH_ALIAS_URL='https://raw.githubusercontent.com/proxemy/dotfiles/master/.bash_aliases'
TMP_GIT_DIR=$(mktemp --directory --dry-run --tmpdir="$PWD")

source <(curl -s "$BASH_ALIAS_URL" | grep -E '^alias dotfiles=')

dotfiles clone \
	--bare \
	"$DOTFILES_REPO_URL" \
	"$TMP_GIT_DIR"

trap 'rm -rf "$TMP_GIT_DIR"' EXIT

mv "$TMP_GIT_DIR" "$HOME"/.dotfiles

dotfiles reset --hard
