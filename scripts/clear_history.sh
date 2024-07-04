#!/usr/bin/false "This script should only be sourced, not run!"

hist_offsets=( $(history | grep "SIZE=" | grep -oP '^\W[0-9]+') )

echo "Deleting '${#hist_offsets[@]}' history entries."

for o in "${hist_offsets[@]}"; do
	echo -n "."
	history -d "$o"
done
echo
