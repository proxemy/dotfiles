#!/usr/bin/env bash

# This script take a single image or folder to decend, creates new versions of
# images and replaces the original, when the new ones are smaller.


set -euo pipefail


SOURCE=${1:-$ARG1_SOURCE_FOLDER_OR_IMAGE_FILE}
BASE_DIR=$(dirname "$SOURCE")
FFMPEG_ARGS=${2:-"-qscale:v 2"}
SOURCE_FILES=() # poplated below


if ! [[ -d "$SOURCE" || -f $SOURCE ]]; then
	echo Source file or folder does not exist: "$SOURCE"
	exit 1
fi


on_exit(){
	echo Cleaning up tmp dir: "${TMP_DIR:-''}"
	test -d "${TMP_DIR:-''}" && rm -rf "$TMP_DIR"
}
trap on_exit EXIT
TMP_DIR="${3:-$(mktemp -dp /dev/shm)}"


if [[ -f "$SOURCE" ]]; then
	FIND_NAME="$(basename "$SOURCE")"
else
	FIND_NAME="*"
fi

# because of weird file name characters, find results and bash arrays/loops
# dont work well together, so we need to separate array items with null bytes
while IFS= read -r -d $'\0'; do
	mime_type=$(file --mime-type "$REPLY")
	if [[ "$mime_type" =~ ": image" ]]; then
		SOURCE_FILES+=("$REPLY")
	fi
done < <(find "$BASE_DIR" -iname "$FIND_NAME" -type f -print0)


if [[ ${#SOURCE_FILES[@]} -le 0 ]]; then
	echo No viable image candidates found
	exit 1
fi


echo Found ${#SOURCE_FILES[@]} valid targets
read -p "Continue? [Y/n]" -a cont -n 1
if ! [[ "${cont:-"Y"}" =~ ^Y|y$ ]]; then
	exit 0
fi


for src_f in "${SOURCE_FILES[@]}"; do

	if ! [[ -f "$src_f" ]]; then
		echo FATAL error, found source file does not exists: "$src_f"
		exit 1
	fi

	echo -n Processing: "$src_f"

	base_name=$(basename "$src_f")

	tmp_f=$(mktemp -p "$TMP_DIR" -t XXX."$base_name")

	ret=$(ffmpeg -y -loglevel error -i "$src_f" $FFMPEG_ARGS "$tmp_f")

	size_src=$(du -b "$src_f" | cut -f1)
	size_tmp=$(du -b "$tmp_f" | cut -f1)

	if [[ $ret -ne 0 ]] || [[ $size_tmp -le 0 ]]; then
		echo -e \nCompression failed
		continue
	fi

	if [[ $size_tmp -lt $size_src ]]; then
		echo -e " ... replacing!"
		cp "$tmp_f" "$src_f"
	else
		echo
	fi
done

echo Done
