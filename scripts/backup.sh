#!/usr/bin/env bash

set -euo pipefail


declare -a BACKUP_SOURCES=(
	~/Documents/backup.list
)

while read line; do
  BACKUP_SOURCES+=("$line")
done < $BACKUP_SOURCES

backup_folder=BACKUP_`date +%F_%H-%M-%S`
backup_file="$backup_folder".tar.gz

backup_path="${1:-$(pwd)}"
tmp_path="${2:-$(mktemp -dp /dev/shm)}"

on_exit(){
	echo "Cleanup"
	rm -rf "$tmp_path"
}
trap on_exit ERR EXIT

set -x
test -d "$backup_path"
test -d "$tmp_path"
set +x


# gather all listes backup targets in the temorary folder
for source in "${BACKUP_SOURCES[@]}"; do

	source="${source/#\~/$HOME}"

	if [ ! -e "$source" ]; then
		echo -e "WARN: Skipping non existant backup source:\n\t""$source"
		continue
	fi

	echo "->" "$source"
	source_path=`dirname "$source"`
	tmp_backup_path="$tmp_path"/"$backup_folder"/"$source_path"

	mkdir -p "$tmp_backup_path"

	cp -r "$source" "$tmp_backup_path"
done


# compress the temporary backupfiles and move them to its destination
echo -e "\nCreating Archive:\n""$backup_path"/"$backup_file""\n"

cd "$tmp_path"/"$backup_folder"

tar -czf ../"$backup_file" *

mv ../"$backup_file" "$backup_path"/"$backup_file"
