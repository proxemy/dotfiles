#!/usr/bin/env bash

# This script take a single image or folder to decend, creates new versions of
# images and replaces the original, when the new ones are smaller.


set -euo pipefail


OPT_FLAGS="rfetkvdph"

# default option values
RECURSIVE=0
FFMPEG_ARGS="-crf 23 -qscale:v 1.5"
FFMPEG_EXTRA_ARGS=""
TMP_DIR="/dev/shm"
KEEP_TMP_DIR=0
VERBOSE=0
DRY_RUN=0
PEDANTIC=0
PRINT_HELP_AND_EXIT=0

# runtime variables populate below
SOURCE=""
SOURCE_FILES=() # list of single files
FAILED_FILES=()


# init help display
if [[ $@ =~ "-h" ]]; then
	PRINT_HELP_AND_EXIT=1
	echo -e \
		"Usage: '$0' [OPTS] TARGET_PATH \n"\
		"Recompress media files inplace with ffmpeg.\n"\
		"Single files, entire directories with optinal recursion.\nOptions:"
	if [[ "$@" == "-h" ]]; then
		# set all option flags to display all help messages
		for ((i=0; i<${#OPT_FLAGS}; i++)); do
			set -- "$@" "-${OPT_FLAGS:i:1}"
		done
	fi
fi


print_opt_help() {
	local TEXT="$1"
	local DEFAULT="${2:-}"
	if [[ $PRINT_HELP_AND_EXIT -ne 0 ]]; then
		echo "  "$TEXT "Default: '$DEFAULT'"
	fi
}


# parse arguments
while getopts $OPT_FLAGS o; do
	case "$o" in
		r)
			print_opt_help "-r: Flag to traverse down a given target folder." "$RECURSIVE"
			RECURSIVE=1
			;;
		f)
			print_opt_help "-f ARGS: Arguments passed to ffmpeg." "$FFMPEG_ARGS"
			FFMPEG_ARGS="${OPTARG:-$FFMPEG_ARGS}"
			;;
		e)
			print_opt_help "-e ARGS: Extra ffmpeg args to get appended to regular args." "$FFMPEG_EXTRA_ARGS"
			FFMPEG_EXTRA_ARGS="${OPTARG:-$FFMPEG_EXTRA_ARGS}"
			;;
		t)
			print_opt_help "-t DIR: TMP directory to store intermediates." "$TMP_DIR"
			TMP_DIR="${OPTARG:-$TMP_DIR}"
			;;
		k)
			print_opt_help "-k: Flag to keep the TMP directory." "$KEEP_TMP_DIR"
			KEEP_TMP_DIR=1
			;;
		v)
			print_opt_help "-v: Flag to print verbose messages." "$VERBOSE"
			VERBOSE=1
			;;
		d)
			print_opt_help "-d: Flag for a dry run that does not replace files." "$DRY_RUN"
			DRY_RUN=1
			;;
		p)
			print_opt_help "-p: Pedantic flag. Exit on first ffmpeg error." "$PEDANTIC"
			PEDANTIC=1
			;;
		h) ;;
	esac
done
[[ PRINT_HELP_AND_EXIT -ne 0 ]] && exit 255;


SOURCE="${@: -1}"
BASE_DIR=$(dirname "$SOURCE")
if ! [[ -d "$SOURCE" || -f $SOURCE ]]; then
	echo Source file or folder does not exist: "$SOURCE"
	exit 1
fi


on_exit() {
	if [[ $KEEP_TMP_DIR -eq 0 ]]; then
		echo Cleaning up tmp dir: "${TMP_DIR:-''}"
		test -d "${TMP_DIR:-''}" && rm -rf "$TMP_DIR"
	else
		echo Retaining tmp dir: "${TMP_DIR:-''}"
	fi
}
trap on_exit EXIT
TMP_DIR="$(mktemp -dp "$TMP_DIR")"


# single file processing
if [[ -f "$SOURCE" ]]; then
	SOURCE_FILES+=("$SOURCE")

# find all media files in a directory
elif [[ -d "$SOURCE" ]]; then

	if [[ $RECURSIVE -ne 0 ]]; then
		max_depth=""
	else
		max_depth="-maxdepth 1"
	fi

	# because of weird file name characters, find results and bash arrays/loops
	# dont work well together, so we need to separate array items with null bytes
	while IFS= read -r -d $'\0'; do
		source_file="$REPLY"
		mime_type=$(file --mime-type "$source_file")
		if [[ "$mime_type" =~ :\ image|:\ video ]]; then
			SOURCE_FILES+=("$source_file")
		fi
	done < <(find "$SOURCE" $max_depth -type f -print0)

else
	echo "Invalid source argument: $SOURCE"
	exit 1
fi


if [[ ${#SOURCE_FILES[@]} -le 0 ]]; then
	echo No viable image candidates found
	exit 0
fi

echo Found ${#SOURCE_FILES[@]} valid targets
read -p "List candidates? [y/N]" -a cont -n 1
if [[ "${cont:-"N"}" =~ ^Y|y$ ]]; then
	printf '%s\n' "${SOURCE_FILES[@]}"
	echo
fi

read -p "Continue? [Y/n]" -a cont -n 1
if ! [[ "${cont:-"Y"}" =~ ^Y|y$ ]]; then
	exit 0
fi

# Process all file candidates
FFMPEG_LOGLEVEL="error"
if [[ $VERBOSE -ne 0 ]]; then
	FFMPEG_LOGLEVEL="info"
fi

FFMPEG_ARGS="$FFMPEG_ARGS $FFMPEG_EXTRA_ARGS"

renice -n 19 -p $BASHPID


for src_f in "${SOURCE_FILES[@]}"; do

	echo -n Processing: "$src_f"

	base_name=$(basename "$src_f")

	tmp_f=$(mktemp -p "$TMP_DIR" -t "XXXXX.")"$base_name"

	[[ $PEDANTIC -eq 0 ]] && set +e
	ffmpeg -y -loglevel "$FFMPEG_LOGLEVEL" -i "$src_f" $FFMPEG_ARGS "$tmp_f"
	[[ $PEDANTIC -eq 0 ]] && set -e


	if [[ $? -ne 0 ]]; then
		echo ffmpeg failed on: "$src_f"
		[[ $PEDANTIC -ne 0 ]] && exit 1
		FAILED_FILES+=("Non-zero ffmpeg return on: $src_f")
		continue
	fi


	size_src=$(du -b "$src_f" | cut -f1)
	size_tmp=$(du -b "$tmp_f" | cut -f1)

	if [[ $size_tmp -le 0 ]]; then
		FAILED_FILES+=("Zero size convert file from: $src_f")
		continue
	fi


	if [[ $size_tmp -lt $size_src ]]; then
		if [[ $VERBOSE -ne 0 ]]; then
			echo -n " -> size (old/new): $size_src / $size_tmp "
		fi
		if [[ $DRY_RUN -ne 0 ]]; then
			echo "... skipping replacement!"
		else
			echo " ... replacing!"
			cp "$tmp_f" "$src_f"
		fi
	else
		echo
	fi
done

if ! [[ -z ${FAILED_FILES[@]} ]]; then
	echo "Failed files:"
	for ff in "${FAILED_FILES[@]}"; do
		echo "$ff"
	done
fi

echo Done
