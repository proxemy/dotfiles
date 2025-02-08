#!/usr/bin/env python3

# This script takes a path to a know media file and encodes an mp3 file with
# identical name next to it. It is used to strip music video off the video track.


import sys, os
from pathlib import Path


KNOWN_FILE_EXTENSIONS = [
	".webm", ".mp4", ".mkv", "ogg"
]


def sys_exit(error_msg, exit_code):
	print(error_msg)
	sys.exit(exit_code)


if __name__ == "__main__":
	if len(sys.argv) <= 1:
		sys_exit("Invalid args", 1)

	source = Path(sys.argv[1])
	target = source.with_suffix(".mp3")

	print(f"Start source: {source} | target: {target}")

	if not source.exists():
		sys_exit("Source does not exists", 2)

	if source.suffix.lower() not in KNOWN_FILE_EXTENSIONS:
		sys_exit("Unknown file extension", 3)

	if target.exists():
		sys_exit("Target already exists", 4)

	ret = os.system(f"ffmpeg -i \"{source}\" \"{target}\"")

	if ret != 0:
		sys_exit("ffmpeg failed", 5)

	sys_exit("Done", 1)
