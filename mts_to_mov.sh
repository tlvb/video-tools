#!/bin/bash
set -e
if [[ $# -ne 2 ]] ; then
	echo a search path and an output file is required
	exit 1
elif [[ ! -d $1 ]] ; then
	echo the first parameter should be an existing directory to look in
	exit 1
elif [[ ${2##*.} != mov || -e $2 ]] ; then
	echo the second parameter should have the extension .mov
	echo and should not already exist
	exit 1
fi

nice -n 19 ffmpeg \
	-safe 0 \
	-f concat \
	-i <(find $(readlink -f "$1") \
		-type f -iname \*.MTS \
		-exec echo file {} \; | sort) \
	-s 1920x1080 -r 25 \
	-vcodec dnxhd \
	-vf yadif \
	-acodec pcm_s16le \
	-b:v 185M \
	-threads 0 \
	"$2"
