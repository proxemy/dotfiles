#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p python3Packages.fuzzywuzzy

from pathlib import Path
from functools import lru_cache
from itertools import combinations
from fuzzywuzzy import fuzz
from zipfile import ZipFile
import os, sys

from pdb import set_trace as BP

TMP=Path("/dev/shm/tmp_zip")


@lru_cache(maxsize=None)
def compare_names(f1, f2):
	return fuzz.ratio(f1.name, f2.name)

def compare_contents(f1, f2):
	return 0 # TODO: debug zip size comparison
	f1_size = single_zip_size(f1)
	f2_size = single_zip_size(f2)
	paired_size = pair_zip_size(f1, f2)

	return paired_size / (f1_size + f2_size)


@lru_cache(maxsize=None)
def single_zip_size(f1):
	TMP.unlink(missing_ok=True)
	zip = ZipFile(TMP, "w")
	zip.write(f1)
	return TMP.stat().st_size

@lru_cache(maxsize=None)
def pair_zip_size(f1, f2):
	TMP.unlink(missing_ok=True)
	zip = ZipFile(TMP, "w")
	zip.write(f1)
	zip.write(f2)
	zip.close()
	return TMP.stat().st_size


def get_target_files(root_path):
	return list(root_path.glob("**/*"))


def compare_files(target_files):
	ret = []

	for file, other_file in combinations(target_files, 2):
		name_diff = compare_names(file, other_file)
		content_diff = compare_contents(file, other_file)

		ret.append([file, other_file, name_diff, content_diff])

	return ret


def write_results(comparison_resulsts):
	write_result_line = lambda res_line: ";".join(str(r) for r in res_line) + ";\n"

	with open(os.getcwd() + "/RESULT", "w") as result_file:
		for result in comparison_resulsts:
			result_file.write(write_result_line(result))


if __name__ == "__main__":

	root_path = Path(sys.argv[1]).absolute()

	target_files = get_target_files(root_path)

	comparison_resulsts = compare_files(target_files)

	write_results(comparison_resulsts)

