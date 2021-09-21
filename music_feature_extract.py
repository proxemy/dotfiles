#!/usr/bin/env python3

import librosa
import pathlib
import numpy as np
import matplotlib.pyplot as plt
import librosa.display
from typing import List

from pdb import set_trace as BP


def supported_formats():
	from soundfile import available_formats as sf_avail_fmts

	# mp3 is supported via librosas audioread dependecy
	return sorted([ *sf_avail_fmts().keys(), "MP3" ])


__doc__ = \
	"""
	This script takes all audio files, either singular or recursive
	if a directory is passed and generates the several music feature extracts
	for the model to train on.
	Supported formats: [ {} ]
	""".format(", ".join(supported_formats()))


##################
# business logic #
##################


def glob_music_files(input_pathes: List[pathlib.Path]) -> List[pathlib.Path]:
	"""
	If the 'input_pathes' list contains folders, these folders will recursively
	searched for all supported formats: '[ {} ]'
	"""

	ret = set()

	for p in input_pathes:
		if not p.exists():
			raise ValueError(f"'{p}' input path does not exist.")

		if p.is_file():
			if p.suffix[1:].upper() in supported_formats():
				ret.update({p})
			else:
				raise ValueError(f"'{p}' input file format is not supported.")

		elif p.is_dir():
			ret.update([
				f for f in p.rglob("*")
				if f.suffix[1:].upper() in supported_formats()
			])

	if not ret:
		raise ValueError(f"Could't find supported audio files at '{input_pathes}'")

	return ret


glob_music_files.__doc__ = glob_music_files.__doc__.format(
	", ".join(supported_formats())
)


def extract_music_features(music_file: pathlib.Path):
	y, sr = librosa.load(music_file)

	tempo, beat_frames = librosa.beat.beat_track(y=y, sr=sr)

	beat_times = librosa.frames_to_time(beat_frames, sr=sr)

	y_harmonic, y_percussive = librosa.effects.hpss(y)

	mfcc = librosa.feature.mfcc(y=y, sr=sr, hop_length=512, n_mfcc=13)

	mfcc_delta = librosa.feature.delta(mfcc)

	beat_mfcc_delta = librosa.util.sync(
		np.vstack([mfcc, mfcc_delta]), beat_frames
	)

	chromagram = librosa.feature.chroma_cqt(y=y_harmonic, sr=sr)

	beat_chroma = librosa.util.sync(chromagram, beat_frames, aggregate=np.median)

	beat_feature = np.vstack([beat_chroma, beat_mfcc_delta])

	return {
		'y' : y,
		'sr' : sr,
		'tempo' : tempo,
		'beat_frames' : beat_frames,
		'beat_times' : beat_times,
		'y_harmonic' : y_harmonic,
		'y_percussive' : y_percussive,
		'mfcc' : mfcc,
		'mfcc_delta' : mfcc_delta,
		'beat_mfcc_delta' : beat_mfcc_delta,
		'chromagram' : chromagram,
		'beat_chroma' : beat_chroma,
		'beat_feature' : beat_feature
	}


def store_music_features(
	music_file_name,
	music_features,
	output_path: pathlib.Path
):
	for ft_name, feat in (
		(n, f) for n, f in music_features.items() if isinstance(f, np.ndarray)
	):
		try:
			fig, ax = plt.subplots()
			librosa.display.specshow(feat, ax=ax)
			fig.savefig(music_file.name + f".{ft_name}.png")
			plt.close(fig)
		except Exception as e:
			print("EXCEPTION:", e)
			e.args = (*e.args, f"Failed to write feature: '{fname}'" )
			#BP()
			#raise


if __name__ == "__main__":
	import argparse
	arg_parser = argparse.ArgumentParser(description=__doc__)
	for arg in [
		( "-i", {
			"dest" : "input_pathes",
			"type" : pathlib.Path,
			"required" : True,
			"action" : "append",
			"help" : "A single music file or path for recursive lookup. (multiple)"
		}),
		( "-o", {
			"dest" : "output_path",
			"type" : pathlib.Path,
			"default" : pathlib.Path().cwd(),
			"help" : "Output folder. New directories will be created there."
		}),
	]:
		arg_parser.add_argument(arg[0], **arg[1])
	args = arg_parser.parse_args()


	# clean/process/check the input args
	args.input_pathes = glob_music_files(args.input_pathes)

	if not args.output_path.exists():
		raise ValueError(f"'{args.output_path}' ouput path does't exist.")


	print("Reading music features ...")
	music_features = dict()

	for music_file in args.input_pathes:
		print(f"Music file: '{music_file.name}'")

		m_features = extract_music_features(music_file)

		music_features.update({ music_file : m_features })


	print("Writing music features ...")
	for fname, features in music_features.items():
		store_music_features(fname, features, args.output_path)

	BP()




# TODO: args: --reset --librosa-opts