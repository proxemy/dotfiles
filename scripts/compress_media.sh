#!/usr/bin/env bash

# This script take a single image or folder to decend, creates new versions of
# images and replaces the original, when the new ones are smaller.


set -euo pipefail

renice -n 19 -p $BASHPID


SOURCE=${1:-"."} # default: current dir
BASE_DIR=$(dirname "$SOURCE")
DEBUG=${DEBUG:-0}
SOURCE_FILES=() # poplated below


if ! [[ -d "$SOURCE" || -f $SOURCE ]]; then
	echo Source file or folder does not exist: "$SOURCE"
	exit 1
fi


while getopts "f:t:d" o; do
	case "$o" in
		f)
			FFMPEG_ARGS_EXTRA="$OPTARG"
			;;
		t)
			TMP_DIR="$OPTARG"
			;;
		d)
			DEBUG=1
			;;
	esac
done


on_exit(){
	echo Cleaning up tmp dir: "${TMP_DIR:-''}"
	test -d "${TMP_DIR:-''}" && rm -rf "$TMP_DIR"
}
trap on_exit EXIT
TMP_DIR="$(mktemp -dp ${TMP_DIR:-/dev/shm})"


if [[ -f "$SOURCE" ]]; then
	SOURCE_FILES+=("$SOURCE")
elif [[ -d "$SOURCE" ]]; then
	BASE_DIR="$SOURCE"
	FIND_NAME="*"
else
	FIND_NAME="${SOURCE:-*}"
fi


if [[ ${#SOURCE_FILES[@]} -eq 0 ]]; then
	# because of weird file name characters, find results and bash arrays/loops
	# dont work well together, so we need to separate array items with null bytes
	while IFS= read -r -d $'\0'; do
		mime_type=$(file --mime-type "$REPLY")
		if [[ "$mime_type" =~ :\ image|:\ video ]]; then
			SOURCE_FILES+=("$REPLY")
		fi
	done < <(find "$BASE_DIR" -iname "$FIND_NAME" -type f -print0)
fi


if [[ ${#SOURCE_FILES[@]} -le 0 ]]; then
	echo No viable image candidates found
	exit 1
fi

echo Found ${#SOURCE_FILES[@]} valid targets
read -p "List candidates? [y/N]" -a cont -n 1
if [[ "${cont:-"N"}" =~ ^Y|y$ ]]; then
	printf '%s\n' "${SOURCE_FILES[@]}"
	#echo -e "\n"${SOURCE_FILES[@]}
	echo
fi

read -p "Continue? [Y/n]" -a cont -n 1
if ! [[ "${cont:-"Y"}" =~ ^Y|y$ ]]; then
	exit 0
fi


FFMPEG_LOGLEVEL="error"
if [[ $DEBUG -ne 0 ]]; then
	FFMPEG_LOGLEVEL="info"
fi

FFMPEG_ARGS="-crf 23 -qscale:v 1.5 ${FFMPEG_ARGS_EXTRA:-}"


for src_f in "${SOURCE_FILES[@]}"; do

	if ! [[ -f "$src_f" ]]; then
		echo FATAL error, found source file does not exists: "$src_f"
		exit 1
	fi

	echo -n Processing: "$src_f"

	base_name=$(basename "$src_f")

	if ! [[ "$base_name" =~ \..{3,4} ]]; then
		echo -e "no file extension found, but required by ffmpeg\n---SKIPPING FILE: ${base_name}"
		continue
	fi

	tmp_f=$(mktemp -p "$TMP_DIR" -t "XXXXX.")"$base_name"

	ret=$(ffmpeg -y -loglevel "$FFMPEG_LOGLEVEL" -i "$src_f" $FFMPEG_ARGS "$tmp_f")

	size_src=$(du -b "$src_f" | cut -f1)
	size_tmp=$(du -b "$tmp_f" | cut -f1)

	if [[ $ret -ne 0 ]] || [[ $size_tmp -le 0 ]]; then
		echo -e \nffmpeg failed. Exiting.
		exit 1
	fi

	if [[ $size_tmp -lt $size_src ]]; then
		if [[ $DEBUG -ne 0 ]]; then
			echo -n " -> size (old/new): $size_src / $size_tmp"
		fi
		echo " ... replacing!"
		cp "$tmp_f" "$src_f"
	else
		echo
	fi
done

echo Done
